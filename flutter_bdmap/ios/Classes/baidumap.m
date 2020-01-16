//
//  baidumap.m
//  flutter_bdmap
//
//  Created by 胡杰 on 2020/1/15.
//

#import "baidumap.h"
#import "MyBMKPointAnnotation.h"

#if __has_include(<flutter_bdmap/flutter_bdmap-Swift.h>)
#import <flutter_bdmap/flutter_bdmap-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_bdmap-Swift.h"
#endif

@implementation BDMap
{
    BMKMapView *_mapView; //地图View
    BMKLocationManager * _locationManager ;//定位管理
    BMKUserLocation *_userLocation; //用户定位信息
}



//提供一个全局静态变量
static BDMap * _instance;

+(instancetype)share{
    return [[self alloc]init];
}

//当调用alloc的时候会调用allocWithZone
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    //方案一:加互斥锁,解决多线程访问安全问题
//    @synchronized(self){//同步的
//        if (!_instance) {
//            _instance = [super allocWithZone:zone];
//        }
//    }
    //方案二.GCD dispatch_onec,本身是线程安全的,保证整个程序中只会执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
//严谨
//遵从NSCopying协议,可以通过copy方式创建对象
- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    return _instance;
}
//遵从NSMutableCopying协议,可以通过mutableCopy方式创建对象
- (nonnull id)mutableCopyWithZone:(nullable NSZone *)zone {
    return _instance;
}



-(void)initMap{
    BMKMapManager *mapManager = [[BMKMapManager alloc] init];
    // 如果要关注网络及授权验证事件，请设定generalDelegate参数
    BOOL ret = [mapManager start:@"tZzaP8dTPS42BuQfFog2IBNG6iPT4Cx2"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"百度地图SDK初始化失败");
    }else{
        NSLog(@"百度地图SDK初始化成功");
    }
    
    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:@"tZzaP8dTPS42BuQfFog2IBNG6iPT4Cx2" authDelegate:self];
}

-(UIView *)createMapView:(CGRect)frame{
    _mapView = nil;
    _mapView = [[BMKMapView alloc]initWithFrame:frame];
    _mapView.zoomLevel = 12;
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    _mapView.showMapScaleBar = YES;
    
    [self startLocation];
    return _mapView;
}


- (void)stopLocation{
    if(_locationManager){
        [_locationManager stopUpdatingLocation];
    }
    _locationManager = nil;
    _userLocation = nil;
}

- (void)startLocation{
    //初始化实例
    _locationManager = [[BMKLocationManager alloc] init];
    //设置delegate
    _locationManager.delegate = self;
    //设置返回位置的坐标系类型
    _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
    //设置距离过滤参数
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    //设置预期精度参数
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //设置应用位置类型
    _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    //设置是否自动停止位置更新
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    //设置是否允许后台定位
    _locationManager.allowsBackgroundLocationUpdates = NO;
    //设置位置获取超时时间
    _locationManager.locationTimeout = 10;
    //设置获取地址信息超时时间
    _locationManager.reGeocodeTimeout = 10;
    
    
    [_locationManager startUpdatingLocation];
    
}

- (void)destoryMapView{
    
    [self stopLocation];
    
    _onMarkerClick = nil;
    _userLocation = nil;
    _mapView = nil;
    
    
}

- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didUpdateLocation:(BMKLocation * _Nullable)location orError:(NSError * _Nullable)error{
    if (error){
        NSLog(@"定位失败:{%ld - %@};", (long)error.code, error.localizedDescription);
    }
    if(!_mapView){
        //已经销毁
        return;
    }
    if (location) {//得到定位信息，添加annotation
         
        if (!_userLocation) {
            _userLocation = [[BMKUserLocation alloc] init];
            _mapView.centerCoordinate = location.location.coordinate;
        }
        _userLocation.location = location.location;
        [_mapView updateLocationData:_userLocation];
        
    }else{
        NSLog(@"没有获取到定位信息");
    }
    
    
}

- (void)BMKLocationManager:(BMKLocationManager *)manager didUpdateHeading:(CLHeading *)heading {
    if (!heading) {
        return;
    }
    if(!_mapView){
        //地图已经销毁
        return;
    }
    
    if (!_userLocation) {
        _userLocation = [[BMKUserLocation alloc] init];
    }
    _userLocation.heading = heading;
    [_mapView updateLocationData:_userLocation];
    
    
}


-(void)showMarkerInfos:(NSArray<MarkerInfo *>*)markerInfos{
    if(_mapView){
        _mapView.isSelectedAnnotationViewFront = YES;
        if(_mapView.annotations){
            [_mapView removeAnnotations:_mapView.annotations];
        }
        
        
        NSMutableArray *annotations = [[NSMutableArray alloc] init];
        for (int i = 0; i < markerInfos.count; i++) {
            MarkerInfo* marker = markerInfos[i];
            
            
            MyBMKPointAnnotation* annotation = [[MyBMKPointAnnotation alloc]init];
            
            
            
            annotation.coordinate = CLLocationCoordinate2DMake(marker.latitude, marker.longitude);
                   //设置标注的标题
            annotation.title = marker.title;
                   //副标题
            annotation.subtitle = marker.subTitle;
            
            annotation.headerUrl = marker.headUrl;
            annotation.userId = marker.userId;
            
            [annotations addObject:annotation];
            
        }
        
       
        [_mapView addAnnotations:annotations];
        
        
    }
    
    
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MyBMKPointAnnotation class]]) {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        BMKAnnotationView*annotationView = (BMKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil) {
            annotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        
        annotationView.canShowCallout= YES;
        annotationView.selected = YES;
        annotationView.hidePaopaoWhenDrag = NO;
        annotationView.hidePaopaoWhenDoubleTapOnMap = NO;
        annotationView.hidePaopaoWhenTwoFingersTapOnMap = NO;
        annotationView.hidePaopaoWhenSingleTapOnMap = NO;
        annotationView.hidePaopaoWhenSelectOthers = NO;
        annotationView.hidePaopaoWhenDragOthers = NO;
        
        
        
        
        MarkerInfoView * customPopView = [[MarkerInfoView alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    
        

        [customPopView initSubViewWithHeaderUrl:((MyBMKPointAnnotation*)annotation).headerUrl userId:((MyBMKPointAnnotation*)annotation).userId title:annotation.title subTitle:annotation.subtitle];
      
        
        BMKActionPaopaoView *pView = [[BMKActionPaopaoView alloc] initWithCustomView:customPopView];
    
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onMarkerInfoViewClick:)];
        
        [customPopView addGestureRecognizer:tap];
        
        
        
        pView.frame = customPopView.frame;
        annotationView.paopaoView = pView;
       
        
    
        return annotationView;
    }
    return nil;
}

-(void)onMarkerInfoViewClick:(id)sender{
    
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    MarkerInfoView *markerView = (MarkerInfoView*) tap.view;
    if(self.onMarkerClick){
        self.onMarkerClick(markerView.userId);
    }
    
    
    
}


- (void)onCheckPermissionState:(BMKLocationAuthErrorCode)iError{
    NSLog(@"定位SDK初始化%ld",(long)iError);
    
}

@end



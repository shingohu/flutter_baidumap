//
//  baidumap.h
//  Pods
//
//  Created by 胡杰 on 2020/1/15.
//
#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h> //地图相关API

#import <BaiduMapAPI_Map/BMKPointAnnotation.h>
#import <BMKLocationkit/BMKLocationComponent.h> //定位相关API


#if __has_include(<flutter_bdmap/flutter_bdmap-Swift.h>)
#import <flutter_bdmap/flutter_bdmap-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_bdmap-Swift.h"
#endif





typedef void(^OnMarkerClick)(NSString*);


@interface BDMap : NSObject<NSCopying,NSMutableCopying,BMKLocationAuthDelegate,BMKLocationManagerDelegate,BMKMapViewDelegate>



+(instancetype)share;

-(void)initMap;


//定义Block对象
@property (copy, nonatomic) OnMarkerClick onMarkerClick;

//创建
-(UIView*)createMapView:(CGRect)frame;

//销毁
-(void)destoryMapView;

//开启定位
-(void)startLocation;

//停止定位
-(void)stopLocation;


//显示标记
-(void)showMarkerInfos:(NSArray<MarkerInfo*>*)markerInfos;

@end


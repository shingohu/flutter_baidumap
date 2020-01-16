//
//  MyBMKPointAnnotation.h
//  flutter_bdmap
//
//  Created by 胡杰 on 2020/1/16.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Map/BMKPointAnnotation.h>
NS_ASSUME_NONNULL_BEGIN

@interface MyBMKPointAnnotation : BMKPointAnnotation
@property (copy) NSString *headerUrl;
@property (copy) NSString *userId;
@end

NS_ASSUME_NONNULL_END

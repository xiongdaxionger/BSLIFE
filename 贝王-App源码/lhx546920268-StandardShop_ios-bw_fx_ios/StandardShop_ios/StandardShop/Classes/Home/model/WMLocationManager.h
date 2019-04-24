//
//  WMLocationManager.h
//  DreamEnjoyLife
//
//  Created by 罗海雄 on 2018/4/4.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/**
 定位完成回调

 @param coordinate 坐标
 */
typedef void(^WMLocationCompletionHandler)(CLLocationCoordinate2D coordinate);

/**
 获取定位城市完成回调

 @param coordinate 坐标
 @param city 当前城市
 */
typedef void(^WMFetchLocationCityCompletionHandler)(CLLocationCoordinate2D coordinate, NSString *city);

///定位管理
@interface WMLocationManager : NSObject

///单例
+ (instancetype)sharedInstance;

///当前位置
@property(nonatomic, readonly) CLLocationCoordinate2D coordinate;

///当前城市
@property(nonatomic, readonly) NSString *city;

///定位完成回调
@property(nonatomic, readonly) NSMutableSet<WMLocationCompletionHandler> *locationCompletionHandlers;

///获取位置完成回调完成回调
@property(nonatomic, readonly) NSMutableSet<WMFetchLocationCityCompletionHandler> *fetchLocationCityCompletionHandlers;

///开始定位
- (void)startLocation;

@end

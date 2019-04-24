//
//  WMLocationManager.m
//  DreamEnjoyLife
//
//  Created by 罗海雄 on 2018/4/4.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import "WMLocationManager.h"

@interface WMLocationManager()<CLLocationManagerDelegate>

///定位管理器
@property(nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation WMLocationManager

///重写 getter 方法时需要
@synthesize locationCompletionHandlers = _locationCompletionHandlers;
@synthesize fetchLocationCityCompletionHandlers = _fetchLocationCityCompletionHandlers;
@synthesize city = _city;
@synthesize coordinate = _coordinate;

///单例
+ (instancetype)sharedInstance
{
    static WMLocationManager *sharedLocationManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLocationManager = [WMLocationManager new];
    });
    
    return sharedLocationManager;
}

- (NSMutableSet<WMLocationCompletionHandler>*)locationCompletionHandlers
{
    if(!_locationCompletionHandlers){
        _locationCompletionHandlers = [NSMutableSet set];
    }
    
    return _locationCompletionHandlers;
}

- (NSMutableSet<WMFetchLocationCityCompletionHandler>*)fetchLocationCityCompletionHandlers
{
    if(!_fetchLocationCityCompletionHandlers){
        _fetchLocationCityCompletionHandlers = [NSMutableSet set];
    }
    
    return _fetchLocationCityCompletionHandlers;
}

- (NSString*)city
{
    if([NSString isEmpty:_city]){
        return @"广州市";
    }
    
    return _city;
}

- (CLLocationCoordinate2D)coordinate
{
    if(!CLLocationCoordinate2DIsValid(_coordinate)){
        return CLLocationCoordinate2DMake(0.0, 0.0);
    }
    
    return _coordinate;
}

///定位
- (void)startLocation
{
    if(!self.locationManager){
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
    }
   
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
        [self.locationManager requestAlwaysAuthorization];
    }
    
    if([self locationEnable]){
        [self.locationManager startUpdatingLocation];
    }else if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        [self alertFailLocationMsg];
        [self executeLocationCompletionHandlers];
        [self executeFetchLocationCityCompletionHandlers];
    }
}

///提示不能定位的信息
- (void)alertFailLocationMsg
{
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        NSString *msg = [NSString stringWithFormat:@"定位失败，请在本机的“设置-隐私-定位服务”中设置,允许%@使用您的定位功能", appName()];

        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消", @"去设置", nil];
        [alertView show];
    }else if([CLLocationManager authorizationStatus] != kCLAuthorizationStatusNotDetermined){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"定位失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

///判断是否可以定位
- (BOOL)locationEnable
{
    return [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse;
}

#pragma mark- CLLocationManager delegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if([self locationEnable]){
        [self startLocation];
    }else if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        [self executeLocationCompletionHandlers];
        [self executeFetchLocationCityCompletionHandlers];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    if(CLLocationCoordinate2DIsValid(location.coordinate)){
        [manager stopUpdatingLocation];
        _coordinate = location.coordinate;
        NSLog(@"定位经纬度%.2f %.2f",_coordinate.latitude,_coordinate.longitude);
        [self executeLocationCompletionHandlers];
        [self getLocationCity:location];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [manager stopUpdatingLocation];
    _coordinate = CLLocationCoordinate2DMake(0, 0);
    [self executeLocationCompletionHandlers];
    [self executeFetchLocationCityCompletionHandlers];
    [self alertFailLocationMsg];
}

///获取定位城市
- (void)getLocationCity:(CLLocation *)location
{
    if(location != nil){
        CLGeocoder *coder = [CLGeocoder new];
        [coder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            
            if (error == nil){
                CLPlacemark *placeMark = [placemarks firstObject];
                
                _city = [placeMark.addressDictionary sea_stringForKey:@"City"];

                [self executeFetchLocationCityCompletionHandlers];
            }else{
                [self getLocationCity:nil];
            }
        }];
    }else{
        
        _city = nil;

        [self executeFetchLocationCityCompletionHandlers];
    }
}

#pragma mark handler

///执行定位完成回调
- (void)executeLocationCompletionHandlers
{
    for(WMLocationCompletionHandler handler in _locationCompletionHandlers){
        handler(self.coordinate);
    }
}

///执行获取城市完成回调
- (void)executeFetchLocationCityCompletionHandlers
{
    for(WMFetchLocationCityCompletionHandler handler in _fetchLocationCityCompletionHandlers){
        handler(self.coordinate, self.city);
    }
}

@end

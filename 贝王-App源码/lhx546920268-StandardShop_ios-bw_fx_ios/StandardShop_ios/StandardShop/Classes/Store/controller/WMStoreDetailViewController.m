//
//  WMStoreDetailViewController.m
//  SuYan
//
//  Created by 罗海雄 on 16/4/15.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMStoreDetailViewController.h"

#import "WMStoreListInfo.h"

#import <MAMapKit/MAMapKit.h>
#import "WMStoreDetailBottomView.h"

@interface WMStoreDetailViewController ()<MAMapViewDelegate>

///门店信息
@property(nonatomic,strong) WMStoreListInfo *info;

///地图
@property(nonatomic,strong) MAMapView *mapView;

@end

@implementation WMStoreDetailViewController

///构造方法
- (instancetype)initWithInfo:(WMStoreListInfo *) info
{
    self = [super initWithNibName:nil bundle:nil];
    if(self)
    {
        self.info = info;
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"门店详情";
    
    self.backItem = YES;
    
    [self initialization];
}

- (void)initialization
{
    ///地图
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, _width_, _height_ - (isIPhoneX ? 88.0 : 64.0))];
    
    self.mapView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.mapView.delegate = self;
    
    self.mapView.showsCompass = NO;
    
    self.mapView.showsScale = NO;
    
    [self.view addSubview:self.mapView];
    
    WMStoreDetailBottomView *bottomView = [WMStoreDetailBottomView new];
    
    bottomView.frame = CGRectMake(0, self.mapView.bottom - 64.0, _width_, 64.0);
    
    [bottomView.shopLogo sea_setImageWithURL:self.info.storeLogo];
    
    bottomView.shopNameLabel.text = self.info.name;
    
    bottomView.timeLabel.text = [NSString stringWithFormat:@"营业时间:%@",self.info.openTime];
    
    bottomView.mobileLabel.text = [NSString stringWithFormat:@"联系方式:%@",self.info.mobile];
    
    [bottomView.mobileButton addTarget:self action:@selector(callMobile) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:bottomView];
}

- (void)callMobile {
    
    makePhoneCall(self.info.mobile, YES);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    
    annotation.title = self.info.name;
    
    annotation.subtitle = self.info.completeAddress;
    
    annotation.coordinate = CLLocationCoordinate2DMake(self.info.latitude.floatValue, self.info.longitude.floatValue);
    
    //添加门店标注
    [self.mapView addAnnotation:annotation];
    
    MACoordinateRegion region = MACoordinateRegionMakeWithDistance(annotation.coordinate,5000.0,5000.0);
    
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:NO];
    
    [self.mapView selectAnnotation:annotation animated:NO];
}

#pragma mark- MAMapView delegate

///大头针
- (MAAnnotationView*)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reusedIdentifier = @"reusedIdentifier1";
        
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:reusedIdentifier];
        
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reusedIdentifier];
            
            annotationView.canShowCallout = YES;
                        
            annotationView.animatesDrop  = YES;
            
            annotationView.pinColor = MAPinAnnotationColorRed;
        }
        
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view
{
    
}


@end

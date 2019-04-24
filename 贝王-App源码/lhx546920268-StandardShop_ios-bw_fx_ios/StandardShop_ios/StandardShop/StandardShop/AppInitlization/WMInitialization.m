//
//  WMInitialization.m
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/11/30.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMInitialization.h"

@implementation WMInitialization

///app样式初始化
+ (void)initialization
{
    [SeaBasicInitialization sea_setAppMainColor:[UIColor colorFromHexadecimal:@"f73030"]];
    [SeaBasicInitialization sea_setButtonBackgroundColor:[UIColor colorFromHexadecimal:@"f73030"]];
    [SeaBasicInitialization sea_setNavigationBarColor:[UIColor colorWithWhite:1.0 alpha:0.9]];
    [SeaBasicInitialization sea_setTintColor:[UIColor colorFromHexadecimal:@"9fa0a0"]];
    [SeaBasicInitialization sea_setButtonTitleColor:[UIColor whiteColor]];
    [SeaBasicInitialization sea_setStatusBarStyle:UIStatusBarStyleDefault];
}

@end

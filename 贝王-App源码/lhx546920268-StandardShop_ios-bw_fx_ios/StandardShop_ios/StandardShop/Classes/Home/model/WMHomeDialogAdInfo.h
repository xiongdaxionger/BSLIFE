//
//  WMHomeDialogAdInfo.h
//  StandardShop
//
//  Created by Hank on 2018/6/6.
//  Copyright © 2018年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WMHomeAdInfo;
///首页弹窗广告数据
@interface WMHomeDialogAdInfo : NSObject

///广告数据
@property (strong,nonatomic) WMHomeAdInfo *adInfo;

///后台设置是否开启广告
@property (assign,nonatomic) BOOL isOpenSetting;

///时间判断是否显示广告
@property (assign,nonatomic) BOOL needShowAd;

///解析数据
+ (WMHomeDialogAdInfo *)parseInfoWithDict:(NSDictionary *)dict;
@end

//
//  WMPartnerListSearchViewController.h
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/23.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMPushSearchViewController.h"

@class WMPartnerInfo;

///会员列表搜索
@interface WMPartnerListSearchViewController : WMPushSearchViewController

///选中会员回调
@property(nonatomic,copy) void(^selectPartnerHandler)(WMPartnerInfo *info);

@end

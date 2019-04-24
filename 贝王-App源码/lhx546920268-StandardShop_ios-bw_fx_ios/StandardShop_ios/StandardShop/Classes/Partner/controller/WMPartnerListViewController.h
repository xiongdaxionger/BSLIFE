//
//  WMPartnerListViewController.h
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/2.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

@class WMPartnerListSearchViewController, WMPartnerInfo;

/**会员列表
 */
@interface WMPartnerListViewController : SeaTableViewController

///搜索关键字
@property(nonatomic,copy) NSString *searchKey;

///关联的搜索控制器
@property(nonatomic,weak) WMPartnerListSearchViewController *partnerListSearchViewController;

///选中会员回调
@property(nonatomic,copy) void(^selectPartnerHandler)(WMPartnerInfo *info);

///刷新数据
- (void)refreshManually;

@end

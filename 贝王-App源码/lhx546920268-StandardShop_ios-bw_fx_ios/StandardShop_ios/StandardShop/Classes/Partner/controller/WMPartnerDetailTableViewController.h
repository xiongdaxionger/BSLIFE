//
//  WMPartDetailTableViewController.h
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/3.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMPartnerInfo.h"

/**会员详情信息列表父类
 */
@interface WMPartnerDetailTableViewController : SeaTableViewController

///网络请求
@property(nonatomic,strong) SeaHttpRequest *httpRequest;

///列表信息，数组元素根据子类定义
@property(nonatomic,strong) NSMutableArray *infos;

///会员信息
@property(nonatomic,strong) WMPartnerInfo *info;

/**构造方法
 *@param info 客户信息
 *@return 一个实例
 */
- (instancetype)initWithPartnerInfo:(WMPartnerInfo*) info;

@end

//
//  WMPartnerDetailViewController.h
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/3.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//


@class WMPartnerInfo;

/**客户详情
 */
@interface WMPartnerDetailViewController : SeaViewController

///是否是查看下线的下线
@property(nonatomic,assign) BOOL isSeeSecondReferral;

///可查看的层级 小于等于1时无法查看团队
@property(nonatomic,assign) int hierarchy;

/**构造方法
 *@param info 客户信息
 *@return 一个实例
 */
- (instancetype)initWithPartnerInfo:(WMPartnerInfo*) info;

@end

//
//  WMPartnerTeamViewController.h
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/3.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMPartnerDetailTableViewController.h"

/**会员 团队
 */
@interface WMPartnerTeamViewController : WMPartnerDetailTableViewController

///可查看的层级 小于等于1时无法查看团队
@property(nonatomic,assign) int hierarchy;

@end

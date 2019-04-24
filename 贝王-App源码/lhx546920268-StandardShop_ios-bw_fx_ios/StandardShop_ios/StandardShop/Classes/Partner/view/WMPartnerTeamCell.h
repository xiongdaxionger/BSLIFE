//
//  WMPartnerTeamCell.h
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/3.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

///行高 边距
#define WMPartnerTeamCellHeight 91.0
#define WMPartnerTeamCellMargin 10.0

@class WMPartnerInfo;

/**会员团队列表
 */
@interface WMPartnerTeamCell : UITableViewCell

///头像
@property (weak, nonatomic) IBOutlet UIImageView *head_imageView;

///昵称
@property (weak, nonatomic) IBOutlet UILabel *name_label;

///订单数量
@property (weak, nonatomic) IBOutlet UILabel *order_count_label;

///累计收益
@property (weak, nonatomic) IBOutlet UILabel *earn_label;

///会员信息
@property (strong, nonatomic) WMPartnerInfo *info;


@end

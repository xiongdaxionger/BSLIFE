//
//  WMPartnerListCell.h
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/2.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMPartnerLevelView, WMPartnerInfo;

#define WMPartnerListCellHeight 91.0
#define WMPartnerListCellMargin 10.0

/**会员列表
 */
@interface WMPartnerListCell : UITableViewCell

///头像
@property (weak, nonatomic) IBOutlet UIImageView *head_imageView;

///名称
@property (weak, nonatomic) IBOutlet UILabel *name_label;

///等级
@property (weak, nonatomic) IBOutlet WMPartnerLevelView *level_view;

///带来收益金额
@property (weak, nonatomic) IBOutlet UILabel *earn_amount_label;

///带来收益标题
@property (weak, nonatomic) IBOutlet UILabel *earn_title_label;

///下线人数
@property (weak, nonatomic) IBOutlet UILabel *referral_num_label;

///会员信息
@property (strong, nonatomic) WMPartnerInfo *info;

@end

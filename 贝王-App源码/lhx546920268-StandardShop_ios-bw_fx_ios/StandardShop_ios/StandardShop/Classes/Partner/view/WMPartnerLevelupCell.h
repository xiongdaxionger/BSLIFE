//
//  WMPartnerLevelupCell.h
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/3.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMPartnerLevelupCell, WMPartnerInfo;

/**升级会员列表代理
 */
@protocol WMPartnerLevelupCellDelegate <NSObject>

///升级
- (void)partnerLevelupCellDidLevelup:(WMPartnerLevelupCell*) cell;

@end

///行高
#define WMPartnerLevelupCellHeight 81.0

/**升级会员列表
 */
@interface WMPartnerLevelupCell : UITableViewCell

///头像
@property (weak, nonatomic) IBOutlet UIImageView *head_imageView;

///昵称
@property (weak, nonatomic) IBOutlet UILabel *name_label;

///手机号码
@property (weak, nonatomic) IBOutlet UILabel *phone_number_label;

///升级按钮
@property (weak, nonatomic) IBOutlet UIButton *levelup_btn;

@property (weak, nonatomic) id<WMPartnerLevelupCellDelegate> delegate;

///会员信息
@property (strong, nonatomic) WMPartnerInfo *info;

@end

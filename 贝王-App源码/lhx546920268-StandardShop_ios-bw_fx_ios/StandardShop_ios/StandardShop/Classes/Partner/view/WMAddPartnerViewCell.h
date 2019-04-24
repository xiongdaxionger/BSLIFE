//
//  AddCustomerTableViewCell.h
//  WestMailDutyFee
//
//  Created by mac on 15/8/26.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

/**新增会员列表
 */
@interface WMAddPartnerViewCell : UITableViewCell

///图标
@property (weak, nonatomic) IBOutlet UIImageView *icon_imageView;

///标题
@property (weak, nonatomic) IBOutlet UILabel *title_label;

///简介
@property (weak, nonatomic) IBOutlet UILabel *intro_label;

///内容字典
@property(strong,nonatomic) NSDictionary * dic;

@end

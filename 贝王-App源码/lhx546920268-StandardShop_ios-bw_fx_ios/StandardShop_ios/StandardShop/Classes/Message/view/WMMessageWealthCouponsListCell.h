//
//  WMMessageWealthCouponsListCell.h
//  StandardShop
//
//  Created by 罗海雄 on 16/7/18.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMMessageCouponsInfo;

///边距
#define WMMessageWealthCouponsListCellMargin 10.0

///行高
#define WMMessageWealthCouponsListCellHeight 112.0

///财富 优惠券消息
@interface WMMessageWealthCouponsListCell : UITableViewCell

///标题
@property (weak, nonatomic) IBOutlet UILabel *title_label;

///优惠券背景
@property (weak, nonatomic) IBOutlet UIImageView *coupons_bg_imageView;

///副标题
@property (weak, nonatomic) IBOutlet UILabel *subtitle_label;

///优惠券金额
@property (weak, nonatomic) IBOutlet UILabel *amount_label;

///状态
@property (weak, nonatomic) IBOutlet UILabel *status_label;

///消息
@property (strong, nonatomic) WMMessageCouponsInfo *info;

@end

//
//  WMTopupActivityCell.h
//  StandardShop
//
//  Created by 罗海雄 on 16/7/6.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMTopupActivityInfo,WMTopupActivityCell;

///行高
#define WMTopupActivityCellHeight 90.0

///间隔
#define WMTopupActivityCellInterval 5.0

///活动列表代理
@protocol WMTopupActivityCellDelegate <NSObject>

///充值
- (void)topupActivityCellDidTopup:(WMTopupActivityCell*) cell;

@end

///充值活动列表
@interface WMTopupActivityCell : UITableViewCell

///标题
@property (weak, nonatomic) IBOutlet SeaTextInsetLabel *name_label;

///描述
@property (weak, nonatomic) IBOutlet UILabel *desc_label;

///充值按钮
@property (weak, nonatomic) IBOutlet UIButton *topup_btn;

///活动信息
@property (strong, nonatomic) WMTopupActivityInfo *info;

@property (weak, nonatomic) id<WMTopupActivityCellDelegate> delegate;

@end

///充值活动列表，没充值按钮
@interface WMTopupActivityNoTopupBtnCell : UITableViewCell

///标题
@property (readonly, nonatomic) SeaTextInsetLabel *name_label;

///描述
@property (readonly, nonatomic) UILabel *desc_label;

///活动信息
@property (strong, nonatomic) WMTopupActivityInfo *info;

@end

//
//  WMCouponsListCell.h
//  WuMei
//
//  Created by 罗海雄 on 15/7/23.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WMCouponsListCellMargin 10.0
#define WMCouponsListCellHeight (110.0 + WMCouponsListCellMargin)

@class WMCouponsListCell, WMCouponsInfo;

@protocol WMCouponsListCellDelegate <NSObject>

/**选择状态改变
 */
- (void)couponsListCellCellDidSelect:(WMCouponsListCell*) cell;


@end

/**优惠券列表
 */
@interface WMCouponsListCell : UITableViewCell

///顶部背景
@property (weak, nonatomic) IBOutlet UIView *top_bg_view;

///标题
@property (weak, nonatomic) IBOutlet UILabel *title_label;

///副标题
@property (weak, nonatomic) IBOutlet UILabel *subtitle_label;

///使用按钮背景
@property (weak, nonatomic) IBOutlet UIView *use_bg_view;

///使用按钮
@property (weak, nonatomic) IBOutlet UIButton *use_btn;

/**优惠券名称
 */
@property(weak, nonatomic) IBOutlet UILabel *nameLabel;

/**时间 有效期
 */
@property(weak, nonatomic) IBOutlet UILabel *timeLabel;

///状态背景
@property (weak, nonatomic) IBOutlet UIView *status_bg_view;
@property (weak, nonatomic) IBOutlet UIView *back_view;

///状态
@property (weak, nonatomic) IBOutlet UILabel *status_label;

@property(nonatomic,weak) id<WMCouponsListCellDelegate> delegate;

/**优惠券信息
 */
@property(nonatomic,strong) WMCouponsInfo *info;

@end

//
//  WMDrawCouponsListCell.h
//  StandardShop
//
//  Created by 罗海雄 on 16/7/1.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

///边距
#define WMDrawCouponsListCellMargin 10.0

///高度
#define WMDrawCouponsListCellHeight (110.0 + WMDrawCouponsListCellMargin)

@class WMDrawCouponsListCell, WMCouponsInfo;

///领券中心列表代理
@protocol WMDrawCouponsListCellDelegate <NSObject>

/**立即领取
 */
- (void)drawCouponsListCellDidDraw:(WMDrawCouponsListCell*) cell;


@end

///领券中心列表
@interface WMDrawCouponsListCell : UITableViewCell

///顶部背景
@property (weak, nonatomic) IBOutlet UIView *top_bg_view;

///标题
@property (weak, nonatomic) IBOutlet UILabel *title_label;

///副标题
@property (weak, nonatomic) IBOutlet UILabel *subtitle_label;

///使用按钮
@property (weak, nonatomic) IBOutlet UIButton *draw_btn;

/**优惠券名称
 */
@property(weak, nonatomic) IBOutlet UILabel *nameLabel;

/**时间 有效期
 */
@property(weak, nonatomic) IBOutlet UILabel *timeLabel;
/**背景图
 */
@property (weak, nonatomic) IBOutlet UIView *back_view;

@property(nonatomic,weak) id<WMDrawCouponsListCellDelegate> delegate;

/**优惠券信息
 */
@property(nonatomic,strong) WMCouponsInfo *info;

@end

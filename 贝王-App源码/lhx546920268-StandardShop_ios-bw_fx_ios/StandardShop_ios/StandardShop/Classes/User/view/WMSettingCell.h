//
//  WMSettingCell.h
//  WestMailDutyFee
//
//  Created by 罗海雄 on 15/8/26.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

/**设置信息列表cell
 */
@interface WMSettingCell : UITableViewCell

/**信息标题
 */
@property(nonatomic,readonly) UILabel *titleLabel;

/**信息内容
 */
@property(nonatomic,readonly) UILabel *contentLabel;

/**获取内容高度
 */
@property(nonatomic,assign) CGFloat contentHeight;

/**标题宽度
 */
@property(nonatomic,assign) CGFloat titleWidth;

/**箭头
 */
@property(nonatomic,readonly) UIImageView *arrowImageView;


@end



/**头像cell
 */
@interface WMSettingHeadImageCell : UITableViewCell

/**信息标题
 */
@property(nonatomic,readonly) UILabel *titleLabel;

/**头像
 */
@property(nonatomic,readonly) UIImageView *headImageView;

/**箭头
 */
@property(nonatomic,readonly) UIImageView *arrowImageView;

@end

@class WMSettingSwitchCell;

/**开关cell代理
 */
@protocol WMSettingSwitchCellDelegate <NSObject>

/**开关状态改变
 */
- (void)settingSwitchCellSwitchDidChange:(WMSettingSwitchCell*) cell;

@end

/**开关cell
 */
@interface WMSettingSwitchCell : UITableViewCell

/**信息标题
 */
@property(nonatomic,readonly) UILabel *titleLabel;

/**开关
 */
@property(nonatomic,readonly) UISwitch *switchButton;

@property(nonatomic,weak) id<WMSettingSwitchCellDelegate> delegate;

@end
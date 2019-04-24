//
//  WMDistributionFuncButtonCell.h
//  WestMailDutyFee
//
//  Created by 罗海雄 on 15/8/26.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMUserInfo;

/**按钮间隔
 */
#define WMDistributionFuncButtonCellMargin 1.0

/**每行按钮数量
 */
#define WMDistributionFuncButtonCellCountPerRow 3

/**按钮大小
 */
#define WMDistributionFuncButtonCellSize CGSizeMake((_width_ - WMDistributionFuncButtonCellMargin * (WMDistributionFuncButtonCellCountPerRow - 1)) / WMDistributionFuncButtonCellCountPerRow, (_width_ - WMDistributionFuncButtonCellMargin * (WMDistributionFuncButtonCellCountPerRow - 1)) / WMDistributionFuncButtonCellCountPerRow)

@class WMDistributionFuncButtonInfo;

@class WMDistributionFuncButtonCell;

/**分销首页功能按钮
 */
@interface WMDistributionFuncButtonCell : UICollectionViewCell

/**按钮标题
 */
@property(nonatomic,readonly) UILabel *titleLabel;

/**按钮图标
 */
@property(nonatomic,readonly) UIImageView *iconImageView;

///按钮信息
@property(nonatomic,strong) WMDistributionFuncButtonInfo *info;

@end



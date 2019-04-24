//
//  WMDistributionEarningsCell.h
//  StandardShop
//
//  Created by 罗海雄 on 16/7/19.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

///大小
#define WMDistributionEarningsCellSize CGSizeMake(floor(_width_ / 3.0), 75.0)

///分销首页 收益cell
@interface WMDistributionEarningsCell : UICollectionViewCell

///标题
@property(nonatomic,readonly) UILabel *titleLabel;

///内容
@property(nonatomic,readonly) UILabel *contentLabel;

@end

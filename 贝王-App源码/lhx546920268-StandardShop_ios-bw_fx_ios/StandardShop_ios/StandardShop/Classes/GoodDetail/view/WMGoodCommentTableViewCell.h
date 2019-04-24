//
//  WMGoodCommentTableViewCell.h
//  StandardShop
//
//  Created by mac on 16/6/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XTableCellConfigExDelegate.h"

@class WMGoodCommentScoreView;

#define WMGoodCommentTableViewCellIden @"WMGoodCommentTableViewCell"
#define WMGoodCommentTableViewCellHeight 44.0
/**商品评分视图
 */
@interface WMGoodCommentTableViewCell : UITableViewCell<XTableCellConfigExDelegate>
/**标题
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/**好评率
 */
@property (weak, nonatomic) IBOutlet UILabel *goodRateLabel;

/**配置数据
 */
- (void)configureCellWithModel:(id)model;

@end

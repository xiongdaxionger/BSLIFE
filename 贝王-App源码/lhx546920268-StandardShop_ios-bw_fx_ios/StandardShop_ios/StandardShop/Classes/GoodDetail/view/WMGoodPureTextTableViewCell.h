//
//  WMGoodPureTextTableViewCell.h
//  StandardShop
//
//  Created by mac on 16/6/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XTableCellConfigExDelegate.h"
#define WMGoodPureTextTableViewCellIden @"WMGoodPureTextTableViewCellIden"
#define WMGoodPureTextTableViewCellHeight 44.0
//文本内容最小高度
#define WMGoodTextMinHeight 27.0
//文本内容额外宽度--计算文本高度
#define WMGoodTextExtraWidth 16.0
/**商品的纯文本显示
 */
@interface WMGoodPureTextTableViewCell : UITableViewCell<XTableCellConfigExDelegate>
/**文本显示
 */
@property (weak, nonatomic) IBOutlet UILabel *textContentLabel;
/**分割线
 */
@property (weak, nonatomic) IBOutlet UIView *lineView;
/**分割线高度
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewHeight;

/**配置数据
 */
- (void)configureCellWithModel:(id)model;
@end

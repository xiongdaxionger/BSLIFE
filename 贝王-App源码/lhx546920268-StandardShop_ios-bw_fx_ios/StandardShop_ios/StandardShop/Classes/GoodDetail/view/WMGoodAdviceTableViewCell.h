//
//  WMGoodAdviceTableViewCell.h
//  StandardShop
//
//  Created by mac on 16/6/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XTableCellConfigExDelegate.h"
#define WMGoodAdviceTableViewCellIden @"WMGoodAdviceTableViewCell"
#define WMGoodAdviceTableViewCellHeight 46.0
/**商品咨询显示
 */
@interface WMGoodAdviceTableViewCell : UITableViewCell<XTableCellConfigExDelegate>
/**咨询内容显示
 */
@property (weak, nonatomic) IBOutlet UIButton *contentButton;
/**配置数据
 */
- (void)configureCellWithModel:(id)model;
@end

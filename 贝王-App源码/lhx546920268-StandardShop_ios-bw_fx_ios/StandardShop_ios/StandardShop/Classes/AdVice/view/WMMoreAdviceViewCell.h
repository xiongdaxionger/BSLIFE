//
//  WMMoreAdviceViewCell.h
//  StandardShop
//
//  Created by mac on 16/6/2.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XTableCellConfigExDelegate.h"
//单元格高度
#define WMMoreAdviceViewCellHeight 35.0
//单元格标识符
#define WMMoreAdviceViewCellIdentifier @"WMMoreAdviceViewCellIdentifier"
/**展开查看更多咨询单元格
 */
@interface WMMoreAdviceViewCell : UITableViewCell<XTableCellConfigExDelegate>
/**展示更多文本
 */
@property (weak, nonatomic) IBOutlet UILabel *moreLabel;
/**回调
 */
@property (copy,nonatomic) void(^callBack)(UITableViewCell *cell);

- (void)configureCellWithModel:(id)model;
@end

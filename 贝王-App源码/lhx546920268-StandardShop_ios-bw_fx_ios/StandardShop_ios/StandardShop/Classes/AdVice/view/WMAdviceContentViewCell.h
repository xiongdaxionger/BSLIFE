//
//  WMAdviceContentViewCell.h
//  StandardShop
//
//  Created by mac on 16/6/2.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XTableCellConfigExDelegate.h"
//单元格高度
#define WMAdviceContentViewCellHeight 44.0
//单元格标识ID
#define WMAdviceContentViewCellIdentifer @"WMAdviceContentViewCellIdentifer"
/**咨询内容展示单元格
 */
@interface WMAdviceContentViewCell : UITableViewCell<XTableCellConfigExDelegate>
/**类型文本
 */
@property (weak, nonatomic) IBOutlet UILabel *adviceTypeLabel;
/**内容文本
 */
@property (weak, nonatomic) IBOutlet UILabel *adviceContentLabel;
/**回复咨询按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *adviceReplyButton;
/**回复按钮的宽度约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *replyButtonWidth;

- (void)configureCellWithModel:(id)model;
@end

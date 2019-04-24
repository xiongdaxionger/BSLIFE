//
//  WMAdviceReplyViewCell.h
//  StandardShop
//
//  Created by Hank on 16/9/27.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XTableCellConfigExDelegate.h"

#define WMAdviceReplyViewCellIden @"WMAdviceReplyViewCellIden"

@interface WMAdviceReplyViewCell : UITableViewCell<XTableCellConfigExDelegate>
/**回复内容
 */
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
/**用户名
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/**类型
 */
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

- (void)configureCellWithModel:(id)model;
@end

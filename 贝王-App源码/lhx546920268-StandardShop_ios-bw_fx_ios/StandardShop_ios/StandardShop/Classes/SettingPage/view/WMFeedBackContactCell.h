//
//  FeedBackContactViewCell.h
//  WuMei
//
//  Created by qsit on 15/7/30.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#define kFeedBackContactViewHeight 80
#import <UIKit/UIKit.h>
#import "XTableCellConfigExDelegate.h"

///意见反馈联系方式
@interface WMFeedBackContactCell : UITableViewCell<XTableCellConfigExDelegate>
/**标题文本
 */
@property (weak, nonatomic) IBOutlet UILabel *feedContactLabel;
/**联系方式输入
 */
@property (weak, nonatomic) IBOutlet UITextField *contactField;
/**信息显示
 */
@property (weak, nonatomic) IBOutlet UILabel *contentLbelOne;
/**信息显示
 */
@property (weak, nonatomic) IBOutlet UILabel *contentLabelTwo;

@end

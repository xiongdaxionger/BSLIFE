//
//  WMAdviceHeaderViewCell.h
//  StandardShop
//
//  Created by mac on 16/6/2.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTableCellConfigExDelegate.h"

//单元格高度
#define WMAdviceHeaderViewCellHeight 35.0
//单元格标识ID
#define WMAdviceHeaderViewCellIdentifer @"WMAdviceHeaderViewCellIdentifer"

@class WMAdviceQuestionInfo;
/**咨询列表内容头部--显示时间及用户名
 */
@interface WMAdviceHeaderViewCell : UITableViewCell<XTableCellConfigExDelegate>
/**发表咨询的用户名
 */
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
/**发表咨询的时间
 */
@property (weak, nonatomic) IBOutlet UILabel *adviceTimeLabel;
/**配置数据模型
 */
- (void)configureCellWithModel:(WMAdviceQuestionInfo *)model;
@end

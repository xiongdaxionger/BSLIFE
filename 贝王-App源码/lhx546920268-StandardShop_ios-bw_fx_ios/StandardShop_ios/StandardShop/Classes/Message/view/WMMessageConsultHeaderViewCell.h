//
//  WMMessageConsultHeaderViewCell.h
//  StandardShop
//
//  Created by mac on 16/8/1.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WMMessageConsultHeaderViewCellHeight 44.0
//消息--咨询回复头部
@interface WMMessageConsultHeaderViewCell : UITableViewCell
/**咨询类型
 */
@property (weak, nonatomic) IBOutlet UILabel *consultTypeLabel;
/**咨询回复状态
 */
@property (weak, nonatomic) IBOutlet UILabel *replyStatusLabel;
/**配置数据
 */
- (void)configureWithTypeString:(NSString *)type timeString:(NSString *)time;
@end

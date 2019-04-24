//
//  WMMessageConsultQuestionViewCell.h
//  StandardShop
//
//  Created by mac on 16/8/1.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

/**消息--咨询提问
 */
@interface WMMessageConsultQuestionViewCell : UITableViewCell
/**咨询问题
 */
@property (weak, nonatomic) IBOutlet UILabel *qusetionContentLabel;
/**文本
 */
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

/**配置数据
 */
- (void)configureWithContentString:(NSString *)content;
@end

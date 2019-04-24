//
//  WMMessageCodeViewCell.h
//  StandardShop
//
//  Created by mac on 16/7/1.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WMMessageCodeViewCellIden @"WMMessageCodeViewCellIden"
#define WMMessageCodeViewCellHeight 44.0

@protocol WMMessageCodeViewCellDelegate <NSObject>

- (void)messageCodeContentChange:(NSString *)code;

@end
/**短信验证码
 */
@interface WMMessageCodeViewCell : UITableViewCell
/**输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *textField;
/**倒计时
 */
@property (weak, nonatomic) IBOutlet SeaCountDownButton *countDownButton;
/**代理
 */
@property (weak,nonatomic) id<WMMessageCodeViewCellDelegate>delegate;
/**按钮回调
 */
@property (copy,nonatomic) void(^getMessageCode)(void);
@end

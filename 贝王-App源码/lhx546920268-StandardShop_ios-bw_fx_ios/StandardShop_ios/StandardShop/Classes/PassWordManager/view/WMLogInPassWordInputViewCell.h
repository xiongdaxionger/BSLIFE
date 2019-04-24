//
//  WMLogInPassWordInputViewCell.h
//  StandardShop
//
//  Created by mac on 16/7/1.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#define WMLogInPassWordInputViewCellHeight 44.0
#define WMLogInPassWordInputViewCellIden @"WMLogInPassWordInputViewCellIden"

//输入类型
typedef NS_ENUM(NSInteger, InputType){

    //手机号码输入
    InputTypePhone = 0,
    
    //登陆密码输入
    InputTypeLogInPassWord = 1,
    
    //第一次的支付密码
    InputTypeFirstPayPass = 2,
    
    //第二次的支付密码
    InputTypeSecondPayPass = 3,
    
};
#import <UIKit/UIKit.h>

@protocol WMLogInPassWordInputViewCellDelegate <NSObject>

/**输入结束回调
 */
- (void)inputPassWordFinishWithPassWord:(NSString *)passWord type:(InputType)type;

@end

/**输入框单元格
 */
@interface WMLogInPassWordInputViewCell : UITableViewCell
/**输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
/**协议
 */
@property (weak,nonatomic) id<WMLogInPassWordInputViewCellDelegate>delegate;
/**配置数据
 */
- (void)configureWithContent:(NSString *)content type:(InputType)type;
@end

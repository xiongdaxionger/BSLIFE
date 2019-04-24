//
//  WMImageCodeViewCell.h
//  StandardShop
//
//  Created by mac on 16/7/1.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMImageVerificationCodeView;

#define WMImageCodeViewCellHeight 44.0
#define WMImageCodeViewCellIden @"WMImageCodeViewCellIden"
/**图形验证码输入
 */
@interface WMImageCodeViewCell : UITableViewCell
/**图形验证码输入视图
 */
@property (weak, nonatomic) IBOutlet WMImageVerificationCodeView *imageCodeView;

@end

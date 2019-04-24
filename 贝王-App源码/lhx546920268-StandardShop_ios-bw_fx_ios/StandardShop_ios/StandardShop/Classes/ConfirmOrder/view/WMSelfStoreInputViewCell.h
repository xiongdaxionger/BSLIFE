//
//  WMSelfStoreInputViewCell.h
//  StandardShop
//
//  Created by Hank on 2018/1/11.
//  Copyright © 2018年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTableCellConfigExDelegate.h"
#define WMSelfStoreInputViewCellHeight 76.0
#define WMSelfStoreInputViewCellIden @"WMSelfStoreInputViewCellIden"
@class WMConfirmOrderInfo;
//门店自提的联系方式输入
@interface WMSelfStoreInputViewCell : UITableViewCell<XTableCellConfigExDelegate,UITextFieldDelegate>
//姓名
@property (weak, nonatomic) IBOutlet UITextField *name_input_field;
//联系方式
@property (weak, nonatomic) IBOutlet UITextField *mobile_input_field;
/**订单数据
 */
@property (weak,nonatomic) WMConfirmOrderInfo *orderInfo;
@end

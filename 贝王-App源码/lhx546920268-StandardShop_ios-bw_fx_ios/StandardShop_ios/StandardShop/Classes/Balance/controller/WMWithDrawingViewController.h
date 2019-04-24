//
//  WMWithDrawingViewController.h
//  StandardFenXiao
//
//  Created by mac on 15/12/3.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import "SeaViewController.h"

/**提现
 */
@interface WMWithDrawingViewController : SeaViewController


/**可提现的输入框
 */
@property (weak, nonatomic) IBOutlet UILabel *withDrawnField;
/**提现金额的输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *inWithDrawField;
/**添加账户按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *addAccountButton;
/**确定提现按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *withDrawButton;
/**账户信息文本
 */
@property (weak, nonatomic) IBOutlet UILabel *accountInfoLabel;
/**提现税金输入框
 */
@property (weak, nonatomic) IBOutlet UILabel *inWithDrawTaxField;
/**税金视图高度
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *taxViewHeight;
/**平台手续费
 */
@property (weak, nonatomic) IBOutlet UILabel *platformLabel;
/**提现费视图高度
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *platformViewHeight;
/**说明文本
 */
@property (weak, nonatomic) IBOutlet UILabel *statusInfoLabel;


/**标题本文集合
 */
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *tittleLabel;
/**点击确定提现按钮
 */
- (IBAction)withDrawButtonClick:(UIButton *)sender;

/**点击添加账户按钮
 */
- (IBAction)addAccountButtonTap:(UIButton *)sender;

@end

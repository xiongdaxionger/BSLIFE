//
//  WMBalanceOperation.h
//  StandardShop
//
//  Created by 罗海雄 on 16/7/6.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

///获取充值信息网络标识符
#define WMTopupInfoIdentifier @"WMTopupInfoIdentifier"

///余额信息
#define WMBalanceInfoIdentifier @"WMBalanceInfoIdentifier"

///充值网络标识符
#define WMTopupIdentifier @"WMTopupIdentifier"

///获取验证码的网络标识符
#define WMGetPhoneCodeIdentifier @"WMGetPhoneCodeIdentifier"

///添加账号的网络标识符
#define WMAddAccountInfoIdentifier @"WMAddAccountInfoIdentifier"

///获取账户的网络标识符
#define WMGetDrawAccountInfoIden @"WMGetDrawAccountInfoIden"

///删除账户的网络标识符
#define WMDeleteAccountInfoIden @"WMDeleteAccountInfoIden"

///提现的网络标识符
#define WithDrawMoneyIndetifier @"WithDrawMoneyIndetifier"

///获取提现信息的网络标识符
#define WMGetWithDrawInfoIden @"WMGetWithDrawInfoIden"

///检测支付密码
#define WMCheckPayPassWordIden @"WMCheckPayPassWordIden"

///获取银行信息
#define WMGetBankInfoIden @"WMGetBankInfoIden"

@class WMTopupInfo,WMWithDrawInfo,WMBalanceInfo;

///余额网络操作
@interface WMBalanceOperation : NSObject

/**余额信息 参数
 */
+ (NSDictionary*)balanceInfoParams;

/**余额信息 结果
 *@return 余额信息
 */
+ (WMBalanceInfo*)balanceInfoFromData:(NSData*) data;

/**获取充值信息 参数
 */
+ (NSDictionary*)topupInfoParams;

/**获取充值信息 结果
 *@return WMTopupInfo 充值信息
 */
+ (WMTopupInfo*)topupInfoFromData:(NSData*) data;

/**充值 参数
 *@param amount 充值金额
 *@param paymentId 支付方式id
 */
+ (NSDictionary*)topupParamsWithAmount:(NSString*) amount paymentId:(NSString*) paymentId;

/**获取充值支付结果
 *@return 支付参数字典
 */
+ (NSDictionary*)topupResultFromData:(NSData*) data;


/**按钮回调
 */
@property(nonatomic,copy) void(^commitButtonAction)(void);
/**底部提现视图
 */
- (UIView *)returnFooterView;


/**顶部视图
 */
- (UIView *)returnSegementControlView;
/**分段控件的点击事件
 */
@property (nonatomic,copy) void(^segementAction)(UISegmentedControl *segement);


/**提现的说明数据 参数
 */
+ (NSDictionary *)returnWithDrawInfoParam;
/**提现的说明数据 结果
 */
+ (WMWithDrawInfo *)returnWithDrawInfoWithData:(NSData *)data;

/**提交提现 参数
 */
+ (NSDictionary *)returnCommitWithDrawParamWithMoney:(NSString *)moneyStr accountNumber:(NSString *)account payPassWord:(NSString *)payPassWord;
/**提交提现 结果
 */
+ (BOOL)returnCommitWithDrawResultWithData:(NSData *)data;

/**获取提现账户列表 参数
 */
+ (NSDictionary *)returnAccountInfosListParam;
/**获取提现账户列表 结果
 @return 字典 key为info--数组 元素是WMWithDrawAccountInfo key为code--图形验证码
 */
+ (NSDictionary *)returnAccountInfosListResultWithData:(NSData *)data;

/**删除提现账号 参数
 *@param 账号ID member_bank_id
 */
+ (NSDictionary *)returnDeleteAccountParamWithAccountID:(NSString *)accountID;
/**删除提现账号 结果
 */
+ (BOOL)returnDeleteAccountResultWithData:(NSData *)data;

/**银行卡列表 参数
 */
+ (NSDictionary *)blankListParams;
/**银行卡列表 结果
 */
+ (NSArray*)blankListFromData:(NSData*) data;

/**添加提现账号 参数
 *@param 账号类型 NSInteger
 *@param 单元配置数组
 */
+ (NSDictionary *)returnAddAccountParamWith:(NSMutableArray *)infoCellsArr accountType:(NSInteger)type phoneCode:(NSString *)phoneCode;
/**添加提现账号 结果
 */
+ (BOOL)returnAddAccountResultWithData:(NSData *)data;


@end

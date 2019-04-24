//
//  WMPayInterface.h
//  WestMailDutyFee
//
//  Created by 罗海雄 on 15/8/31.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

/**有关支付的宏定义
 */

#ifndef WestMailDutyFee_WMPayInterface_h
#define WestMailDutyFee_WMPayInterface_h

/**支付方式id
 */
#define WMPaymentId @"app_id"

/**支付方式id值
 */
#define WMPaymentIdDeposit @"deposit" ///预存款
#define WMPaymentIdMalipay @"malipay" ///支付宝
#define WMPaymentIdWinxin @"wxpayjsapi" ///微信支付
#define WMPaymentIdUnionPay @"unionpay" ///银联支付

/**银行卡类型
 */
#define WMBlankTypeUnion 1 ///银联
#define WMBlankTypeAlipay 2 ///支付宝

//预存款的支付ID
#define WMDepositID @"deposit"
//支付宝的支付ID
#define WMMAlipayID @"malipay"
//微信支付的支付ID
#define WMWxPayID @"wxpayjsapi"


//change price
#define kPriceChange @"PriceChange"
#define kPriceChangeNumber @"PriceChangeNumber"
#define kSelecteAllButton @"selectedAllButton"
#define kUnSelecteAllButton @"unselecteAllButton"
#define kSelecteTipID @"SelecteTipID"

//手动回调微信支付，存储本地的key
#define OrderID @"orderID"
#define OrderPayCallBackURL @"OrderPayCallBackURL"
#define OrderPaySign @"OrderPaySign"

//设置支付密码
#define WMSetPayPassWord @"setpaypassword"
//修改支付密码
#define WMChangePayPassWord @"verifypaypassword"

/**支付的结果通知
 */
static NSString* const OrderDoPayCallBackResultNotification = @"OrderDoPayCallBackResultNotification";

/**成功加入购物车
 */
static NSString* const AddGoodToShopCarSuccessNotification = @"AddGoodToShopCarSuccessNotification";

/**商品评论成功
 */
static NSString* const CommentGoodSuccessNotification = @"CommentGoodSuccessNotification";

/**支付状态的key
 */
static NSString* const OrderDoPayStatusKey = @"OrderDoPayStatusKey";

///退款动作
typedef NS_ENUM(NSInteger, RejectAction){
    
    ///同意退款
    RejectActionAgree = 4,
    
    ///拒绝退款
    RejectActionReject = 5,
};

///提现账号的类型
typedef NS_ENUM(NSInteger, WithDrawAccountType){
    
    ///银行
    WithDrawAccountTypeBlank = 1,
    
    //支付宝账号
    WithDrawAccountTypeALiPay = 2,
    
    ///信用卡
    WithDrawAccountTypeCreditCard = 3,
};

///支付的回调的类型
typedef NS_ENUM(NSInteger, DoPayCallBackType){
    
    //未知
    DoPayCallBackTypeUnkonw = -1,
    
    ///支付成功
    DoPayCallBackTypeSuccess = 0,
    
    ///支付失败
    DoPayCallBackTypeFail = 1,
    
    ///支付取消
    DoPayCallBackTypeCancel = 2,
};

///验证支付密码的回调结果
typedef NS_ENUM(NSInteger, PayPassWordCheckResultType){
    
    ///验证成功
    PayPassWordCheckResultTypeSuccess = 1,
    
    //验证失败
    PayPassWordCheckResultTypeFail = -1,
    
    //失败次数超过3次
    PayPassWordCheckResultTypeMoreThree = -2,
};

#endif

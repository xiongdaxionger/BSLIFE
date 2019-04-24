//
//  WMInputLimitInterface.h
//  WestMailDutyFee
//
//  Created by 罗海雄 on 15/8/27.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

/**输入限制宏定义
 */

#ifndef WestMailDutyFee_WMInputLimitInterface_h
#define WestMailDutyFee_WMInputLimitInterface_h

/**昵称输入限制
 */
#define WMUserNameInputLimitMax 20

/**个人介绍输入限制
 */
#define WMPersonIntroInputLimitMax 140

/**密码限制
 */
#define WMPasswordInputLimitMin 6
#define WMPasswordInputLimitMax 20

/**充值金额
 */
#define WMTopupInputLimitMin 0.0
#define WMTopupInputLimitMax 9999999999

/**提现最小金额
 */
#define WMWithdrawInputLimitMin 100

/**支付密码
 */
#define WMTradePasswdCount 6

/**手机号输入限制
 */
#define WMPhoneNumberInputLimitMax 11

/**固定电话输入限制
 */
#define WMTelPhoneNumberInputLimitMax 12

/**邮政编码输入限制
 */
#define WMPostcodeInputLimitMax 6

/**地址输入限制
 */
#define WMAddressInputLimitMax 80

///收货人输入限制
#define WMConsigneeInputLimitMax 30

/**QQ输入限制
 */
#define WMQQInputLimitMax 20

/**验证码
 */
#define WMPhoneNumberCodeInputLimitMax 6

/**图形验证码
 */
#define WMImageCodeInputLimitMax 10

/**开户行名称输入限制
 */
#define WMBlankNameInputLimitMax 30

/**支付宝账号限制
 */
#define WMALiPayAccountInputLimitMax 30

/**提现账户持卡人限制
 */
#define WMWithdrawAccountHolderInputLimitMax 30

/**邮箱输入限制
 */
#define WMEmailInputLimitMax 30

///银行卡号输入限制
#define WMBlankCardNumInputLimitMax 20
#define WMBlankCardNumInputLimitMin 9

///银行卡号格式化间隔
#define WMBlankCardNumFormatInterval 4

/**收款金额
 */
#define WMCollectMoneyInputLimitMin 1
#define WMCollectMoneyInputLimitMax 100000000000

/**收款名称
 */
#define WMCollectMoneyNameInputLimitMax 30

//身份证号码的最大长度
#define WMIdentityCardIDMaxLength 18

//身份证姓名的最大长度
#define WMIdentityCardNameMaxLength 15

///微信号输入限制
#define WMWeixinInputLimitMax 50

#pragma mark- 订单

///拒绝退款理由
#define WMOrderRefuseRefundReasonInputLimitMax 300

#pragma mark- 申请入驻

///公司名称
#define WMApplyInviteCompanyNameInputLimitMax 30

///联系人
#define WMApplyInviteContactInputLimitMax 30

#pragma mark- 推荐

///推荐评论
#define WMRecommendCommentInputLimitMax 140

#pragma mark- 发现

///发现评论
#define WMFoundCommentInputLimitMax 140

#pragma mark- 合作加盟

///城市输入限制
#define WMCityInputLimitMax 30

#pragma mark- 商品评价

#define WMGoodCommentContentInputLimitMax 1000 ///商品评价
#define WMGoodCommentReplyInputLimitMax 140 ///商品评价回复


#endif

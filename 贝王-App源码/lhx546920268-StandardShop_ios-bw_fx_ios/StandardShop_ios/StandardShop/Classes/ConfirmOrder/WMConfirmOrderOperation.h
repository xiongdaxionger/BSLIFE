//
//  WMConfirmOrderOperation.h
//  WanShoes
//
//  Created by mac on 16/3/14.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XTableCellConfigEx;
@class ConfirmOrderPageController;
#import "ConfirmOrderMinusMoneyViewCell.h"
#import "ConfirmOrderPayInfoViewCell.h"
@class WMConfirmOrderViewModel;

//提交购物车确认订单的网络请求
#define WMCheckOutConfirmOrderIdentifier @"WMCheckOutConfirmOrderIdentifier"
//更新总价格的网络请求
#define WMUpdateTotalMoenyIden @"WMUpdateTotalMoenyIden"
//获取配送方式网络请求
#define WMGetShippingMethodIdentifier @"WMGetShippingMethodIdentifier"
//选择配送方式
#define WMSelectShippingMethodIdentifier @"WMSelectShippingMethodIdentifier"
//使用积分的网络请求
#define WMUsePointIdentifier @"WMUsePointIdentifier"
//订单创建的网络标识符
#define WMOrderCreateIdentifier @"WMOrderCreateIdentifier"
//请求支付方式的网络标识符
#define WMGetPayInfoMethodIdentifier @"WMGetPayInfoMethodIdentifier"
//检测支付密码的网络标识符
#define WMCheckPayPassIdentifier @"WMCheckPayPassIdentifier"
//调用支付的网络标识符
#define WMCallDoPayMentIdentifier @"WMCallDoPayMentIdentifier"
//选择支付方式的网络标识符
#define WMSelectPayMethodIdentifier @"WMSelectPayMethodIdentifier"
//检测订单的支付状态请求
#define WMCheckOrderPayStatusIdentifier @"WMCheckOrderPayStatusIdentifier"
//计算组合支付更换支付方式变化金额的请求
#define WMCombinationPayChangePayMethodIdentifer @"WMCombinationPayChangePayMethodIdentifer"

@class WMConfirmOrderInfo;
@class WMPayMessageInfo;

@interface WMConfirmOrderOperation : NSObject

#pragma mark - new
/**订单确认 参数
 *@param 是否立即购买-isFastBuy NSString/(true立即购买、false普通结算)
 *@param 选中的商品数组 NSArray，元素是商品的表示ID(goods_1216_3806)
 */
+ (NSDictionary *)returnConfirmOrderParamWithIsFastBuy:(NSString *)isFastBuy selectGoodsArr:(NSArray *)goodIdentsArr;
/**订单确认 结果
 */
+ (WMConfirmOrderInfo *)returnConfirmOrderResultWithData:(NSData *)data;

/**返回确认订单的配置数组
 */
+ (NSArray *)returnConfigureArrForOrderDetailWithTable:(UITableView *)tableView;

/**返回确认订单各组数目
 */
+ (NSInteger)returnConfirmOrderRowsOfSection:(NSInteger)section confirmOrderInfo:(WMConfirmOrderInfo *)orderInfo;
/**返回配置类
 */
+ (XTableCellConfigEx *)returnCellConfigWithIndexPath:(NSIndexPath*)indexPath confirmOrderInfo:(WMConfirmOrderInfo *)info cellConfigArr:(NSArray *)cellArr;
/**返回订单的模型
 */
+ (id)returnOrderModelWith:(NSIndexPath *)indexPath confirmOrderInfo:(WMConfirmOrderInfo *)info controller:(ConfirmOrderPageController *)controller;

/**更新订单总价 参数
 @param viewModel 订单模型
 @param isFastBuy 是否快速购买
 */
+ (NSDictionary*)orderUpdateTotalMoneyParamWithModel:(WMConfirmOrderInfo *)viewModel isFastBuy:(NSString *)isFastBuy;
/**获取订单价格 结果
 */
+ (NSDictionary *)returnOrderTotalMoneyWithData:(NSData *)data;

/**选择配送方式 参数
 *@param shipping 配送方式的JSON值
 */
+ (NSDictionary *)returnSelectShippingMethodWithShippingJsonValue:(NSString *)shippingJson;
/**选择配送方式 结果
 *@return 字典 key为currency是是货币单位,key为pay时是默认的支付方式
 */
+ (NSDictionary *)returnSelectShippingMethodResultWithData:(NSData *)data;

/**使用积分抵扣 参数
 *@param 订单的积分配置(可用的最大积分数量/积分的比例) pointSettingDict
 */
+ (NSDictionary *)returnUsePointParamWithPointSettingDict:(NSDictionary *)pointSettingDict;
/**积分使用的结果
 */
+ (BOOL)returnUsePointResultWithData:(NSData *)data;

/**获取支付方式 参数
 *@param 订单ID orderID
 */
+ (NSDictionary *)getOrderPayInfoWithOrderID:(NSString *)orderID;
/**选择支付方式 参数
 *@param 货币类型 currency
 *@param 订单ID orderID
 *@param 支付方式 appID
 */
+ (NSDictionary *)returnSelectPayMethodWithCurrency:(NSString *)currency orderID:(NSString *)orderID payAppID:(NSString *)appID;
/**获取支付方式 结果
 *积分兑换的商品在不需要支付任何费用情况下为已支付,返回YES
 */
+ (id)returnPayMessageInfoWithData:(NSData *)data;

/**创建订单 参数
 *@param 创建订单的模型 WMConfirmOrderModel
 */
+ (NSDictionary *)orderCreateParamWithModel:(WMConfirmOrderInfo *)info fastBuyType:(NSString *)type;
/**创建订单 结果
 */
+ (NSDictionary *)returnOrderCreateResultWithData:(NSData *)data;

/**检测支付密码 参数
 *@param passwd 需要验证的支付密码
 */
+ (NSDictionary*)verifyTardePasswdParamWithPasswd:(NSString*) passwd;

/**检测支付密码 结果
 *@param errMsg 错误信息
 @return 是否验证成功
 */
+ (BOOL)verifyTardePasswdResultFromData:(NSData*)data;

/**调用支付 参数
 *@param 订单号 orderID
 *@param 订单金额 totalMoney
 *@param 支付方式 payAppID
 *@param 是否开启组合支付 isCombinationPay
 *@param 组合支付的剩余金额 combinationPayMoeny
 *@param 组合支付的支付方式 combinationPayMethod
 *@param 支付密码 payPassWord--预存款需要
 */
+ (NSDictionary *)returnCallDoPaymentParamOrderID:(NSString *)orderID totalMoney:(NSString *)totalMoney payAppID:(NSString *)payAppID isCombinationPay:(BOOL)isCombinationPay combinationPayMoney:(NSString *)combinationPayMoney combinationPayMethod:(NSString *)combinationPayMethod payPassWord:(NSString *)payPassWord;
/**调用支付 结果
 */
+ (NSDictionary *)returnCallDoPaymentResultWithData:(NSData *)data;

/**检测订单的支付状态 参数
 *@param 订单号 orderID
 */
+ (NSDictionary *)returnCheckOrderPayStatusWithOrderID:(NSString *)orderID;
/**检测订单的支付状态 结果
 */
+ (BOOL)returnCheckOrderPayStatusWithData:(NSData *)data;

/**组合支付更改支付方式 参数
 *@param 更改的支付方式ID payAppID
 *@param 组合支付的剩余金额 currencyMoney
 *@param 组合支付的已支付金额 depositMoeny
 */
+ (NSDictionary *)returnCombinationPayChangePayMethodParamWithPayAppID:(NSString *)payAppID currencyMoney:(NSString *)currencyMoney depositMoney:(NSString *)depositMoney;
/**组合支付更改支付 结果
 */
+ (NSDictionary *)returnCombinationPayResultWithData:(NSData *)data;

/**价格富文本
 */
+ (NSAttributedString *)returnPriceAttributedStringIsTitle:(BOOL)isTitle priceDictsArr:(NSArray *)priceDictsArr;




@end

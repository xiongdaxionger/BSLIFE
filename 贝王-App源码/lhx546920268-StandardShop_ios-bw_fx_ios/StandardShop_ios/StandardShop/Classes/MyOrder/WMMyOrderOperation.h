//
//  WMOrderOperation.h
//  AKYP
//
//  Created by mac on 15/11/28.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

//删除订单
#define WMDeleteOrderIdentifier @"WMDeleteOrderIdentifier"
//再次购买商品
#define WMGoodBuyAgainIdentifier @"WMGoodBuyAgainIdentifier"
///取消订单的网络标识符
#define WMCancelOrderIdentifier @"WMCancelOrderIdentifier"
//确认订单的网络请求标识符
#define WMConfirmGetGoodIdentifier @"WMConfirmGetGoodIdentifier"
//获取取消订单的原因请求
#define WMGetOrderCancelReasonIdentifier @"WMGetOrderCancelReasonIdentifier"
///获取我的订单网络标识符
#define WMGetOrderListIdentifier @"WMGetOrderListIdentifier"

@class WMOrderInfo;
@class XTableCellConfigEx;
@interface WMMyOrderOperation : NSObject


#pragma mark - new
/**获取我的订单信息 参数
 *@param 订单类型 orderType
 *@param 页码 pageIndex
 *@param 会员ID memberID
 *@param 是否为分销订单 isCommision
 */
+ (NSDictionary *)returnMyOrderParamWithOrderType:(OrderType)type pageIndex:(NSInteger)pageIndex memberID:(NSString *)memberID isCommision:(BOOL)isCommision;
/**获取我的订单信息 结果
 *@param 订单数组--元素是WMOrderInfo
 *@param 订单总数
 */
+ (NSDictionary *)returnMyOrderInfoResultWithData:(NSData *)data canComment:(BOOL)canComment;

/**返回订单类型
 *@param 下标 NSInteger
 *return 订单类型 NSString
 */
+ (NSString *)returnOrderTypeWithIndex:(NSInteger)index;

/**返回表格视图的配置类
 *@param 订单模型 WMOrderInfo
 *@param 配置数组 元素XTableCellConfigEx
 *return 配置类 XTableCellConfigEx
 */
+ (XTableCellConfigEx *)returnConfigureWithModel:(WMOrderInfo *)model configArr:(NSArray *)configArr indexPath:(NSIndexPath *)indexPath;

/**返回订单的每组的数目
 */
+ (NSInteger)returnOrderSectionRowNumberWith:(WMOrderInfo *)model;

/**确认订单 参数
 *@param 订单ID NSString
 */
+ (NSDictionary *)returnConfirmOrderParamWithOrderID:(NSString *)orderID;
/**取消订单 参数
 *@param 订单ID NSString
 *@param 取消原因 NSInteger
 */
+ (NSDictionary *)returnCancelOrderParamWithOrderID:(NSString *)orderID reasonType:(NSDictionary *)type;
/**删除订单 参数
 *@param 订单ID NSString
 */
+ (NSDictionary *)returnDeleteOrderParamWithOrderID:(NSString *)orderID;
/**再次购买 参数
 *@param 订单ID NSString
 */
+ (NSDictionary *)returnBuyAgainParamWithOrderID:(NSString *)orderID;
/**确认订单和取消订单、删除订单等订单操作 结果
 *@retrun Bool
 */
+ (BOOL)orderActionWithData:(NSData *)data;

/**获取取消订单的原因 参数
 */
+ (NSDictionary *)returnCancelOrderReasonParam;
/**获取取消订单的原因 结果
 *@return 原因数组--元素NSDictionary
 */
+ (NSArray *)returnCancelOrderReasonArrsWithData:(NSData *)data;

/**返回商品名称属性字符串
 */
+ (NSAttributedString *)returnGoodAttrNameWithType:(OrderGoodType)type goodName:(NSString *)goodName;

@end

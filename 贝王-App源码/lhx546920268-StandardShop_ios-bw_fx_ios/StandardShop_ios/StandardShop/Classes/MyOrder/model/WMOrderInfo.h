//
//  WMOrderInfo.h
//  StandardShop
//
//  Created by mac on 16/7/2.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

/**订单的商品模型
 */
@interface WMOrderGoodInfo : NSObject
/**商品名称
 */
@property (copy,nonatomic) NSString *goodName;
/**格式化的商品名称
 */
@property (copy,nonatomic) NSAttributedString *formatGoodName;
/**商品数量
 */
@property (copy,nonatomic) NSString *quantity;
/**商品图片
 */
@property (copy,nonatomic) NSString *image;
/**商品ID
 */
@property (copy,nonatomic) NSString *goodID;
/**货品ID
 */
@property (copy,nonatomic) NSString *productID;
/**商品价格
 */
@property (copy,nonatomic) NSAttributedString *price;
/**商品市场价
 */
@property (copy,nonatomic) NSString *marketPrice;
/**商品规格
 */
@property (copy,nonatomic) NSString *specInfo;
/**商品能否评论
 */
@property (assign,nonatomic) BOOL canGoodComment;
/**商品类型
 */
@property (assign,nonatomic) OrderGoodType type;
/**批量初始化--退款订单不能显示评价
 */
+ (NSArray *)returnOrderGoodInfosArrWithDictsArr:(NSArray *)dictsArr type:(OrderGoodType)type canComment:(BOOL)canComment;
/**初始化
 */
+ (instancetype)returnOrderGoodInfoWithDict:(NSDictionary *)dict type:(OrderGoodType)type canComment:(BOOL)canComment;
@end

/**我的订单的数据模型
 */
@interface WMOrderInfo : NSObject
/**订单号
 */
@property (copy,nonatomic) NSString *orderID;
/**是否为预售订单
 */
@property (assign,nonatomic) BOOL isPrepareOrder;
/**预售订单的尾款支付截止时间--当预售订单的定金设置为与销售价一致时，不需要支付尾款
 */
@property (copy,nonatomic) NSString *prepareFinalTime;
/**预售订单的尾款支付开始时间
 */
@property (copy,nonatomic) NSString *prepareBeginTime;
/**预售订单的已付定金
 */
@property (copy,nonatomic) NSString *prepareSellPrice;
/**预售订单的尾款
 */
@property (copy,nonatomic) NSString *prepareFinalPrice;
/**订单创建时间
 */
@property (copy,nonatomic) NSString *orderCreateTime;
/**订单支付方式ID
 */
@property (copy,nonatomic) NSString *payAppID;
/**订单支付方式名称
 */
@property (copy,nonatomic) NSString *payAppName;
/**订单激活状态--finish已完成/active活跃/dead作废
 */
@property (copy,nonatomic) NSString *orderStatus;
/**订单的状态文本--如等待付款/等待发货等
 */
@property (copy,nonatomic) NSString *orderStatusTitle;
/**订单总金额
 */
@property (copy,nonatomic) NSString *orderTotalMoney;
/**商品的数量
 */
@property (copy,nonatomic) NSString *orderQuantity;
/**订单的主操作按钮的提示文本--如确认收货/去付款等等
 */
@property (copy,nonatomic) NSString *mainButtonTitle;
/**订单的主操作按钮类型
 */
@property (assign,nonatomic) MainButtonActionType actionType;
/**订单能否取消，订单能取消时副操作按钮为取消订单，不能取消时副操作按钮为再次购买
 */
@property (assign,nonatomic) BOOL canCancelOrder;
/**订单能否删除--已作废订单才有删除动作
 */
@property (assign,nonatomic) BOOL canDeleteOrder;
/**订单能否申请退换货/退款
 */
@property (assign,nonatomic) BOOL canOrderAffter;
/**订单是否为纯粹的积分兑换商品订单
 */
@property (assign,nonatomic) BOOL isInitPointOrder;
/**订单消费积分--仅仅只兑换商品消费的积分
 */
@property (copy,nonatomic) NSString *orderScoreUse;
/**订单是否包含积分兑换赠品
 */
@property (assign,nonatomic) BOOL orderContainPointGood;
/**订单状态
 */
@property (assign,nonatomic) OrderStatus status;
/**订单的商品数组--元素是WMOrderGoodInfo
 */
@property (strong,nonatomic) NSMutableArray *orderGoodsArr;
/**价格属性字符串
 */
@property (copy,nonatomic) NSAttributedString *priceAttrString;
/**是否门店自提订单
 */
@property (assign,nonatomic) BOOL isStoreAutoOrder;
/**自提订单核销码
 */
@property (copy,nonatomic) NSString *sinceCode;
/**订单取货状态 门店备货stockup 待自提waiting 已自提already
 */
@property (copy,nonatomic) NSString *selfMentionStatus;
/**批量初始化
 */
+ (NSArray *)returnOrderInfosArrWithDictsArr:(NSArray *)dictsArr canComment:(BOOL)canComment;


@end

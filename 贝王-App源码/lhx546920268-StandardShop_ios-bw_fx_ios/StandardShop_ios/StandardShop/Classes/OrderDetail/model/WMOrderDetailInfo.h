//
//  WMOrdertailInfo.h
//  StandardShop
//
//  Created by mac on 16/7/5.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

/**订单详情的商品信息模型
 */
@interface WMOrderDetailGoodInfo : NSObject
/**商品名称
 */
@property (copy,nonatomic) NSString *name;
/**格式化商品名称
 */
@property (copy,nonatomic) NSAttributedString *formatGoodName;
/**商品图片
 */
@property (copy,nonatomic) NSString *image;
/**商品数量
 */
@property (copy,nonatomic) NSString *quantity;
/**商品ID
 */
@property (copy,nonatomic) NSString *goodID;
/**货品ID
 */
@property (copy,nonatomic) NSString *productID;
/**商品价格
 */
@property (copy,nonatomic) NSAttributedString *price;
/**市场价
 */
@property (copy,nonatomic) NSString *marketPrice;
/**商品能否评论
 */
@property (assign,nonatomic) BOOL canGoodComment;
/**类型
 */
@property (assign,nonatomic) OrderGoodType type;
/**商品规格
 */
@property (copy,nonatomic) NSString *specInfo;
/**商品优惠，元素是NSDictionary，只有商品类型是普通商品同时具备优惠时才不为空
 */
@property (strong,nonatomic) NSArray *goodPromotion;
/**商品优惠属性字符串，同上
 */
@property (strong,nonatomic) NSAttributedString *goodPromotionAttrString;
/**商品的配件数组，只有商品类型是普通商品同时具有配件时不为nil
 */
@property (strong,nonatomic) NSArray *adjunctGoodsArr;
/**商品的赠品数组，只有商品类型是普通商品同时具有赠品时不为nil
 */
@property (strong,nonatomic) NSArray *giftGoodsArr;
/**批量初始化
 */
+ (NSArray *)returnOrderDetailGoodInfosArrWithDictsArr:(NSArray *)dictsArr type:(OrderGoodType)type;
/**初始化
 */
+ (instancetype)returnOrderDetailGoodInfoWithDict:(NSDictionary *)dict type:(OrderGoodType)type;
@end

/**订单详情的商品组信息
 */
@interface WMOrderDetailGroupGoodInfo : NSObject
/**商品类型
 */
@property (assign,nonatomic) OrderGoodType type;
/**商品数组，元素是WMOrderDetailGoodInfo
 */
@property (strong,nonatomic) NSMutableArray *goodsArr;

@end

@class WMAddressInfo;
/**订单详情模型
 */
@interface WMOrderDetailInfo : NSObject
/**订单ID
 */
@property (copy,nonatomic) NSString *orderID;
/**订单状态说明
 */
@property (copy,nonatomic) NSString *orderStatusString;
/**订单的下单时间
 */
@property (copy,nonatomic) NSString *orderCreateTime;
/**订单的支付时间--已支付的订单才存在
 */
@property (copy,nonatomic) NSString *orderPayTime;
/**订单的实付款属性字符串
 */
@property (copy,nonatomic) NSAttributedString *priceAttrString;
/**订单总金额
 */
@property (copy,nonatomic) NSString *totalAmount;
/**支付方式ID
 */
@property (copy,nonatomic) NSString *payAppID;
/**支付方式名称
 */
@property (copy,nonatomic) NSString *payAppName;
/**配送方式名称
 */
@property (copy,nonatomic) NSString *shippingName;
/**配送时间
 */
@property (copy,nonatomic) NSString *shippingTime;
/**是否门店自提
 */
@property (assign,nonatomic) BOOL isBranch;
/**订单是否开发票
 */
@property (assign,nonatomic) BOOL isTax;
/**是否为预售订单
 */
@property (assign,nonatomic) BOOL isPrepare;
/**能付取消订单
 */
@property (assign,nonatomic) BOOL canCancelOrder;
/**能否删除订单
 */
@property (assign,nonatomic) BOOL canDeleteOrder;
/**预售订单尾款开始时间
 */
@property (copy,nonatomic) NSString *prepareBeginTime;
/**预售订单尾款结束时间
 */
@property (copy,nonatomic) NSString *prepareEndTime;
/**发票抬头--不开发票时内容都为空
 */
@property (copy,nonatomic) NSString *taxTitle;
/**发票类型
 */
@property (copy,nonatomic) NSString *taxType;
/**发票内容
 */
@property (copy,nonatomic) NSString *taxContent;
/**订单优惠，元素是NSDictionary，对应优惠标签和优惠内容
 */
@property (strong,nonatomic) NSArray *orderPromotion;
/**订单的备注
 */
@property (copy,nonatomic) NSString *orderMemo;
/**订单状态
 */
@property (assign,nonatomic) OrderStatus status;
/**订单的主操作按钮的提示文本--如确认收货/去付款等等
 */
@property (copy,nonatomic) NSString *mainButtonTitle;
/**订单的主操作按钮类型
 */
@property (assign,nonatomic) MainButtonActionType actionType;
/**订单的地址信息
 */
@property (strong,nonatomic) WMAddressInfo *addressInfo;
/**订单的状态文本
 */
@property (copy,nonatomic) NSString *orderStatusTitle;
/**订单的状态
 */
@property (copy,nonatomic) NSString *orderStatus;
/**订单的价格数组，元素是NSDictionary
 */
@property (strong,nonatomic) NSMutableArray *orderPriceDictsArr;
/**订单的价格标题信息
 */
@property (strong,nonatomic) NSAttributedString *orderTitleAttrString;
/**订单的价格信息
 */
@property (strong,nonatomic) NSAttributedString *orderPriceAttrString;
/**订单的商品数组--元素是WMOrdertailGroupGoodInfo
 */
@property (strong,nonatomic) NSMutableArray *orderGoodsArr;
/**订单优惠属性字符串
 */
@property (strong,nonatomic) NSAttributedString *orderPromotionAttrString;
/**订单的快递单号--当订单发货后该字段不为nil/订单申请退货时查看的是退货物流详情
 */
@property (copy,nonatomic) NSString *deliveryID;
/**订单的物流显示类型--发货物流/退货物流
 */
@property (copy,nonatomic) NSString *deliveryType;
/**是否为纯粹的积分兑换商品订单
 */
@property (assign,nonatomic) BOOL isInitPointOrder;
/**代客下单的名称--默认为nil
 */
@property (copy,nonatomic) NSString *memberName;
/**是否门店自提订单
 */
@property (assign,nonatomic) BOOL isStoreAutoOrder;
/**自提订单核销码
 */
@property (copy,nonatomic) NSString *sinceCode;
/**订单取货状态 门店备货stockup 待自提waiting 已自提already
 */
@property (copy,nonatomic) NSString *selfMentionStatus;
/**商品总数量
 */
@property (copy,nonatomic) NSString *quantity;
/**初始化
 */
+ (instancetype)returnOrderInfoWithDict:(NSDictionary *)dict;
/**计算显示价格的高度
 */
- (CGFloat)returnPriceInfoHeight;
/**地址文本高度
 */
- (CGFloat)returnAddrHeight;


@end

//
//  WMConfirmOrderInfo.h
//  StandardShop
//
//  Created by mac on 16/6/26.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

//价格信息类型
typedef NS_ENUM(NSInteger, OrderPriceType){
    
    //商品原总金额
    OrderPriceTypeInitTotal = 0,
    
    //商品实付总金额
    OrderPriceTypeGoodTotal = 1,
    
    //商品优惠金额
    OrderPriceTypeGoodPromotion = 2,
    
    //订单优惠金额
    OrderPriceTypePromotion = 3,
    
    //订单积分抵扣金额
    OrderPriceTypePointDiscount = 4,
    
    //运费
    OrderPriceTypeFreight = 5,
    
    //物流保价费
    OrderPriceTypeExpressProtect = 6,
    
    //客户承担手续费
    OrderPriceTypeCustomerPayment = 7,
    
    //税金
    OrderPriceTypeTax = 8,
    
    //订单实付金额
    OrderPriceTypeOrderTotal = 9,
    
    //消费积分
    OrderPriceTypeConsumeScore = 10,
    
    //获得积分
    OrderPriceTypeGainScore = 11,
    
    //预售订金
    OrderPriceTypePrepare = 12,
    
    //已支付金额
    OrderPriceTypePayed = 13,
    
    //货币汇率
    OrderPriceTypeRate = 14,
    
    //货币结算金额
    OrderPriceTypeCurAmount = 15,
};

//确认订单的组
typedef NS_ENUM(NSInteger, ConfirmOrderSection){
    
    //代客下单
    ConfirmOrderSectionCustomer = 0,
    
    //地址/会员
    ConfirmOrderSectionAddress = 1,
    
    //商品
    ConfirmOrderSectionGood = 2,
    
    //配送地址
    ConfirmOrderSectionShippingMethod = 3,
    
    //订单备注
    ConfirmOrderSectionRemark = 4,
    
    //发票信息
    ConfirmOrderSectionInvioce = 5,
    
    //优惠券
    ConfirmOrderSectionCoupon = 6,
    
    //积分抵扣
    ConfirmOrderSectionPoint = 7,
    
    //价格信息
    ConfirmOrderSectionPrice = 8,
};

@class WMShopCarInfo;
@class WMAddressInfo;
@class WMShippingMethodInfo;
@class WMTaxSettingInfo;
@class WMCouponsInfo;
@class WMPayMethodModel;
@class WMShippingTimeInfo;
@class WMStoreListInfo;
/**订单确认页面数据模型
 */
@interface WMConfirmOrderInfo : NSObject
/**商品信息
 */
@property (strong,nonatomic) WMShopCarInfo *orderGoodInfo;
/**订单的MD5标识码
 */
@property (copy,nonatomic) NSString *orderMD5Code;
/**订单的默认(选择)地址--可能为nil
 */
@property (strong,nonatomic) WMAddressInfo *orderDefaultAddr;
/**开启代客下单时使用的配送地址--默认为nil
 */
@property (strong,nonatomic) WMAddressInfo *customerAddrInfo;
/**普通下单时使用的配送地址--默认为nil
 */
@property (strong,nonatomic) WMAddressInfo *userAddrInfo;
/**订单的配送方式数组--元素是WMShippingMethodInfo，当用户没有地址时该字段为nil
 */
@property (strong,nonatomic) NSArray *orderShippingMethodsArr;
/**订单的默认(选择)配送方式--可能为nil
 */
@property (strong,nonatomic) WMShippingMethodInfo *orderDefaultShipping;
/**订单非自提的配送方式
 */
@property (strong,nonatomic) WMShippingMethodInfo *noneSelfStoreShipping;
/**订单自提的配送方式
 */
@property (strong,nonatomic) WMShippingMethodInfo *selfStoreShipping;
/**当前的货币类型--可能为nil，通过选择配送方式接口重新获取
 */
@property (copy,nonatomic) NSString *orderCurrentCurrency;
/**订单的发票配置信息，当后台关闭发票时字段为nil
 */
@property (strong,nonatomic) WMTaxSettingInfo *orderTaxSettingInfo;
/**是否开发票
 */
@property (assign,nonatomic) BOOL orderIsOpenInvioce;
/**发票的抬头
 */
@property (copy,nonatomic) NSString *orderInvioceHeader;
/**发票的内容
 */
@property (copy,nonatomic) NSString *orderInvioceContent;
/**选中的发票类型
 */
@property (strong,nonatomic) NSDictionary *orderInvioceTypeDict;
/**订单的选择优惠券
 */
@property (strong,nonatomic) WMCouponsInfo *orderSelectCouponInfo;
/**配送方式的时间--普通配送为配送时间(后台不开启时为nil)/门店自提为自提时间
 */
@property (copy,nonatomic) NSString *methodTime;
/**配送时间的内容
 */
@property (strong,nonatomic) NSDictionary *timeDict;
/**订单的积分配置，当后台开启积分只用于兑换时，字段为nil
 */
@property (strong,nonatomic) NSDictionary *orderPointSettingDict;
/**是否使用积分
 */
@property (assign,nonatomic) BOOL isUsePoint;
/**订单商品的总金额
 */
@property (copy,nonatomic) NSString *orderGoodTotal;
/**订单的总金额
 */
@property (copy,nonatomic) NSString *orderTotal;
/**订单的价格数组，元素是NSDictionary
 */
@property (strong,nonatomic) NSMutableArray *orderPriceDictsArr;
/**订单的价格标题信息
 */
@property (strong,nonatomic) NSAttributedString *orderTitleAttrString;
/**订单的价格信息
 */
@property (strong,nonatomic) NSAttributedString *orderPriceAttrString;
/**订单的备注信息
 */
@property (copy,nonatomic) NSString *orderRemarkInfo;
/**是否开启了配送时间
 */
@property (assign,nonatomic) BOOL canShippingTime;
/**配送时间数据,元素是WMShippingTimeInfo,后台关闭配送时间时为nil
 */
@property (strong,nonatomic) NSArray *shippingTimeInfosArr;
/**订单是否为预售订单
 */
@property (assign,nonatomic) BOOL isPrepareOrder;
/**订单是否为积分兑换赠品订单
 */
@property (assign,nonatomic) BOOL isPointOrder;
/**订单号--创建订单后才不为nil
 */
@property (copy,nonatomic) NSString *orderID;
/**订单的支付方式
 */
@property (strong,nonatomic) WMPayMethodModel *orderPayModel;
/**选中的商品字符串数组
 */
@property (strong,nonatomic) NSArray *orderGoodsIdentArr;
/**选中的会员名称--默认为nil
 */
@property (copy,nonatomic) NSString *selectMemberName;
/**选中的会员ID--默认为nil
 */
@property (copy,nonatomic) NSString *selectMemberID;
/**是否开启代客下单--默认是NO
 */
@property (assign,nonatomic) BOOL needSelectMember;
/**是否能门店自提
 */
@property (assign,nonatomic) BOOL isStoreAuto;
/**是否切换了门店自提
 */
@property (assign,nonatomic) BOOL needStoreAuto;
/**输入的自提联系人
 */
@property (copy,nonatomic) NSString *selfStoreContactName;
/**输入的自提联系方式
 */
@property (copy,nonatomic) NSString *selfStoreContactMobile;
/**选中的门店
 */
@property (strong,nonatomic) WMStoreListInfo *selectStoreInfo;
/**初始化
 */
+ (instancetype)returnConfirmInfoWithDict:(NSDictionary *)dict;
/**地址文本高度
 */
- (CGFloat)returnAddrHeight;
/**返回价格信息高度
 */
- (CGFloat)returnPriceInfoHeight;
/**更新价格
 */
- (void)changeOrderPriceWithDict:(NSDictionary *)priceDict;
/**更新单个价格
 */
- (void)changeSinglePriceWithIndex:(OrderPriceType)type newPrice:(NSString *)price;










@end

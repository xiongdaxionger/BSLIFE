//
//  WMOrderInterface.h
//  StandardShop
//
//  Created by 罗海雄 on 16/5/30.
//  Copyright © 2016年 qianseit. All rights reserved.
//

///订单相关的xxx

#ifndef WMOrderInterface_h
#define WMOrderInterface_h

//订单状态类型--new
typedef NS_ENUM(NSInteger, OrderType){
    
    //全部订单
    OrderTypeAll = 0,
    
    //待付款订单
    OrderTypeWaitPay = 1,
    
    //待发货订单
    OrderTypeWaitShip = 2,
    
    //待收货
    OrderTypeWaitReceive = 3,
    
    //待评价
    OrderTypeWaitComment = 4,
};

//订单状态
typedef NS_ENUM(NSInteger, OrderStatus){
    
    //待付款--支付状态-0
    OrderStatusWaitPay = 0,
    
    //已支付--支付状态-1
    OrderStatusPay = 1,
    
    //付款到担保方--支付状态-2
    OrderStatusPayThird = 2,
    
    //部分付款--支付状态-3
    OrderStatusPartPay = 3,
    
    //部分退款--支付状态-4
    OrderStatusPartMoneyRefund = 4,
    
    //全额退款--支付状态-5
    OrderStatusAllMoneyRefund = 5,
    
    //待发货--发货状态-0
    OrderStatusWaitSend = 6,
    
    //待收货--发货状态-1
    OrderStatusWaitReceive = 7,
    
    //部分发货--发货状态-2
    OrderStatusPartSend = 8,
    
    //部分退货--发货状态-3
    OrderStatusPartGoodRefund = 9,
    
    //全部退货--发货状态-4
    OrderStatusAllGoodRefund = 10,
    
    //已收货--发货状态-5--不能作为可评价订单的判断标准
    OrderStatusShipFinish = 11,
    
    //已完成--订单状态-finish
    OrderStatusFinish = 12,
    
    //已作废--订单状态-dead
    OrderStatusDead = 13,
    
    //订单可评价
    OrderStatusComment = 14,
};

//主操作按钮操作动作类型
typedef NS_ENUM(NSInteger, MainButtonActionType){
    
    //预售订单超过尾款支付时间等原因，不能再次支付
    MainButtonActionTypeOverTime = 0,
    
    //可支付--支付订单/支付定金/支付尾款等
    MainButtonActionTypePay = 1,
    
    //支付结果返回中，属于待付款订单，订单已在第三方平台支付，但尚未回调到后台服务器，不能操作点击
    MainButtonActionTypeWaitPayCallBack = 2,
    
    //已发货订单的确认收货，能进行操作
    MainButtonActionTypeConfirmReceive = 3,
    
    //部分发货订单，不能进行确认收货
    MainButtonActionTypePartShipOrder = 4,
    
    //订单能进行评价,订单能否评价的唯一判断标准
    MainButtonActionTypeComment = 5,
};

//订单的商品类型
typedef NS_ENUM(NSInteger, OrderGoodType){
    
    //普通商品
    OrderGoodTypeNormal = 1,
    
    //普通商品的赠品
    OrderGoodTypeNormalGift = 2,
    
    //普通商品的配件
    OrderGoodTypeNormalAdjunct = 3,
    
    //订单赠品
    OrderGoodTypeOrderGift = 4,
    
    //积分兑换赠品
    OrderGoodTypePoint = 5,
};

///退款/退换订单状态
typedef NS_ENUM(NSInteger, RefundOrderStatus){
    
    ///申请中
    RefundOrderStatusUndo = 1,
    
    ///审核中
    RefundOrderStatusInVerify = 2,
    
    ///接受申请
    RefundOrderStatusReceive = 3,
    
    ///完成
    RefundOrderStatusFinish = 4,
    
    ///拒绝
    RefundOrderStatusReject = 5,
    
    ///已收货
    RefundOrderStatusGetGood = 6,
    
    ///已质检
    RefundOrderStatusQuality = 7,
    
    ///补差价
    RefundOrderStatusPrice = 8,
    
    ///拒绝退款
    RefundOrderStatusRejectReturnMoney = 9
};



//订单状态文本
#define WMFinishTitle @"已完成" //订单状态-finish
#define WMWaitRecommendTitle @"待推荐" //订单状态-finish
#define WMWaitCommentTitle @"待评价" //订单状态-finish

#define WMCancelTitle @"已作废" //订单状态-dead

#define WMWaitPayTitle @"待付款" //订单状态-active 支付状态-0

#define WMWaitSendTitle @"待发货" //订单状态-active 发货状态-0

#define WMWaitReceiveTitle @"待收货" //订单状态-active 发货状态-1

#define WMReceiveFinishTitle @"已收货" //订单状态-active 状态未明


#define WMPayPartTitle @"部分付款" //订单状态-active 支付状态-3

#define WMRefundMoneyPartTitle @"部分退款" //订单状态-active 支付状态-4

#define WMRefundMoneyAllTitle @"全额退款" //订单状态-active 支付状态-5

#define WMSendGoodPartTitle @"部分发货" //订单状态-active 发货状态-2

#define WMRefundGoodPartTitle @"部分退货" //订单状态-active 发货状态-3

#define WMInRefundingMoneyTitle @"退款中" //订单状态-active 状态未明

#define WMInRefundingGoodTitle @"退货中" //订单状态-active 状态未明

#define WMRefundMoneyFinishTitle @"退款完成" //订单状态-active 状态未明

#define WMRefundGoodFinishTitle @"退货完成" //订单状态-active 状态未明

#endif /* WMOrderInterface_h */

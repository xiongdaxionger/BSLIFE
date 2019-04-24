//
//  WMPersonCenterInfo.h
//  StandardShop
//
//  Created by 罗海雄 on 16/6/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

///会员中心信息
@interface WMPersonCenterInfo : NSObject<NSCoding>

/**订单待付款数量
 */
@property(nonatomic,assign) int orderWaitePayCount;

/**订单待发货数量
 */
@property(nonatomic,assign) int orderWaiteDeliveryCount;

/**订单待收货数量
 */
@property(nonatomic,assign) int orderWaiteGoodsCount;

/**订单待评价数量
 */
@property(nonatomic,assign) int orderWaiteCommentCount;

/**订单退款售后数量
 */
@property(nonatomic,assign) int orderRefundCount;

/**商品收藏数量
 */
@property(nonatomic,assign) int goodCollectCount;

/**存取记录数量
 */
@property(nonatomic,assign) int goodAccessCount;


/**优惠券数量
 */
@property(nonatomic,assign) int couponCount;

/**未读消息数量
 */
@property(nonatomic,assign) int unreadMessageCount;

/**积分
 */
@property(copy,nonatomic) NSString *integral;

/**贝壳
 */
@property(copy,nonatomic) NSString *balance;

/**是否开启预售
 */
@property(nonatomic,assign) BOOL openPresell;

/**是否开启分销
 */
@property(nonatomic,assign) BOOL openFenxiao;

/**添加会员邀请链接
 */
@property(nonatomic,copy) NSString *addPartnerURL;

///从字典中创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic;

@end

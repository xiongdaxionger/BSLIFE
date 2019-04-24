//
//  WMGoodDetailGiftInfo.h
//  StandardShop
//
//  Created by Hank on 16/8/8.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

/**积分商品详情的积分数据
 */
@interface WMGoodDetailGiftInfo : NSObject
/**能否兑换商品
 */
@property (assign,nonatomic) BOOL canExchangeGift;
/**不能兑换商品的原因
 */
@property (copy,nonatomic) NSString *notExchangeReason;
/**消耗的积分值
 */
@property (copy,nonatomic) NSString *consumeScore;
/**单次最大兑换量
 */
@property (copy,nonatomic) NSString *exchangeMax;
/**兑换的开始时间,不能兑换是显示原因，能兑换时显示时间
 */
@property (copy,nonatomic) NSString *beginTime;
/**兑换的结束时间
 */
@property (copy,nonatomic) NSString *endTime;
/**需要的会员级别
 */
@property (copy,nonatomic) NSString *memberLevel;
/**初始化
 */
+ (instancetype)returnGoodDetailGiftInfoWithDict:(NSDictionary *)dict;

@end

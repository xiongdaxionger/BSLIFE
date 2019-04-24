//
//  WMGoodDetailPrepareInfo.h
//  StandardShop
//
//  Created by mac on 16/6/6.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

//预售状态
typedef NS_ENUM(NSInteger, PrepareSaleType){
    
    //预售开始，能支付订金
    PrepareSaleTypeBargainBegin = 1,
    
    //预售商品售罄
    PrepareSaleTypeSaleAll = 2,
    
    //预售订金时间结束，支付尾款没开始
    PrepareSaleTypeMiddle = 3,
    
    //预售尾款支付时间开始
    PrepareSaleTypeFinalBegin = 4,
    
    //预售活动结束
    PrepareSaleTypeEnd = 5,
    
    //预售还没开始
    PrepareSaleTypeNoBeign = 6
};

/**商品预售信息
 */
@interface WMGoodDetailPrepareInfo : NSObject
/**预售ID
 */
@property (copy,nonatomic) NSString *prepareID;
/**预售货品ID
 */
@property (copy,nonatomic) NSString *prepareProductID;
/**预售商品价格
 */
@property (copy,nonatomic) NSString *prepareGoodPrice;
/**预售商品订金
 */
@property (copy,nonatomic) NSString *prepareBargainMoney;
/**预售规则名称
 */
@property (copy,nonatomic) NSString *prepareRuleName;
/**预售规则描述
 */
@property (copy,nonatomic) NSString *prepareRuleDescription;
/**预售订金开始时间
 */
@property (copy,nonatomic) NSString *prepareBragainBeginTime;
/**预售订金结束时间
 */
@property (copy,nonatomic) NSString *prepareBragainEndTime;
/**预售尾款开始时间
 */
@property (copy,nonatomic) NSString *prepareFinalBeginTime;
/**预售尾款结束时间
 */
@property (copy,nonatomic) NSString *prepareFinalEndTime;
/**预售库存
 */
@property (copy,nonatomic) NSString *prepareStore;
/**预售状态描述--当状态为PrepareSaleTypeBargainBegin时为nil
 */
@property (copy,nonatomic) NSString *prepareStatusMessage;
/**预售状态
 */
@property (assign,nonatomic) PrepareSaleType type;
/**初始化
 */
+ (instancetype)returnGoodDetailPrepareInfoWithDict:(NSDictionary *)dict;

@end

/**商品秒杀信息
 */
@interface WMGoodDetailSecondKillInfo : NSObject
/**秒杀名称
 */
@property (copy,nonatomic) NSString *secondKillName;
/**秒杀描述
 */
@property (copy,nonatomic) NSString *secondKillDescription;
/**秒杀开始时间
 */
@property (copy,nonatomic) NSString *secondKillBeginTime;
/**秒杀结束时间
 */
@property (copy,nonatomic) NSString *secondKillEndTime;
/**初始化
 */
+ (instancetype)returnGoodDetailSecondKillInfoWithDict:(NSDictionary *)dict;
@end












//
//  WMGoodDetailPromotionInfo.h
//  StandardShop
//
//  Created by mac on 16/6/6.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

//标签的额外宽度--计算标签内容高度用
#define WMTagExtraWidth 85.0
//标签内容的额外宽度
#define WMTagContentExtraWidth 30.0
//促销类型
typedef NS_ENUM(NSInteger, PromotionType){
    
    //商品促销
    PromotionTypeGood = 1,
    
    //订单促销
    PromotionTypeOrder = 2,
    
    //赠品促销
    PromotionTypeGift = 3,
};

/**促销内容信息
 */
@interface WMPromotionContentInfo : NSObject
/**名称
 */
@property (copy,nonatomic) NSString *contentName;
/**标签
 */
@property (copy,nonatomic) NSString *contentTag;
/**促销ID
 */
@property (copy,nonatomic) NSString *tagID;
/**点击区间
 */
@property (strong,nonatomic) NSArray *rangeArr;
/**批量初始化
 */
+ (NSArray *)returnPromotionContentInfoArrWithDictArr:(NSArray *)dictArr;
@end

/**促销详情信息
 */
@interface WMPromotionDetailInfo : NSObject
/**促销类型
 */
@property (assign,nonatomic) PromotionType type;
/**促销内容数组--内容是WMPromotionContentInfo/WMPromotionGoodInfo
 */
@property (strong,nonatomic) NSArray *promotionContentArr;
@end

/**赠品促销商品模型
 */
@interface WMPromotionGoodInfo : NSObject
/**赠品商品ID
 */
@property (copy,nonatomic) NSString *goodID;
/**赠品货品ID
 */
@property (copy,nonatomic) NSString *productID;
/**赠品商品名称
 */
@property (copy,nonatomic) NSString *goodName;
/**赠品库存
 */
@property (copy,nonatomic) NSString *goodStore;
/**批量初始化
 */
+ (NSArray *)returnPromotionGoodInfoArrWithDictArr:(NSArray *)dictArr;
@end

/**商品详情促销信息
 */
@interface WMGoodDetailPromotionInfo : NSObject
/**商品促销详情信息
 */
@property (strong,nonatomic) WMPromotionDetailInfo *goodPromotionInfo;
/**订单促销详情信息
 */
@property (strong,nonatomic) WMPromotionDetailInfo *orderPromotionInfo;
/**赠品促销详情信息
 */
@property (strong,nonatomic) WMPromotionDetailInfo *giftPromotionInfo;
/**商品促销标签数组--元素是NSString
 */
@property (strong,nonatomic) NSArray *promotionTagTitlesArr;
/**商品促销内容数组--元素是WMPromotionContentInfo
 */
@property (strong,nonatomic) NSMutableArray *promotionContentInfosArr;
/**促销内容高度
 */
@property (assign,nonatomic) CGFloat promotionContentHeight;
/**商品促销是否展开显示
 */
@property (assign,nonatomic) BOOL isDropDownShow;
/**初始化
 */
+ (instancetype)returnGoodDetailPromotionInfoWithDict:(NSDictionary *)dict;



@end

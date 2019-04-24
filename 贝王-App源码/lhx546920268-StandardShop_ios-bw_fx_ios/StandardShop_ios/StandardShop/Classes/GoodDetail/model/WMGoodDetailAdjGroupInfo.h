//
//  WMGoodDetailAdjGroupInfo.h
//  StandardShop
//
//  Created by mac on 16/6/6.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

/**商品详情的配件商品模型
 */
@interface WMGoodDetailAdjGoodInfo : NSObject
/**商品的货品ID
 */
@property (copy,nonatomic) NSString *productID;
/**商品的商品ID
 */
@property (copy,nonatomic) NSString *goodID;
/**商品的名称
 */
@property (copy,nonatomic) NSString *goodName;
/**商品的规格
 */
@property (copy,nonatomic) NSString *goodSpecInfo;
/**商品原价
 */
@property (copy,nonatomic) NSString *goodInitPrice;
/**商品的配件价
 */
@property (copy,nonatomic) NSString *goodAdjPrice;
/**商品的库存
 */
@property (copy,nonatomic) NSString *goodStore;
/**商品的图片
 */
@property (copy,nonatomic) NSString *goodImage;
/**商品的上架状态
 */
@property (assign,nonatomic) BOOL goodMarketAble;
/**当前配件是否选中
 */
@property (assign,nonatomic) BOOL isSelect;
/**批量初始化
 */
+ (NSArray *)returnGoodDetailAdjGoodInfoArrWithDictArr:(NSArray *)dictArr imagesDict:(NSDictionary *)imagesDict;

@end

/**商品详情的配件组合模型
 */
@interface WMGoodDetailAdjGroupInfo : NSObject
/**配件组合的名称
 */
@property (copy,nonatomic) NSString *groupName;
/**配件组合的类型
 */
@property (copy,nonatomic) NSString *groupType;
/**配件组合的商品数组--元素是WMGoodDetailAdjGoodInfo
 */
@property (strong,nonatomic) NSArray *groupGoodInfoArr;
/**配件组合商品的最大购买量
 */
@property (assign,nonatomic) NSInteger groupMaxBuyCount;
/**当前组合是否选择
 */
@property (assign,nonatomic) BOOL groupIsSelect;
/**批量初始化
 */
+ (NSArray *)returnGoodDetailAdjGroupInfoArrWithDictArr:(NSArray *)dictArr imagesDict:(NSDictionary *)imagesDict;
@end

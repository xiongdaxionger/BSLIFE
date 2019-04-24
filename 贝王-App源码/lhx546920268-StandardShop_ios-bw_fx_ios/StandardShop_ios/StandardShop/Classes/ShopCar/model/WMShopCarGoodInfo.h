//
//  WMShopCarGoodInfo.h
//  StandardShop
//
//  Created by mac on 16/6/20.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

//购物车的商品类型
typedef NS_ENUM(NSInteger, ShopCarGoodType){
    
    //普通商品--可勾选，可更改数量，可删除，可收藏
    ShopCarGoodTypeNormalGood = 0,
    
    //赠品(商品自带赠品、订单赠品)--不可勾选，不可更改数量，不可删除，不可收藏
    ShopCarGoodTypeGiftGood = 1,
    
    //配件商品--不可勾选，可更改数量，可删除，可收藏
    ShopCarGoodTypeAdjunctGood = 2,
    
    //积分兑换商品--可勾选，可更改数量，可删除，可收藏
    ShopCarGoodTypeExchangeGood = 3,
};

//购物车的商品组类型
typedef NS_ENUM(NSInteger, ShopCarGoodGroupType){
    
    //普通商品组
    ShopCarGoodGroupTypeNormalGroup = 0,
    
    //订单赠品组
    ShopCarGoodGroupTypeOrderGiftGroup = 1,
    
    //积分兑换组
    ShopCarGoodGroupTypeExchangeGroup = 2,
    
};

/**购物车积分兑换商品模型
 */
@interface WMShopCarExchangeGoodInfo : NSObject
/**商品类型
 */
@property (assign,nonatomic) ShopCarGoodType type;
/**目标商品的标示ID
 */
@property (copy,nonatomic) NSString *objIdent;
/**商品数量
 */
@property (copy,nonatomic) NSString *quantity;
/**商品原销售价
 */
@property (copy,nonatomic) NSAttributedString *salePrice;
/**商品ID
 */
@property (copy,nonatomic) NSString *goodID;
/**货品ID
 */
@property (copy,nonatomic) NSString *productID;
/**商品名称
 */
@property (copy,nonatomic) NSString *goodName;
/**格式化商品名称
 */
@property (copy,nonatomic) NSAttributedString *formatGoodName;
/**抵扣消耗的积分
 */
@property (copy,nonatomic) NSString *consumeScore;
/**最大可抵扣数量
 */
@property (copy,nonatomic) NSString *maxBuyCount;
/**商品规格
 */
@property (copy,nonatomic) NSString *specInfo;
/**商品图片链接
 */
@property (copy,nonatomic) NSString *thumbnail;
/**商品是否收藏
 */
@property (assign,nonatomic) BOOL isFav;
/**是否勾选--勾选需要请求网络
 */
@property (assign,nonatomic) BOOL isSelect;
/**是否勾选--编辑状态下的勾选
 */
@property (assign,nonatomic) BOOL isEditSelect;
/**初始化
 */
+ (NSArray *)returnShopCarExchangeGoodInfosArrWithDictArr:(NSArray *)dictsArr;

@end

/**订单/商品赠品模型
 */
@interface WMShopCarOrderGiftGoodInfo : NSObject
/**商品类型
 */
@property (assign,nonatomic) ShopCarGoodType type;
/**商品的销售价
 */
@property (copy,nonatomic) NSAttributedString *salePrice;
/**货品ID
 */
@property (copy,nonatomic) NSString *productID;
/**商品ID
 */
@property (copy,nonatomic) NSString *goodID;
/**商品名称
 */
@property (copy,nonatomic) NSString *goodName;
/**格式化名称
 */
@property (copy,nonatomic) NSAttributedString *formatGoodName;
/**数量
 */
@property (copy,nonatomic) NSString *quantity;
/**商品规格
 */
@property (copy,nonatomic) NSString *specInfo;
/**商品图片
 */
@property (copy,nonatomic) NSString *thumbnail;
/**标签
 */
@property (copy,nonatomic) NSString *descTag;
/**初始化
 */
+ (NSArray *)returnShopCarOrderGiftGoodInfosWithDictsArr:(NSArray *)dictsArr;

@end

/**配件商品模型
 */
@interface WMShopCarAdjunctGoodInfo : NSObject
/**商品类型
 */
@property (assign,nonatomic) ShopCarGoodType type;
/**配件商品销售价
 */
@property (copy,nonatomic) NSAttributedString *salePrice;
/**购买价
 */
@property (copy,nonatomic) NSString *buyPrice;
/**商品ID
 */
@property (copy,nonatomic) NSString *goodID;
/**最大购买量
 */
@property (copy,nonatomic) NSString *maxBuyCount;
/**货品ID
 */
@property (copy,nonatomic) NSString *productID;
/**商品名称
 */
@property (copy,nonatomic) NSString *goodName;
/**格式化商品名称
 */
@property (copy,nonatomic) NSAttributedString *formatGoodName;
/**商品购买获得的积分
 */
@property (copy,nonatomic) NSString *gainScore;
/**商品规格
 */
@property (copy,nonatomic) NSString *specInfo;
/**商品数量
 */
@property (copy,nonatomic) NSString *quantity;
/**商品图片
 */
@property (copy,nonatomic) NSString *thumbnail;
/**配件所在组别对应的ID
 */
@property (copy,nonatomic) NSString *adjunctGroupID;
/**节省的价格
 */
@property (copy,nonatomic) NSString *discountPirce;
/**商品的最终价格
 */
@property (copy,nonatomic) NSString *subtotalPrice;
/**是否收藏
 */
@property (assign,nonatomic) BOOL isFav;
/**初始化
 */
+ (NSArray *)returnShopCarAdjunctGoodInfosArrWithDcitsArr:(NSArray *)dictsArr;

@end

/**购物车普通商品模型
 */
@interface WMShopCarGoodInfo : NSObject
/**商品类型
 */
@property (assign,nonatomic) ShopCarGoodType type;
/**目标商品ID
 */
@property (copy,nonatomic) NSString *objIdent;
/**商品销售价
 */
@property (copy,nonatomic) NSString *salePrice;
/**商品购买价
 */
@property (copy,nonatomic) NSAttributedString *buyPrice;
/**商品ID
 */
@property (copy,nonatomic) NSString *goodID;
/**货品ID
 */
@property (copy,nonatomic) NSString *productID;
/**商品名称
 */
@property (copy,nonatomic) NSString *goodName;
/**商品购买所获得积分
 */
@property (copy,nonatomic) NSString *gainScore;
/**商品规格
 */
@property (copy,nonatomic) NSString *specInfo;
/**商品数量
 */
@property (copy,nonatomic) NSString *quantity;
/**商品库存
 */
@property (copy,nonatomic) NSString *goodStore;
/**商品最大购买量
 */
@property (copy,nonatomic) NSString *maxBuyCount;
/**商品图片
 */
@property (copy,nonatomic) NSString *thumbnail;
/**商品最终购买价
 */
@property (copy,nonatomic) NSString *subtotalPrice;
/**商品折扣价
 */
@property (copy,nonatomic) NSString *discountPrice;
/**是否勾选--勾选需要请求网络
 */
@property (assign,nonatomic) BOOL isSelect;
/**是否勾选--编辑状态下的勾选
 */
@property (assign,nonatomic) BOOL isEditSelect;
/**是否收藏
 */
@property (assign,nonatomic) BOOL isFav;
/**商品的配件数组--元素是WMShopCarAdjunctGoodInfo
 */
@property (strong,nonatomic) NSArray *adjunctGoodsArr;
/**商品的赠品--元素是WMShopCarOrderGiftGoodInfo
 */
@property (strong,nonatomic) NSArray *giftGoodsArr;
/**商品自带配件/赠品数组
 */
@property (strong,nonatomic) NSMutableArray *goodGiftAdjunctsArr;
/**商品享受的优惠--元素是WMShopCarPromotionRuleInfo
 */
@property (strong,nonatomic) NSArray *goodPromotionsArr;
/**商品享受的优惠属性字符串
 */
@property (strong,nonatomic) NSAttributedString *goodPromotionAttrString;
/**批量初始化
 */
+ (NSArray *)returnShopCarGoodInfosArrWithDictsArr:(NSArray *)dictsArr;

@end

/**购物车商品组别模型
 */
@interface WMShopCarGoodGroupInfo : NSObject
/**商品数组，元素可以为订单赠品商品、普通商品、积分兑换赠品
 */
@property (strong,nonatomic) NSMutableArray *goodInfosArr;
/**商品组类型
 */
@property (assign,nonatomic) ShopCarGoodGroupType type;
/**初始化
 */
+ (instancetype)returnShopCarGroupInfoWithType:(ShopCarGoodGroupType)type infosArr:(NSArray *)infosArr;
/**返回对应的商品ID
 */
- (NSString *)returnGoodIDWithIndexPath:(NSIndexPath *)indexPath;
/**返回对应的货品ID
 */
- (NSString *)returnProductIDWithIndexPath:(NSIndexPath *)indexPath;
/**返回能否侧滑控制
 */
- (BOOL)returnCanEditWithIndexPath:(NSIndexPath *)indexPath;
/**改变对应商品的收藏状态
 */
- (void)changeGoodFavStatusWithIndexPath:(NSIndexPath *)indexPath;
@end

/**凑单商品模型
 */
@interface WMShopCarForOrderGoodInfo : NSObject
/**库存
 */
@property (copy,nonatomic) NSString *store;
/**商品名称
 */
@property (copy,nonatomic) NSString *name;
/**商品ID
 */
@property (copy,nonatomic) NSString *goodID;
/**货品ID
 */
@property (copy,nonatomic) NSString *productID;
/**价格
 */
@property (copy,nonatomic) NSString *price;
/**图片
 */
@property (copy,nonatomic) NSString *image;
/**批量初始化
 */
+ (NSArray *)returnForOrderGoodInfosArrWithDictsArr:(NSArray *)dictsArr;


@end







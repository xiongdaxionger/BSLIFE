//
//  WMShopCarInfo.h
//  StandardShop
//
//  Created by mac on 16/6/20.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WMShopCarPromotionRuleInfo;
@class WMShopCarGoodInfo;



/**购物车数据模型
 */
@interface WMShopCarInfo : NSObject
/**购物车总价
 */
@property (copy,nonatomic) NSString *subtotalPrice;
/**获得的总积分
 */
@property (copy,nonatomic) NSString *subtotalGainScore;
/**总节省金额
 */
@property (copy,nonatomic) NSString *subtotalDiscount;
/**是否显示未享受优惠
 */
@property (assign,nonatomic) BOOL showUnusePromotion;
/**是否拥有订单赠品优惠
 */
@property (assign,nonatomic) BOOL isContaintOrderGift;
/**购物车未享受优惠数组--元素是WMShopCarPromotionRuleInfo
 */
@property (strong,nonatomic) NSArray *unuseRuleInfosArr;
/**购物车已享受优惠数组--元素是WMShopCarPromotionRuleInfo
 */
@property (strong,nonatomic) NSArray *useRuleInfosArr;
/**购物车的商品数组--元素是WMShopCarGoodGroupInfo
 */
@property (strong,nonatomic) NSMutableArray *shopCarGoodsArr;
/**返回当前购物车的已选商品数量
 */
- (NSInteger)returnCurrentShopCarQuantity;
/**返回当前购物车的未选商品数量
 */
- (NSInteger)returnCurrentUnSelectShopCarQuantity;
/**返回当前购物车商品是否全部选中--网络状态的选中
 */
- (BOOL)returnCurrentShopCarSelectStatus;
/**返回当前购物车商品是否全部选中--编辑状态的选中
 */
- (BOOL)returnCurrentShopCarEditSelectStatus;
/**返回当前购物车选中的商品obj_ident[]--编辑状态下/普通状态下
 */
- (NSArray *)returnCurrentShopCarSelectGoodsIdent:(BOOL)isEdit;
/**编辑状态下所有商品的选中/取消选中
 */
- (void)changeEditStatusSelect:(BOOL)isEditSelect;
/**全选商品
 */
- (void)selectAllGoodIsSelect:(BOOL)isSelect;
/**初始化
 */
+ (instancetype)returnShopCarInfoWithDict:(NSDictionary *)dict;
/**返回组数
 */
- (NSInteger)returnSectionNumbers;
/**返回每组行数
 */
- (NSInteger)returnRowNumberOfSection:(NSInteger)section;
/**返回数据模型
 */
- (id)returnInfoWithIndexPath:(NSIndexPath *)indexPath;



@end

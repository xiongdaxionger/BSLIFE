//
//  WMShopCarOpeartion.h
//  SuYan
//
//  Created by mac on 16/4/13.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WMConfirmOrderViewModel;

//加入购物车成功通知
#define WMShopCarAddSuccessNotifi @"WMShopCarAddSuccessNotifi"

//立即购买的购物车的结算
#define WMFastShopCarCheckOutIdentifier @"WMFastShopCarCheckOutIdentifier"
//加入购物车的请求
#define WMShopCarAddIdentifier @"WMShopCarAddIdentifier"
//购物车首页
#define WMShopCarPageIdentifier @"WMShopCarPageIdentifier"
//修改购物车数量
#define WMShopCarChangeQuantityIdentifier @"WMShopCarChangeQuantityIdentifier"
//获得凑单商品
#define WMShopCarForOrderIdentifier @"WMShopCarForOrderIdentifier"
//选中或取消选中购物车商品
#define WMSelectShopCarGoodIdentifier @"WMSelectShopCarGoodIdentifier"
//删除购物车中的商品
#define WMDeleteShopCarGoodIdentifier @"WMDeleteShopCarGoodIdentifier"

@interface WMShopCarOperation : NSObject

#pragma mark - new
/**加入购物车/立即购买 参数
 *@param 购买类型 btype--is_fastbuy(立即购买)/不传为加入购物车
 *@param 商品ID goods[goods_id]
 *@param 货品ID goods[product_id]
 *@param 购买数量 goods[num]
 *@param 配件参数 goods[adjunct][0][10781]--选择配件加入购物车的参数，0是配件组别的下标，10781是对应配件的货品ID
 #@param 商品类型 obj_type--goods商品/gift积分商品
 */
+ (NSMutableDictionary *)returnAddShopCarParamWithBuyType:(NSString *)buyType goodsID:(NSString *)goodsID productID:(NSString *)productID buyQuantity:(NSInteger)buyQuantity adjunctIndex:(NSInteger)adjunctIndex adjunctGoodID:(NSString *)adjunctGoodID adjunctGoodQuantity:(NSInteger)adjunctGoodQuantity goodType:(NSString *)goodsType;
/**加入购物车/立即购买 结果
 */
+ (BOOL)returnAddShopCarResultWithData:(NSData *)data;

/**购物车首页 参数
 */
+ (NSDictionary *)returnShopCarPageParam;
/**购物车首页 结果
 */
+ (id)returnShopCarPageResultWithData:(NSData *)data;

/**获得凑单商品 参数
 *@param 价格区间 tab_name
 */
+ (NSDictionary *)returnForOrderGoodWithPriceFilter:(NSString *)tabName;
/**返回凑单商品 结果
 *@return key为fororder_tab时返回凑单商品的价格区间 key为list时返回凑单商品数组
 */
+ (NSDictionary *)returnForOrderGoodResutlWithData:(NSData *)data;

/**修改购物车数量 参数
 *@param 商品类型 objType
 *@param 商品对象ID goodIdent
 *@param 商品ID goodID
 *@param 修改数量 goodQuantity
 *@param 修改配件数量 adjunctGoodQuantity
 *@param 配件所在的组别 groupID
 *@param 配件货品ID adjunctGoodProductID
 *@param 已选中的商品对象ID数组 objIdentsArr
 */
+ (NSDictionary *)returnModifyShopCarQuantityWithGoodType:(NSString *)goodType goodIdent:(NSString *)goodIdent goodID:(NSString *)goodID modifyGoodQuantity:(NSInteger)goodQuantity modifyAdjunctGoodQuantity:(NSInteger)adjunctGoodQuantity adjunctGroupID:(NSString *)groupID adjunctGoodProductID:(NSString *)adjunctGoodProductID selectObjIdentsArr:(NSArray *)objIdentsArr;
/**修改购物车数量 结果
 */
+ (BOOL)returnModifyShopCarQuantityResultWithData:(NSData *)data;

/**删除购物车商品 参数
 *@param 商品类型 objType--传all时表示删除所有商品
 *@param 商品对象ID goodIdent
 *@param 商品ID goodID
 *@param 修改数量 goodQuantity
 *@param 修改配件数量 adjunctGoodQuantity
 *@param 配件所在的组别 groupID
 *@param 配件货品ID adjunctGoodProductID
 *@param 已选中的商品对象ID数组 objIdentsArr
 */
+ (NSDictionary *)returnDeleteShopCarGoodWithGoodType:(NSString *)goodType goodIdent:(NSString *)goodIdent goodID:(NSString *)goodID modifyGoodQuantity:(NSInteger)goodQuantity modifyAdjunctGoodQuantity:(NSInteger)adjunctGoodQuantity adjunctGroupID:(NSString *)groupID adjunctGoodProductID:(NSString *)adjunctGoodProductID selectObjIdentsArr:(NSArray *)objIdentsArr;
/**删除购物车多件商品 参数
 *@param 购物车商品数组 WMShopCarGoodGroupInfo
 */
+ (NSDictionary *)returnBatchDeleteShopCarGoodWithInfosArr:(NSArray *)infosArr;
/**删除购物车数量 结果
 */
+ (BOOL)returnDeleteShopCarGoodWithData:(NSData *)data;

/**选中购物车的商品 参数
 *@param 购物车中选中的所有商品数组，元素是NSString，例--goods_1211_4321
 */
+ (NSDictionary *)returnSelectShopCarGoodParamWithGoodIdentsArr:(NSArray *)goodIdentsArr;
/**选中购物车的商品结果
 */
+ (BOOL)returnSelectShopCarGoodResultWithData:(NSData *)data;

/**设置更新购物车数量
 *@param 购物车数量 quantity
 */
+ (void)updateShopCarNumberQuantity:(NSInteger)quantity needChange:(BOOL)needChange;


@end

//
//  WMGoodDetailOperation.h
//  WanShoes
//
//  Created by mac on 16/3/11.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WMSaleStoreCountTableViewCell.h"

#import "WMPromotionDropTableViewCell.h"
#import "WMPromotionUpTableViewCell.h"
#import "WMPromotionContentTableViewCell.h"

#import "WMGoodCommentTableViewCell.h"

#import "WMGoodAdviceTableViewCell.h"

#import "WMGoodShowInfoTableViewCell.h"
#import "WMSelectSpecInfoTableViewCell.h"

#import "WMGoodPureTextTableViewCell.h"

#import "WMGoodTagTableViewCell.h"

#import "WMGoodBrandTableViewCell.h"

#import "WMGoodLinkTableViewCell.h"
#import "WMGoodAdjTableViewCell.h"

#import "WMUpLoadMoreTableViewCell.h"

#import <Contacts/Contacts.h>
#import <AddressBook/AddressBook.h>
@class WMGoodDetailInfo;
@class WMGoodDetailPromotionInfo;
@class WMShopContactInfo;
//获取商品详情网络请求
#define WMGoodDetailRequestIdentifier @"WMGoodDetailRequestIndentifier"
//获取商品相关商品网络请求
#define WMGoodDetailSimilarRequestIdentifier @"WMGoodDetailSimilarRequestIdentifier"
//获取货品信息网络请求
#define WMProductDetailRequestIdentifier @"WMProductDetailRequestIdentifier"
//获取商品销售记录
#define WMGoodDetailSellLogRequestIdentifier @"WMGoodDetailSellLogRequestIdentifier"
//获取商品品牌网络请求
#define WMGoodBrandIdentifier @"WMGoodBrandIdentifier"
//提交缺货登记
#define WMGoodCommitNotifyIdentifier @"WMGoodCommitNotifyIdentifier"
//记录商品访问量的请求
#define WMRecordGoodVisitIdentifier @"WMRecordGoodVisitIdentifier"
//获取商家联系信息
#define WMGetShopContactIdentifier @"WMGetShopContactIdentifier"


@interface WMGoodDetailOperation : NSObject
#pragma mark - new
/**获取商品详情 参数
 *@param 货品ID productID
 *@param 是否为积分兑换赠品 isGift
 */
+ (NSDictionary *)returnGoodDetailParamWithProductID:(NSString *)productID isGift:(BOOL)isGift;
/**获取商品详情 结果
 *@return WMGoodDetailInfo
 */
+ (id)returnGoodDetailInfoWithData:(NSData *)data;

/**获取商品相似商品 参数
 *@param 商品ID goodID
 */
+ (NSDictionary *)returnGoodSimilarGoodParamWithGoodID:(NSString *)goodID;
/**返回商品相似商品 结果
 */
+ (NSArray *)returnGoodSimilarArrWithData:(NSData *)data;

/**获取商品的销售记录 参数
 *@param 商品ID goodID
 *@param 页码 page
 */
+ (NSDictionary *)returnGoodSellLogWithGoodID:(NSString *)goodID page:(NSInteger)page;
/**返回商品的销售记录 结果
 *@return 销售记录数组--sellLog 是否展示购买价--showPrice 总数--total
 */
+ (NSDictionary *)returnGoodSellLogWithData:(NSData *)data;

/**获取货品的信息 参数--选择某个规格后之后调用
 *@param 货品ID productID
 *@param 是否为赠品 isGift
 */
+ (NSDictionary *)returnProductInfoWithProductID:(NSString *)productID isGift:(BOOL)isGift;

/**计算标签高度
 *@param 最大宽度 maxWidth
 *@param 内容数组,元素是NSString titlesArr
 *@param 额外宽度 extraWidth
 *@param cell的高度 cellHeight
 */
+ (CGFloat)returnTagContentHeightWithMaxWidth:(CGFloat)maxWidth titlesArr:(NSArray *)titlesArr extraWidth:(CGFloat)extraWidth tagCellHeight:(CGFloat)tagCellHeight;

/**商品详情配置类--秒杀商品和普通商品
 */
+ (NSArray *)returnSecondKillCommonGoodTableConfigWithTableView:(UITableView *)tableView;
/**商品详情配置类--预售商品
 */
+ (NSArray *)returnPrepareGoodTableConfigWithTableView:(UITableView *)tableView;
/**返回商品详情的促销信息行数
 */
+ (NSInteger)returnGoodPromotionRowCountWith:(WMGoodDetailPromotionInfo *)promotionInfo;
/**返回单个商品集合视图高度
 */
+ (CGFloat)returnGoodCollectionViewCellHeight;

/**提交商品缺货登记 参数
 *@param 商品ID goodID
 *@param 货品ID productID
 *@param 电话 cellPhone
 *@param 邮箱 email
 */
+ (NSDictionary *)returnGoodCommitNotifyWithGoodID:(NSString *)goodID productID:(NSString *)productID cellPhone:(NSString *)cellPhone email:(NSString *)email;
/**提交商品缺货登记 结果
 */
+ (BOOL)returnGoodCommitNotifyWithData:(NSData *)data;

/**记录商品访问量 参数
 *@param 商品ID goodID
 */
+ (NSDictionary *)returnRecordGoodVisitParamWithGoodID:(NSString *)goodID;

/**获取商家的联系信息
 */
+ (NSDictionary *)returnShopContactInfoParam;
/**返回商家的联系信息
 */
+ (NSDictionary *)returnShopContactInfo:(NSData *)data;

+ (CNMutableContact *)getContactIsExist:(BOOL)isExist contact:(CNMutableContact *)contact;
+ (ABRecordRef)getAddressBookRecord;

/**通过BN 获取商品的productId 参数
 *@param BN 商品BN
 */
+ (NSDictionary*)productIdFromBNParam:(NSString*) BN;

/**通过BN 获取商品的productId 结果
 *@return 商品 BN
 */
+ (NSString*)productIdFromData:(NSData*) data;
 
 
@end

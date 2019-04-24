//
//  WMGoodDetailInfo.h
//  StandardShop
//
//  Created by mac on 16/6/6.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

//秒杀/普通商品组类型
typedef NS_ENUM(NSInteger, GoodSectionType){
    
    //秒杀限购
    GoodSectionTypeSecondKillLimit = 0,
    
    //销量
    GoodSectionTypeSale = 1,
    
    //库存
    GoodSectionTypeStore = 2,
    
    //促销
    GoodSectionTypePromotion = 3,
    
    //商品评价
    GoodSectionTypeComment = 4,
    
    //商品咨询
    GoodSectionTypeAdvice = 5,
    
    //拓展属性和规格选择
    GoodSectionTypeSpecInfo = 6,
    
    //商品简介
    GoodSectionTypeBrief = 7,
    
    //商品标签
    GoodSectionTypeTag = 8,
    
    //商品品牌
    GoodSectionTypeBrand = 9,
    
    //相关商品和优惠套餐
    GoodSectionTypeLinkAdjGood = 10,
    
    //上拉查看更多
    GoodSectionTypeLoadMore = 11,
};

//预售商品组类型
typedef NS_ENUM(NSInteger, PrepareGoodSectionType){
    
    //预售状态
    PrepareGoodSectionTypeStatus = 0,
    
    //商品评价
    PrepareGoodSectionTypeComment = 1,
    
    //商品咨询
    PrepareGoodSectionTypeAdvice = 2,
    
    //拓展属性和规格选择
    PrepareGoodSectionTypeSpecInfo = 3,
    
    //商品简介
    PrepareGoodSectionTypeBrief = 4,
    
    //商品标签
    PrepareGoodSectionTypeTag = 5,
    
    //商品品牌
    PrepareGoodSectionTypeBrand = 6,
    
    //相关商品
    PrepareGoodSectionTypeLinkGood = 7,
    
    //上拉查看更多
    PrepareGoodSectionTypeLoadMore = 8,
};

//商品促销类型
typedef NS_ENUM(NSInteger, GoodPromotionType){
    
    //无促销
    GoodPromotionTypeNothing = 1,
    
    //预售促销
    GoodPromotionTypePrepare = 2,
    
    //秒杀促销
    GoodPromotionTypeSecondKill = 3,
    
    //积分兑换商品
    GoodPromotionTypeGift = 4,
};

@class WMGoodDetailPointInfo;
@class WMGoodDetailSettingInfo;
@class WMGoodDetailPromotionInfo;
@class WMGoodDetailSecondKillInfo;
@class WMGoodDetailPrepareInfo;
@class WMBrandInfo;
@class WMGoodSimilarInfo;
@class WMGoodDetailGiftInfo;

/**商品详情模型
 */
@interface WMGoodDetailInfo : NSObject
/**设置信息
 */
@property (strong,nonatomic) WMGoodDetailSettingInfo *settingInfo;
/**商品的评分信息
 */
@property (strong,nonatomic) WMGoodDetailPointInfo *pointInfo;
/**商品的咨询人数
 */
@property (copy,nonatomic) NSString *adviceCount;
/**商品的分享链接
 */
@property (copy,nonatomic) NSString *shareURL;
/**商品的按钮列表-后台可控加入购物车/立即购买/缺货登记/下架
 */
@property (strong,nonatomic) NSArray *buttonPageList;
/**商品的菜单栏数组--元素是WMGoodDetailTabInfo
 */
@property (strong,nonatomic) NSMutableArray *goodMenuBarInfosArr;
/**商品的配件数组--元素是WMGoodDetailAdjGroupInfo
 */
@property (strong,nonatomic) NSArray *goodAdjGroupsArr;
/**商品的配件组名--元素是NSString
 */
@property (strong,nonatomic) NSMutableArray *goodAdjGroupsNameArr;
/**商品的规格详细参数--元素是WMGoodDetailParamInfo
 */
@property (strong,nonatomic) NSArray *goodDetailParamsArr;
/**商品的拓展属性--元素是NSDictionary
 */
@property (strong,nonatomic) NSArray *goodPropsArr;
/**商品的标签信息数组--元素是NSString
 */
@property (strong,nonatomic) NSArray *goodTagsArr;
/**商品的规格参数--元素是WMGoodDetailSpecInfo
 */
@property (strong,nonatomic) NSArray *goodSpecInfosArr;
/**商品的图片数组--元素是NSString
 */
@property (strong,nonatomic) NSMutableArray *goodImagesArr;
/**商品的推荐商品--元素是WMGoodSimilarInfo
 */
@property (strong,nonatomic) NSArray *goodSimilarGoodsArr;
/**商品的品牌信息
 */
@property (strong,nonatomic) WMBrandInfo *goodBrandInfo;
/**商品的促销信息
 */
@property (strong,nonatomic) WMGoodDetailPromotionInfo *promotionInfo;
/**商品的预售信息--预售商品
 */
@property (strong,nonatomic) WMGoodDetailPrepareInfo *prepareInfo;
/**商品的预售信息
 */
@property (strong,nonatomic) NSAttributedString *prepareAttrString;
/**商品的秒杀信息--秒杀商品
 */
@property (strong,nonatomic) WMGoodDetailSecondKillInfo *secondKillInfo;
/**积分兑换商品的信息
 */
@property (strong,nonatomic) WMGoodDetailGiftInfo *giftMessageInfo;
/**商品ID
 */
@property (copy,nonatomic) NSString *goodID;
/**商品月购买量
 */
@property (copy,nonatomic) NSString *goodBuyCount;
/**商品购买数量--默认为1
 */
@property (assign,nonatomic) long goodBuyQuantity;
/**选中的货品ID
 */
@property (copy,nonatomic) NSString *productID;
/**商品的BN码
 */
@property (copy,nonatomic) NSString *goodBNCode;
/**选中的货品BN码
 */
@property (copy,nonatomic) NSString *productBNCode;
/**商品的二维码
 */
@property (copy,nonatomic) NSString *goodQRCode;
/**商品的图文详情描述
 */
@property (copy,nonatomic) NSString *goodIntro;
/**商品的单位
 */
@property (copy,nonatomic) NSString *goodUnit;
/**商品的名称
 */
@property (copy,nonatomic) NSString *goodName;
/**商品的简介描述信息
 */
@property (strong,nonatomic) NSAttributedString *goodBrief;
/**商品的类型名称
 */
@property (copy,nonatomic) NSString *goodTypeName;
/**商品的分类名称
 */
@property (copy,nonatomic) NSString *goodCatName;
/**商品的市场价
 */
@property (copy,nonatomic) NSString *goodMarketPrice;
/**商品的市场价展示名称
 */
@property (copy,nonatomic) NSString *goodFxName;
/**商品的分销佣金
 */
@property (copy,nonatomic) NSString *goodFxPrice;
/**商品的分销佣金展示名称
 */
@property (copy,nonatomic) NSString *goodMarketName;
/**商品的展示价
 */
@property (copy,nonatomic) NSString *goodShowPrice;
/**商品的展示价名称
 */
@property (copy,nonatomic) NSString *goodShowPriceName;
/**商品的最低价格
 */
@property (copy,nonatomic) NSString *goodMinPrice;
/**商品的最低价格名称
 */
@property (copy,nonatomic) NSString *goodMinPriceName;
/**商品的优惠价--预售商品不存在任何促销
 */
@property (copy,nonatomic) NSString *goodSavePrice;
/**商品的优惠价展示名称
 */
@property (copy,nonatomic) NSString *goodSavePriceName;
/**商品的优惠价格单位
 */
@property (copy,nonatomic) NSString *goodSavePriceUnit;
/**商品的库存展示内容--后台可控显示(预售商品没有库存)
 */
@property (copy,nonatomic) NSString *goodStore;
/**商品的库存数量
 */
@property (copy,nonatomic) NSString *goodRealStore;
/**商品的最大购买量
 */
@property (assign,nonatomic) NSInteger goodLismitCout;
/**商品选中的当前规格的货品图片
 */
@property (copy,nonatomic) NSString *selectSpecProductImage;
/**商品选中的规格组合字符串
 */
@property (strong,nonatomic) NSAttributedString *specInfoAttrString;
/**商品的促销类型
 */
@property (assign,nonatomic) GoodPromotionType type;
/**商品是否收藏
 */
@property (assign,nonatomic) BOOL goodIsFav;
/**货品是否下架
 */
@property (assign,nonatomic) BOOL marketAble;
/**初始化
 */
+ (instancetype)returnGoodDetailInfoWithDict:(NSDictionary *)dict;
/**返回商品详情信息每组行数
 */
- (NSInteger)returnGoodDetailInfoSectionRowCountWithSection:(NSInteger)section;
/**返回商品详情信息每行高度
 */
- (CGFloat)returnGoodDetailInfoRowHeightWithIndexPath:(NSIndexPath *)indexPath menuBarSelectIndex:(NSInteger)menuBarSelectIndex;
/**返回商品详情页头部视图高度
 */
- (CGFloat)returnGoodDetailInfoHeaderViewHeightWithSection:(NSInteger)section;
/**返回商品详情页尾部视图高度
 */
- (CGFloat)returnGoodDetailInfoFooterViewHeightWithSection:(NSInteger)section;
/**更改商品购买数量显示
 */
+ (NSAttributedString *)changeGoodBuyQuantityWithNewQuantity:(NSInteger)quantity specInfosArr:(NSArray *)specInfosArr goodUnit:(NSString *)unit;
/**更新数据
 */
- (void)updataGoodDetailInfoWithDetailInfo:(WMGoodDetailInfo *)newInfo;


@end

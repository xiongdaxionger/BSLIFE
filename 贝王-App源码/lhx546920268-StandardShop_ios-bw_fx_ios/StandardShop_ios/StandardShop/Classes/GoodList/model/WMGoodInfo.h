//
//  WMGoodInfo.h
//  WuMei
//
//  Created by 罗海雄 on 15/7/18.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMGoodTagInfo.h"
#import "WMGoodMarkInfo.h"
#import "WMGoodDetailPrepareInfo.h"

@class WMGoodDetailViewModel;

/**商品信息
 */
@interface WMGoodInfo : NSObject

/**商品Id
 */
@property(nonatomic,copy) NSString *goodId;

/**货品Id
 */
@property (copy,nonatomic) NSString *productId;

/**商品名称
 */
@property(nonatomic,copy) NSString *goodName;

/**商品简介
 */
@property(nonatomic,copy) NSString *brief;

/**商品名称富文本
 */
@property(nonatomic,copy) NSAttributedString *attributedGoodName;

/**商品价格
 */
@property(nonatomic,copy) NSString *price;

/**市场价格
 */
@property(nonatomic,copy) NSString *marketPrice;

/**销量
 */
@property(nonatomic,assign) long long sales;

/**是否已收藏
 */
@property(nonatomic,assign) BOOL isCollect;

/**是否上架
 */
@property(nonatomic,assign) BOOL isMarket;

/**是否是预售商品
 */
@property(nonatomic,assign) BOOL isPresell;

/**预售商品状态
 */
@property (assign,nonatomic) PrepareSaleType preapreType;

/**预售状态提示信息
 */
@property (copy,nonatomic) NSString *prepareMessage;

/**秒杀是否已售罄
 */
@property(nonatomic,assign) BOOL secondKillIsSoldout;

/**是否已订阅 秒杀列表没开始时用到
 */
@property(nonatomic,assign) BOOL isSubscribed;

/**商品图片
 */
@property(nonatomic,copy) NSString *imageURL;

/**参与人数
 */
@property(nonatomic,assign) long long actorCount;

/**评论数量
 */
@property(nonatomic,assign) long long commentCount;

/**评论数量宽度
 */
@property(nonatomic,assign) CGFloat commentCountWidth;

/**获取格式化的价格
 */
@property(nonatomic,strong) NSAttributedString *formatPrice;

/**获取格式化的价格，如果有优惠，返回价格和优惠价格的组合，否则返回价格，使用默认字体
 */
@property(nonatomic,strong) NSAttributedString *formatPriceConbination;

/**获取格式化的市场价格 没有则返回nil
 */
@property(nonatomic,strong) NSAttributedString *formatMarketPrice;

/**库存
 */
@property(nonatomic,assign) long long inventory;

/**商品分享的链接
 */
@property(nonatomic,copy) NSString *shareURL;

/**商品标签信息 数组元素是 WMGoodTagInfo
 */
@property(nonatomic,strong) NSArray *tagInfos;

/**标记信息，如促销、限购 数组元素是 WMGoodMarkInfo
 */
@property(nonatomic,strong) NSArray *markInfos;

/**行高
 */
@property(nonatomic,assign) CGFloat rowHeight;

/**通过字典创建
 */
+ (instancetype)infoFromDictionary:(NSDictionary*) dic;

/**通过给定字体获取价格组合
 *@param priceFontSize 价格字体大小
 *@param marketPriceFontSize 市场价字体大小
 *@return 价格组合 会使用缓存
 */
- (NSAttributedString*)formatPriceConbinationWithPriceFontSize:(CGFloat) priceFontSize marketPriceFontSize:(CGFloat) marketPriceFontSize;

/**获取格式化的价格
 *@param fontSize 字体大小
 */
- (NSAttributedString*)formatPriceWithFontSize:(CGFloat) fontSize;

/**获取格式化的市场价格 没有则返回nil
 *@param fontSize 字体大小
 */
- (NSAttributedString*)formatMarketPriceWithFontSize:(CGFloat) fontSize;

/**格式化的参与人数
 *@param flag 秒杀是否已开始
 */
- (NSAttributedString*)formatActorCountWithPromotionBegan:(BOOL) flag;

/**从链接里面获取货品id
 *@param url 链接
 *@return 如果存在货品id， 否则返回nil
 */
+ (NSString*)productIdFromURL:(NSString*) url;

@end

//
//  WMGoodInfo.m
//  WuMei
//
//  Created by 罗海雄 on 15/7/18.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "WMGoodInfo.h"
#import "WMGoodDetailInfo.h"
#import "WMServerTimeOperation.h"

@interface WMGoodInfo ()

@end

@implementation WMGoodInfo

/**通过字典创建
 */
+ (instancetype)infoFromDictionary:(NSDictionary*) dic
{
    
    WMGoodInfo *info = [[[self class] alloc] init];
    info.goodId = [dic sea_stringForKey:@"goods_id"];
    info.sales = [[dic numberForKey:@"buy_count"] longLongValue];
    info.isCollect = [[dic sea_stringForKey:@"is_fav"] boolValue];
    info.goodName = [dic sea_stringForKey:@"name"];
    info.brief = [dic sea_stringForKey:@"brief"];
    info.imageURL = [dic sea_stringForKey:@"image_default_id"];
    info.commentCount = [[dic numberForKey:@"comments_count"] longLongValue];

    ///产品信息
    NSDictionary *product = [dic dictionaryForKey:@"products"];
    info.productId = [product sea_stringForKey:@"product_id"];

    NSDictionary *priceDic = [product dictionaryForKey:@"price_list"];
   // info.price = [[priceDic dictionaryForKey:@"show"] sea_stringForKey:@"format"];
    info.marketPrice = [[priceDic dictionaryForKey:@"mktprice"] sea_stringForKey:@"format"];
    info.price = [[priceDic dictionaryForKey:@"price"] sea_stringForKey:@"format"];;
    info.shareURL = [product sea_stringForKey:@"url"];
    info.inventory = [[product numberForKey:@"store"] longLongValue];


    NSDictionary *prepareDict = [product dictionaryForKey:@"prepare"];
    info.isPresell = [[prepareDict numberForKey:@"status"] boolValue];
    
    if (prepareDict) {
        info.preapreType = [[prepareDict numberForKey:@"status"] integerValue];
        info.prepareMessage = [prepareDict sea_stringForKey:@"message"];
    }
    
    ///标签
    info.tagInfos = [WMGoodTagInfo infosFromDictionary:dic];
    info.markInfos = [WMGoodMarkInfo infosFromDictionary:dic];

    return info;
}

/**获取格式化的价格
 */
- (NSAttributedString*)formatPrice
{
    return [self formatPriceWithFontSize:17.0];
}

/**获取格式化的价格
 *@param fontSize 字体大小
 */
- (NSAttributedString*)formatPriceWithFontSize:(CGFloat) fontSize
{
    if(!_formatPrice)
    {
        _formatPrice = [WMPriceOperation formatPrice:self.price font:[UIFont fontWithName:MainFontName size:fontSize]];
    }

    return _formatPrice;
}

/**格式化的参与人数
 *@param flag 秒杀是否已开始
 */
- (NSAttributedString*)formatActorCountWithPromotionBegan:(BOOL) flag
{
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"参与人数:%lld人", flag ? self.actorCount : 0]];
    [text addAttribute:NSForegroundColorAttributeName value:WMRedColor range:NSMakeRange(5, text.length - 5)];
    
    return text;
}

/**商品名称富文本
 */
- (NSAttributedString*)attributedGoodName
{
    if(![NSString isEmpty:self.goodName] && !_attributedGoodName)
    {
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:self.goodName];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 5.0;
        style.lineBreakMode = NSLineBreakByTruncatingTail;
        [text addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
        
        return _attributedGoodName = text;
    }
    
    return _attributedGoodName;
}

/**获取价格和优惠价格的组合
 */
- (NSAttributedString*)formatPriceConbination
{
    return [self formatPriceConbinationWithPriceFontSize:18.0 marketPriceFontSize:13.0];
}

/**获取格式化的市场价格 没有则返回nil
 */
- (NSAttributedString*)formatMarketPrice
{
    return [self formatMarketPriceWithFontSize:13.0];
}

/**获取格式化的市场价格 没有则返回nil
 *@param fontSize 字体大小
 */
- (NSAttributedString*)formatMarketPriceWithFontSize:(CGFloat) fontSize
{
    if(!_formatMarketPrice)
    {
        _formatMarketPrice = [WMPriceOperation formatMarketPrice:self.marketPrice fontSize:fontSize];
    }

    return _formatMarketPrice;
}

/**通过给定字体获取价格组合
 *@param priceFontSize 价格字体大小
 *@param marketPriceFontSize 市场价字体大小
 *@return 价格组合 会使用缓存
 */
- (NSAttributedString*)formatPriceConbinationWithPriceFontSize:(CGFloat) priceFontSize marketPriceFontSize:(CGFloat) marketPriceFontSize
{
    if(!_formatPriceConbination)
    {
        _formatPriceConbination = [WMPriceOperation formatPriceConbinationWithPrice:self.price priceFont:[UIFont fontWithName:MainFontName size:priceFontSize] marketPrice:self.marketPrice marketPriceFontSize:marketPriceFontSize];
    }
    
    return _formatPriceConbination;
}

/**从链接里面获取货品id
 *@param url 链接
 *@return 如果存在货品id， 否则返回nil
 */
+ (NSString*)productIdFromURL:(NSString *)url
{
    ///判断该链接是否是商品详情
    NSRange range = [url rangeOfString:SeaNetworkDomainName];
    if(range.location != NSNotFound)
    {
        range = [url rangeOfString:@"product-"];
        if(range.location != NSNotFound)
        {
            ///获取商品id
            NSString *productId = [url substringFromIndex:range.location + range.length];
            
            ///后面是否还有其他参数
            range = [productId rangeOfString:@"&"];
            if(range.location != NSNotFound)
            {
                productId = [productId substringToIndex:range.location];
            }
            
            ///后面是否已结束
            range = [productId rangeOfString:@"."];
            if(range.location != NSNotFound)
            {
                productId = [productId substringToIndex:range.location];
            }
            return productId;
        }
        
        range = [url rangeOfString:@"product_id="];
        if(range.location != NSNotFound)
        {
            ///获取商品id
            NSString *productId = [url substringFromIndex:range.location + range.length];
            
            ///后面是否还有其他参数
            range = [productId rangeOfString:@"&"];
            if(range.location != NSNotFound)
            {
                productId = [productId substringToIndex:range.location];
            }
            
            return productId;
        }
    }
    
    return nil;
}

@end

//
//  WMPriceOperation.m
//  StandardShop
//
//  Created by 罗海雄 on 16/7/28.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMPriceOperation.h"

@implementation WMPriceOperation

/**通过给定字体获取价格组合
 *@param price 价格
 *@param priceFont 价格字体
 *@param marketPrice 市场价格
 *@param marketPriceFontSize 市场价字体大小
 *@return 价格组合 会使用缓存
 */
+ (NSMutableAttributedString*)formatPriceConbinationWithPrice:(NSString*) price
                                             priceFont:(UIFont *) priceFont
                                           marketPrice:(NSString*) marketPrice
                                   marketPriceFontSize:(CGFloat) marketPriceFontSize
{
    if(marketPrice)
    {
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];
        [text appendAttributedString:[WMPriceOperation formatPrice:price font:priceFont]];
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
        [text appendAttributedString:[WMPriceOperation formatMarketPrice:marketPrice fontSize:marketPriceFontSize]];
        
        return  text;
    }
    else
    {
        return [WMPriceOperation formatPrice:price font:priceFont];
    }
}

/**获取格式化的价格
 *@param price 价格
 *@param font 字体
 */
+ (NSMutableAttributedString*)formatPrice:(NSString*)price font:(UIFont *) font
{
    if(price)
    {
        NSInteger index = 0;
        
        ///判断第一个字符是否是数字
        if(price.length > 0)
        {
            NSString *first = [price substringToIndex:1];
            if(![first isNumText])
            {
                index = 1;
            }
        }
        
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:price];
        [text addAttribute:NSForegroundColorAttributeName value:WMPriceColor range:NSMakeRange(0, price.length)];
        [text addAttribute:NSFontAttributeName value:font range:NSMakeRange(index, price.length - index)];
        
        if(index > 0)
        {
            [text addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:font.pointSize - 5] range:NSMakeRange(0, index)];
        }
        
        ///设置小数点后两位的字体
        NSRange range = [price rangeOfString:@"."];
        if(range.location != NSNotFound && range.location + 1 < price.length)
        {
            range.length = price.length - range.location;
            [text addAttribute:NSFontAttributeName value:[UIFont fontWithName:font.fontName size:font.pointSize - 5] range:range];
        }
        
        return text;
    }
    
    return nil;
}

/**获取格式化的市场价格 没有则返回nil
 *@param marketPrice 市场价格
 *@param fontSize 字体大小
 */
+ (NSMutableAttributedString*)formatMarketPrice:(NSString*) marketPrice fontSize:(CGFloat) fontSize
{
    if(marketPrice)
    {
        NSInteger index = 0;
        
        ///判断第一个字符是否是数字
        if(marketPrice.length > 0)
        {
            NSString *first = [marketPrice substringToIndex:1];
            if(![first isNumText])
            {
                index = 1;
            }
        }
        
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:marketPrice];
        [text addAttribute:NSForegroundColorAttributeName value:WMMarketPriceColor range:NSMakeRange(0, marketPrice.length)];
        [text addAttribute:NSFontAttributeName value:[UIFont fontWithName:MainNumberFontName size:fontSize] range:NSMakeRange(index, marketPrice.length - index)];
        
        if(index > 0)
        {
            [text addAttribute:NSFontAttributeName value:[UIFont fontWithName:MainFontName size:fontSize - 3] range:NSMakeRange(0, 1)];
        }
        
        [text addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithUnsignedInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, text.length)];
        
        ///设置小数点后两位的字体
        NSRange range = [marketPrice rangeOfString:@"."];
        if(range.location != NSNotFound && range.location + 1 < marketPrice.length)
        {
            range.length = marketPrice.length - range.location;
            [text addAttribute:NSFontAttributeName value:[UIFont fontWithName:MainNumberFontName size:fontSize - 3] range:range];
        }
        return text;
    }
    
    return nil;
}


@end

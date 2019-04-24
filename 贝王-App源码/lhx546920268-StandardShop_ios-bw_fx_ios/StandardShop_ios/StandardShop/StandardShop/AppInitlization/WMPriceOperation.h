//
//  WMPriceOperation.h
//  StandardShop
//
//  Created by 罗海雄 on 16/7/28.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

/**价格颜色
 */
#define WMPriceColor [UIColor colorFromHexadecimal:@"E54646"]

/**市场价格颜色
 */
#define WMMarketPriceColor [UIColor grayColor]

///价格小数
#define WMPriceFormat @"%.2f"

///价格操作
@interface WMPriceOperation : NSObject

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
                                   marketPriceFontSize:(CGFloat) marketPriceFontSize;

/**获取格式化的价格
 *@param price 价格
 *@param font 字体
 */
+ (NSMutableAttributedString*)formatPrice:(NSString*)price font:(UIFont *) font;

/**获取格式化的市场价格 没有则返回nil
 *@param marketPrice 市场价格
 *@param fontSize 字体大小
 */
+ (NSMutableAttributedString*)formatMarketPrice:(NSString*) marketPrice fontSize:(CGFloat) fontSize;

@end

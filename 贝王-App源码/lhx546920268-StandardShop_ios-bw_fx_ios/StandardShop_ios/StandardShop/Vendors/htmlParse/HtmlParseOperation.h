//
//  HtmlParseOperation.h
//  连你
//
//  Created by kinghe005 on 14-4-19.
//  Copyright (c) 2014年 KingHe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HtmlParseOperation : NSObject

/**从 html中获取图片 img标签中的信息
 *@param htmlString 要获取图片html内容
 *@param count 图片数量 传 NSNotFound获取所有图片
 *@return 图片数组，数组元素是 NSString 图片路径
 */
+ (NSMutableArray *)analyticalImageFromHtmlString:(NSString*) htmlString count:(NSInteger) count;

/**从 html中获取文本内容 p标签中的内容
 *@param htmlString 数据源
 *@param count 文本段落数量 传 NSNotFound获取所有文本段落
 *@return 文本数组，数组元素是 NSString 文本段落
 */
+ (NSMutableArray*)analyticalTextFromHtmlString:(NSString *)htmlString count:(NSInteger)count;

@end

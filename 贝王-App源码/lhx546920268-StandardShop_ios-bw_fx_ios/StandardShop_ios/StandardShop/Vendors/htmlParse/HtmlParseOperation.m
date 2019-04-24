//
//  HtmlParseOperation.m
//  连你
//
//  Created by kinghe005 on 14-4-19.
//  Copyright (c) 2014年 KingHe. All rights reserved.
//

#import "HtmlParseOperation.h"
#import "TFHpple.h"

//static NSString *const png = @"png";
//static NSString *const jpg = @"jpg";
//static NSString *const jpeg = @"jpeg";
//static NSString *const bmp = @"bmp";
//static NSString *const gif = @"gif";
//static NSString *const tiff = @"tiff";
//static NSString *const pcx = @"pcx";

static NSString *const data_src = @"data-src";
static NSString *const src = @"src";

static NSString *const img = @"//img";
static NSString *const linker = @"//link";
static NSString *const href = @"href";

@implementation HtmlParseOperation

/**从 html中获取图片
 *@param htmlString 要获取图片内容
 *@param count 图片数量 传 NSNotFound获取所有图片
 *@return 图片数组，数组元素是 NSString 图片路径
 */
+ (NSMutableArray *)analyticalImageFromHtmlString:(NSString*) htmlString count:(NSInteger) count
{
    
    //NSString *imageStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
//    
  //  NSLog(@"%@",imageStr);
//    
//    NSRange rang1 = [imageStr rangeOfString:@"<div class=\"content\">"];
//    if(rang1.location == NSNotFound)
//        return nil;
//    NSInteger index = rang1.location+rang1.length;
//    if(index > imageStr.length)
//        return nil;
//    
//    NSMutableString *imageStr2 = [[[NSMutableString alloc] initWithString:[imageStr substringFromIndex:index]] autorelease];
//    
//    NSRange rang2 = [imageStr2 rangeOfString:@"<div class=\"clear\">"];
//    
//    if(rang2.location == NSNotFound)
//        return nil;
//    
//    index = rang2.location;
//    if(index > imageStr2.length)
//        return nil;
//    
//    NSMutableString *imageStr3 = [[[NSMutableString alloc]initWithString:[imageStr2 substringToIndex:index]] autorelease];
//    
//    NSLog(@"%@",imageStr3);
    
    NSData *dataTitle = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    TFHpple *xpathParser = [[TFHpple alloc]initWithHTMLData:dataTitle];

    NSArray *elements = [xpathParser searchWithXPathQuery:img];
   // NSLog(@"%@",elements);
    
    
    NSString *key = src;
    NSMutableArray *imageArray = [HtmlParseOperation getImageFromElements:elements count:count key:key];
    
    if(imageArray.count == 0)
    {
        elements = [xpathParser searchWithXPathQuery:linker];
      //  NSLog(@"link %@",elements);
        key = href;
        imageArray = [HtmlParseOperation getImageFromElements:elements count:count key:key];
    }
    
    return imageArray;
}

+ (NSMutableArray*)getImageFromElements:(NSArray*) elements count:(NSInteger) count key:(NSString*) key
{
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    
   // NSLog(@"%@",elements);
    
    for (TFHppleElement *element in elements)
    {
        NSDictionary *elementContent = [element attributes];
        
        NSString *url = [elementContent objectForKey:data_src];
        
       // NSLog(@"%@", url);
        if(!url)
        {
            url = [elementContent objectForKey:key];
        }
        
        if(url != nil && ![url isEqual:[NSNull null]])
        {
            [imageArray addObject:url];
//            NSRange range = [url rangeOfString:@"?"];
//            
//            if(range.location == NSNotFound && [HtmlParseOperation containImageSuffix:url])
//            {
//                [imageArray addObject:url];
//            }
            if(imageArray.count == count)
            {
                break;
            }
        }
    }
    
    return imageArray;
}

+ (BOOL)containImageSuffix:(NSString*) url
{
//    NSString *lowercase = [url lowercaseString];
//    if([lowercase hasSuffix:png])
//        return YES;
//    if([lowercase hasSuffix:jpg])
//        return YES;
//    if([lowercase hasSuffix:jpeg])
//        return YES;
//    if([lowercase hasSuffix:gif])
//        return YES;
//    if([lowercase hasSuffix:tiff])
//        return YES;
//    if([lowercase hasSuffix:pcx])
//        return YES;
    
    return YES;
}

/**从 html中获取文本内容 p标签中的内容
 *@param htmlString 数据源
 *@param count 文本段落数量 传 NSNotFound获取所有文本段落
 *@return 文本数组，数组元素是 NSString 文本段落
 */
+ (NSMutableArray*)analyticalTextFromHtmlString:(NSString *)htmlString count:(NSInteger)count
{
    NSData *dataTitle = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    TFHpple *xpathParser = [[TFHpple alloc]initWithHTMLData:dataTitle];
    
    NSArray *elements = [xpathParser searchWithXPathQuery:@"p"];
    NSLog(@"%@",elements);
    
    NSMutableArray *texts = [NSMutableArray array];
    for(TFHppleElement *element in elements)
    {
        NSString *content = element.content;
        if([NSString isEmpty:content])
        {
            [texts addObject:content];
        }
        if(texts.count >= count)
            break;
    }
    
    return texts;
}


@end

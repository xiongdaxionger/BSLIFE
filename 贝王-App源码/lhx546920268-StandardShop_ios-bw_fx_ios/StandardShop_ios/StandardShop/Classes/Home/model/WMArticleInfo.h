//
//  WMArticleInfo.h
//  WuMei
//
//  Created by 罗海雄 on 15/8/17.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import <Foundation/Foundation.h>

/**文章信息
 */
@interface WMArticleInfo : NSObject

///文章标题
@property(nonatomic,copy) NSString *title;

///文章html
@property(nonatomic,copy) NSString *contentHtml;

@end

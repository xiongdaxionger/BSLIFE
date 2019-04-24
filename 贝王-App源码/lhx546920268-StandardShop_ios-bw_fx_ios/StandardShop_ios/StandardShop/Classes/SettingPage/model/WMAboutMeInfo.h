//
//  WMAboutMeInfo.h
//  WanShoes
//
//  Created by 罗海雄 on 16/3/28.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

///关于我们信息
@interface WMAboutMeInfo : NSObject

///关于我们html
@property(nonatomic,copy) NSString *html;

///通过字典创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic;

@end

//
//  WMBrandInfo.h
//  WanShoes
//
//  Created by 罗海雄 on 16/3/31.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

///品牌信息
@interface WMBrandInfo : NSObject<NSCopying>

///品牌id
@property(nonatomic,copy) NSString *Id;

///品牌名称
@property(nonatomic,copy) NSString *name;

///品牌图片
@property(nonatomic,copy) NSString *imageURL;

///通过字典创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic;

@end

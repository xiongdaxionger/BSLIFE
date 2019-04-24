//
//  WMFoundCategoryInfo.h
//  WanShoes
//
//  Created by 罗海雄 on 16/3/22.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

///发现分类信息
@interface WMFoundCategoryInfo : NSObject

///分类id
@property(nonatomic,copy) NSString *Id;

///分类名称
@property(nonatomic,copy) NSString *name;

///分类描述
@property(nonatomic,copy) NSString *intro;

///分类图标
@property(nonatomic,copy) NSString *imageURL;

///是否选中
@property(nonatomic,assign) BOOL selected;

///所属发现列表信息，数组元素是 WMFoundListInfo
@property(nonatomic,strong) NSMutableArray *infos;

///从字典创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic;

@end

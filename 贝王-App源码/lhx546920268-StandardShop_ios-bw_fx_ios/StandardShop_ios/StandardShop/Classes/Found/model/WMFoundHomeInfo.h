//
//  WMFoundHomeInfo.h
//  SuYan
//
//  Created by 罗海雄 on 16/4/29.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>


///发现首页信息类型
typedef NS_ENUM(NSInteger, WMFoundHomeInfoType)
{
    ///轮播广告栏 数组元素是 WMHomeAdInfo
    WMFoundHomeInfoTypeBillboards = 0,
    
    ///靓贴推荐 数组元素是 WMFoundListInfo
    WMFoundHomeInfoTypePost,
    
    ///社区板块 数组元素是 WMFoundCategoryInfo
    WMFoundHomeInfoTypePlate,
};

///发现首页信息
@interface WMFoundHomeInfo : NSObject

///名称
@property(nonatomic,copy) NSString *name;

///信息类型
@property(nonatomic,assign) WMFoundHomeInfoType type;

///数据，不同的类型，数组元素不一样
@property(nonatomic,strong) NSArray *infos;

///大小
@property(nonatomic,assign) CGSize size;

@end

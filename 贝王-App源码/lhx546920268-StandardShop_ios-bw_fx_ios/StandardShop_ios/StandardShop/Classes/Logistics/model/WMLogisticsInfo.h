//
//  WMLogisticsInfo.h
//  WanShoes
//
//  Created by 罗海雄 on 16/3/21.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

///物流信息
@interface WMLogisticsInfo : NSObject

///物流公司名称
@property(nonatomic,copy) NSString *name;

///物流单号
@property(nonatomic,copy) NSString *number;

///物流详情信息 数组元素是 WMLogisticsDetailInfo
@property(nonatomic,strong) NSArray *infos;

///通过字典创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic;

@end


///物流详情信息
@interface WMLogisticsDetailInfo : NSObject

///内容
@property(nonatomic,copy) NSString *content;

///内容高度 default is '0'
@property(nonatomic,assign) CGFloat contentHeight;

///时间
@property(nonatomic,copy) NSString *time;



@end
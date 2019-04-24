//
//  WMGoodCommentOverallInfo.h
//  StandardShop
//
//  Created by 罗海雄 on 16/6/2.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

///商品评论总评信息
@interface WMGoodCommentOverallInfo : NSObject

///总评评分
@property(nonatomic,assign) float totalScore;

///评分信息，数组元素是 WMGoodCommentScoreInfo
@property(nonatomic,strong) NSArray *scoreInfos;

///筛选信息 数组元素是 WMGoodCommentFilterInfo
@property(nonatomic,strong) NSArray *filterInfos;

///回复所需的验证码链接
@property(nonatomic,copy) NSString *codeURL;

///是否可以回复
@property(nonatomic,assign) BOOL enableReply;

///通过字典创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic;

@end

///筛选信息
@interface WMGoodCommentFilterInfo : NSObject

///筛选名称
@property(nonatomic,copy) NSString *name;

///筛选值，用于接口调用
@property(nonatomic,copy) NSString *value;

///评论数量
@property(nonatomic,assign) long long count;

@end

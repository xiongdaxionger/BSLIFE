//
//  WMGoodCommentRuleInfo.h
//  StandardShop
//
//  Created by 罗海雄 on 16/6/29.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

///评分规则信息
@interface WMGoodCommentRuleInfo : NSObject

///评论提示信息
@property(nonatomic,copy) NSString *placeHolder;

///评分信息，数组元素是 WMGoodCommentScoreInfo
@property(nonatomic,strong) NSArray *scoreInfos;

///评价所需的验证码链接，nil则不需要验证码
@property(nonatomic,copy) NSString *codeURL;

///通过字典创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic;

@end

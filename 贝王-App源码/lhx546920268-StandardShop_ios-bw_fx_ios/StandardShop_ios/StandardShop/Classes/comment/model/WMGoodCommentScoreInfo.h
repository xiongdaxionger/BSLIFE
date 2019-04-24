//
//  WMGoodCommentScoreInfo.h
//  StandardShop
//
//  Created by 罗海雄 on 16/6/29.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

///商品评分信息
@interface WMGoodCommentScoreInfo : NSObject

///评分规则id
@property(nonatomic,copy) NSString *Id;

///评分标题
@property(nonatomic,copy) NSString *name;

///评分
@property(nonatomic,assign) float score;

///是否是默认评分
@property(nonatomic,assign) BOOL isDefault;

@end

//
//  WMShakeInfo.h
//  WanShoes
//
//  Created by 罗海雄 on 16/3/21.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

///摇一摇信息
@interface WMShakeInfo : NSObject

///今日可摇次数
@property(nonatomic,assign) int timesToShake;

//可摇次数字符串
@property(nonatomic,readonly) NSString *timesToShakeString;

///是否是无限次
@property(nonatomic,assign) BOOL isInfinite;

///摇一摇规则
@property(nonatomic,copy) NSString *rule;

@end

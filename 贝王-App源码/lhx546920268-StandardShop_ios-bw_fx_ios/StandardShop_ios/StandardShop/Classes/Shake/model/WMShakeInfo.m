//
//  WMShakeInfo.m
//  WanShoes
//
//  Created by 罗海雄 on 16/3/21.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "WMShakeInfo.h"

@implementation WMShakeInfo

- (NSString*)timesToShakeString
{
    //可摇次数字符串
    if(self.isInfinite)
    {
        return @"无限";
    }
    else
    {
        return [NSString stringWithFormat:@"%d", self.timesToShake];
    }
}

@end

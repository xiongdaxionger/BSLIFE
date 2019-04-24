//
//  WMGoodCategorySeparator.m
//  StandardShop
//
//  Created by 罗海雄 on 16/7/27.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodCategorySeparator.h"

@implementation WMGoodCategorySeparator

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = _separatorLineColor_;
    }
    
    return self;
}

@end

//
//  WMInegralGoodInfo.m
//  StandardShop
//
//  Created by 罗海雄 on 16/7/4.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMInegralGoodInfo.h"

@implementation WMInegralGoodInfo

- (NSString*)integral
{
    if(!_integral)
        return @"0";

    return _integral;
}

- (NSAttributedString*)integralAttributedString
{
    if(!_integralAttributedString)
    {
        NSString *integral = self.integral;
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@积分", integral]];
        [text addAttribute:NSFontAttributeName value:[UIFont fontWithName:MainNumberFontName size:17.0] range:NSMakeRange(0, integral.length)];
        _integralAttributedString = text;
    }

    return _integralAttributedString;
}

@end

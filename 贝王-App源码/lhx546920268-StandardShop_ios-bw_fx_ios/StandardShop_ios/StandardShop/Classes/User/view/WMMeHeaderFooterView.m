//
//  WMMeHeaderFooterView.m
//  StandardShop
//
//  Created by 罗海雄 on 16/8/31.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMMeHeaderFooterView.h"

@implementation WMMeHeaderFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = _SeaViewControllerBackgroundColor_;
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, _separatorLineWidth_)];
        _line.backgroundColor = _separatorLineColor_;
        
        [self addSubview:_line];
    }
    
    return self;
}

@end

//
//  WMGoodCommentAddFooter.m
//  StandardShop
//
//  Created by 罗海雄 on 16/6/29.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodCommentAddFooter.h"

@implementation WMGoodCommentAddFooter

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, _width_, 65.0)];
    if(self)
    {
        CGFloat margin = 15.0;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, 10.0, 70.0, self.height - 10.0)];
        _titleLabel.textColor = [UIColor grayColor];
        _titleLabel.font = [UIFont fontWithName:MainFontName size:16.0];
        _titleLabel.text = @"匿名评价";
        [self addSubview:_titleLabel];

        _aSwitch = [[UISwitch alloc] init];
        _aSwitch.on = YES;
        _aSwitch.center = CGPointMake(_titleLabel.right + 30.0, _titleLabel.top / 2.0 + self.height / 2.0);
        [self addSubview:_aSwitch];
    }

    return self;
}

@end

//
//  WMFoundHomeMoreSectionFooterView.m
//  SuYan
//
//  Created by 罗海雄 on 16/4/29.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMFoundHomeMoreSectionFooterView.h"

@implementation WMFoundHomeMoreSectionFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _more_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_more_btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _more_btn.titleLabel.font = [UIFont fontWithName:MainFontName size:15.0];
        [_more_btn setTitle:@"戳进更多靓贴 >" forState:UIControlStateNormal];
        _more_btn.frame = self.bounds;
        [_more_btn addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_more_btn];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

///更多
- (void)moreAction:(UIButton*) btn
{
    if([self.delegate respondsToSelector:@selector(foundHomeMoreSectionFooterViewDidTapMore:)])
    {
        [self.delegate foundHomeMoreSectionFooterViewDidTapMore:self];
    }
}

@end

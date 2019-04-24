//
//  WMBrandIntroHeader.m
//  StandardShop
//
//  Created by 罗海雄 on 16/6/28.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMBrandIntroHeader.h"

@implementation WMBrandIntroHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
    }

    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGRect frame = self.bounds;
    _webView.frame = frame;
}

- (void)setWebView:(UIWebView *)webView
{
    _webView = webView;
    if(_webView.superview != self)
    {
        [_webView removeFromSuperview];
        [self addSubview:_webView];
    }
}

- (void)dealloc
{
    [_webView clean];
}


@end

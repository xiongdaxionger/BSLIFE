//
//  WMFoundCommentHeaderView.m
//  WanShoes
//
//  Created by 罗海雄 on 16/4/7.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "WMFoundCommentHeaderView.h"

@implementation WMFoundCommentHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _webView = [[UIWebView alloc] initWithFrame:self.bounds];
        _webView.scalesPageToFit = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:_webView];
    }
    
    return self;
}

@end

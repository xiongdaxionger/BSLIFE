//
//  WMUserLevelInfoCell.m
//  StandardShop
//
//  Created by 罗海雄 on 16/6/30.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMUserLevelInfoCell.h"

@implementation WMUserLevelInfoCell

- (instancetype)init
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WMUserLevelInfoCell"];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, _width_, 1)];
        _webView.delegate = self;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.scalesPageToFit = NO;
        _webView.scrollView.bounces = NO;
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.userInteractionEnabled = NO;
        [self.contentView addSubview:_webView];
    }

    return self;
}

- (void)dealloc
{
    [_webView clean];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGRect frame = self.bounds;
    _webView.frame = frame;
}

#pragma mark- UIWebView delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGFloat height = 0;
    webView.height = 1;
    height = webView.scrollView.contentSize.height;
    !self.webViewDidFinishLoadingHandler ?: self.webViewDidFinishLoadingHandler(height);
}

@end

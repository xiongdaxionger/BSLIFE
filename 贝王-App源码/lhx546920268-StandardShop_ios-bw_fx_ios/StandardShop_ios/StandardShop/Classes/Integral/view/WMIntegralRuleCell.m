//
//  MysourceRuleCell.m
//  WuMei
//
//  Created by mac on 15/8/12.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "WMIntegralRuleCell.h"

@implementation WMIntegralRuleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, _width_, 0)];
        _webView.scalesPageToFit = NO;
        _webView.scrollView.bounces = NO;
        _webView.userInteractionEnabled = NO;
        [self.contentView addSubview:_webView];
    }
    return self;
}

@end

//
//  WMWebTableViewCell.m
//  StandardShop
//
//  Created by mac on 16/6/17.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodDetailWebTableViewCell.h"

@implementation WMGoodDetailWebTableViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, _width_, frame.size.height)];
        
        self.webView.userInteractionEnabled = NO;
        
        self.webView.scrollView.showsHorizontalScrollIndicator = NO;
        
        self.webView.scrollView.showsVerticalScrollIndicator = NO;
        
        self.webView.scalesPageToFit = NO;
                
        [self.contentView addSubview:self.webView];
    }
    
    return self;
}

@end

//
//  WMShakeRuleViewController.m
//  WanShoes
//
//  Created by 罗海雄 on 16/3/17.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "WMShakeRuleViewController.h"
#import "WMShakeOperation.h"

@interface WMShakeRuleViewController ()<SeaHttpRequestDelegate>

///网络请求
@property(nonatomic,strong) SeaHttpRequest *httpRequest;

@end

@implementation WMShakeRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    self.title_label.textColor = [UIColor blackColor];
    self.title_label.font = [UIFont fontWithName:MainFontName size:20.0];
    self.content_textView.font = [UIFont fontWithName:MainFontName size:16.0];
    self.close_btn.layer.cornerRadius = 25.0 / 2.0;
    self.close_btn.layer.borderColor = [UIColor blackColor].CGColor;
    self.close_btn.layer.borderWidth = 1.0;
    self.reload_btn.layer.cornerRadius = 5.0;
    self.reload_btn.layer.borderColor = [self.reload_btn titleColorForState:UIControlStateNormal].CGColor;
    self.reload_btn.layer.borderWidth = 1.2;
    
    self.loading = NO;
    
    ///添加关闭手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    self.content_textView.text = self.rule;
    self.content_textView.editable = NO;
    self.content_textView.selectable = NO;
    
    CGSize size = [self.content_textView.text stringSizeWithFont:self.content_textView.font contraintWith:_width_ - 18.0 * 2];
    
    self.white_bg_view.sea_heightLayoutConstraint.constant = MAX(200, size.height + 8.0 * 2 + 50.0);
}

- (void)setLoading:(BOOL)loading
{
    loading ? [self.act_view startAnimating] : [self.act_view stopAnimating];
    self.content_textView.hidden = loading;
    self.reload_btn.hidden = YES;
}

///关闭
- (IBAction)closeAction:(id)sender
{
    [self dismiss];
}

- (IBAction)reloadAction:(id)sender
{
    self.loading = YES;
    
}

- (void)failToLoadData
{
    self.loading = NO;
    self.reload_btn.hidden = NO;
    self.content_textView.hidden = YES;
}

///点击手势
- (void)handleTap:(UITapGestureRecognizer*) tap
{
    [self dismiss];
}

#pragma mark- http

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
    
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{
    
}

#pragma mark- UITapGestureRecognizer delegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:self.view];
    if(CGRectContainsPoint(_white_bg_view.frame, point))
    {
        return NO;
    }
    
    return YES;
}

@end

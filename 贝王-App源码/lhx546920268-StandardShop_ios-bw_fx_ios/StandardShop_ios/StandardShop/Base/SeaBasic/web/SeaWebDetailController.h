//
//  SeaWebDetailController.h
//  StandardShop
//
//  Created by 罗海雄 on 17/9/12.
//  Copyright © 2017年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

///使用web作为详情
@interface SeaWebDetailController : NSObject<UIWebViewDelegate>

///webview
@property(nonatomic, readonly) UIWebView *webView;

//设置父视图
- (void)setSuperview:(UIView*) superview;

//web初始化高
- (instancetype)initWithFrame:(CGRect) frame;

@end

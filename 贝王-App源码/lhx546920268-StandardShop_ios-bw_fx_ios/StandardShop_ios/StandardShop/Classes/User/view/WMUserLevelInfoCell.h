//
//  WMUserLevelInfoCell.h
//  StandardShop
//
//  Created by 罗海雄 on 16/6/30.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

///等级介绍cell 通过init方法初始化，静态cell，不重用
@interface WMUserLevelInfoCell : UITableViewCell<UIWebViewDelegate>

///html简介
@property(nonatomic,readonly) UIWebView *webView;

///webView加载完成回调， height内容高度
@property(nonatomic,copy) void(^webViewDidFinishLoadingHandler)(CGFloat height);

@end

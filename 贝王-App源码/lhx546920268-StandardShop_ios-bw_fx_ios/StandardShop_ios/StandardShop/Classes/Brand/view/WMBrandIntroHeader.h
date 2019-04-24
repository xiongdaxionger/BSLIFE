//
//  WMBrandIntroHeader.h
//  StandardShop
//
//  Created by 罗海雄 on 16/6/28.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMBrandIntroHeader;

///品牌简介
@interface WMBrandIntroHeader : UICollectionReusableView<UIWebViewDelegate>

///html简介
@property(nonatomic,strong) UIWebView *webView;

@end

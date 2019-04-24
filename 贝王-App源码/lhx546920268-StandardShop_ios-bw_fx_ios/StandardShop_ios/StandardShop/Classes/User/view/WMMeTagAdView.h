//
//  WMMeTagAdView.h
//  StandardShop
//
//  Created by 罗海雄 on 16/6/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>


///广告标签
@interface WMMeTagAdCell : SeaTextInsetLabel


@end

///标签广告
@interface WMMeTagAdView : UIView

///标签信息 数组元素是 WMHomeAdInfo 设置此值会刷新UI
@property(nonatomic, strong) NSArray *tags;

///跳转导航
@property(nonatomic,weak) UINavigationController *navigationController;

///显示标签
- (void)show;

@end

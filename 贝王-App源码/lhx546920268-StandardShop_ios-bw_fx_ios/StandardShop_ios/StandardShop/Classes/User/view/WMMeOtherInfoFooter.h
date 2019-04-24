//
//  WMMeSectionHeaderView.h
//  SuYan
//
//  Created by 罗海雄 on 16/4/14.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

///高度
#define WMMeOtherInfoFooterHeight (90.0 * WMDesignScale + 10.0 * 2)

@class WMMeViewController;

///个人中心 其他信息section footer
@interface WMMeOtherInfoFooter : UICollectionViewCell

///跳转导航
@property(nonatomic,weak) WMMeViewController *meViewController;

///刷新数据
- (void)reloadData;

@end

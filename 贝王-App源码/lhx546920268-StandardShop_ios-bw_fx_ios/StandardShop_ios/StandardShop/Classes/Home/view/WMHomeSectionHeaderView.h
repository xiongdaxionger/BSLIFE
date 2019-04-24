//
//  WMHomeSectionHeaderView.h
//  StandardShop
//
//  Created by 罗海雄 on 16/6/22.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMHomeInfo;

///高度
#define WMHomeSectionHeaderViewHeight 40

///首页section标题
@interface WMHomeSectionHeaderView : UICollectionReusableView

///标题
@property (weak, nonatomic) IBOutlet UILabel *title_label;

///右边线条
@property (weak, nonatomic) IBOutlet UIView *right_line;

///左边线条
@property (weak, nonatomic) IBOutlet UIView *left_line;

///底部分割线
@property (weak, nonatomic) IBOutlet UIView *bottom_line;

///用于不是居中对齐的标题
@property (weak, nonatomic) IBOutlet UILabel *align_title_label;

///首页信息
@property (strong, nonatomic) WMHomeInfo *info;

@end

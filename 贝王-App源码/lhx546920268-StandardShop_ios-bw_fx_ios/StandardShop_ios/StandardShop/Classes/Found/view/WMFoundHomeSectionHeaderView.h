//
//  WMFoundHomeSectionHeaderView.h
//  SuYan
//
//  Created by 罗海雄 on 16/4/29.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

///大小
#define WMFoundHomeSectionHeaderViewSize CGSizeMake(_width_, 55.0)

///发现首页section 头部
@interface WMFoundHomeSectionHeaderView : UICollectionReusableView

///标记视图
@property (weak, nonatomic) IBOutlet UIView *tag_view;

///标题
@property (weak, nonatomic) IBOutlet UILabel *title_label;

///分割线
@property (weak, nonatomic) IBOutlet UIView *line;

@end

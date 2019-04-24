//
//  WMFoundHomeSectionHeaderView.m
//  SuYan
//
//  Created by 罗海雄 on 16/4/29.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMFoundHomeSectionHeaderView.h"

@implementation WMFoundHomeSectionHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.line.backgroundColor = _SeaViewControllerBackgroundColor_;
    self.backgroundColor = [UIColor whiteColor];
    self.tag_view.backgroundColor = _appMainColor_;
    self.title_label.font = [UIFont boldSystemFontOfSize:16.0];
}

@end

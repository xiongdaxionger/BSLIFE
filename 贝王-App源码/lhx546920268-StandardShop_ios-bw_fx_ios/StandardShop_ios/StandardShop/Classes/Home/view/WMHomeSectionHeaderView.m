//
//  WMHomeSectionHeaderView.m
//  StandardShop
//
//  Created by 罗海雄 on 16/6/22.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMHomeSectionHeaderView.h"
#import "WMHomeInfo.h"

@implementation WMHomeSectionHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];

    self.title_label.font = [UIFont fontWithName:MainFontName size:17.0];
    self.backgroundColor = [UIColor whiteColor];
    self.left_line.sea_heightLayoutConstraint.constant = _separatorLineWidth_;
    self.right_line.sea_heightLayoutConstraint.constant = _separatorLineWidth_;
    self.left_line.backgroundColor = _separatorLineColor_;
    self.right_line.backgroundColor = _separatorLineColor_;
    
    self.bottom_line.sea_heightLayoutConstraint.constant = _separatorLineWidth_;
    self.bottom_line.backgroundColor = _separatorLineColor_;
}

- (void)setInfo:(WMHomeInfo *)info
{
    if(_info != info)
    {
        _info = info;
        
        self.backgroundColor = _info.backgroundColor ? _info.backgroundColor : [UIColor clearColor];
        self.bottom_line.hidden = !_info.shouldDisplaySeparator;
        
        if(_info.shouldDisplayTitle)
        {
            if(_info.titleAlignment == NSTextAlignmentCenter)
            {
                self.title_label.hidden = NO;
                self.left_line.hidden = !_info.showLine;
                self.right_line.hidden = !_info.showLine;
                self.title_label.text = _info.title;
                self.title_label.textColor = _info.titleColor;
                self.align_title_label.hidden = YES;
                self.left_line.backgroundColor = _info.titleColor;
                self.right_line.backgroundColor = _info.titleColor;
            }
            else
            {
                self.left_line.hidden = YES;
                self.right_line.hidden = YES;
                self.title_label.hidden = YES;
                self.align_title_label.text = _info.title;
                self.align_title_label.textColor = _info.titleColor;
                self.align_title_label.hidden = NO;
                self.align_title_label.textAlignment = _info.titleAlignment;
            }
        }
        else
        {
            self.title_label.hidden = YES;
            self.align_title_label.hidden = YES;
        }
    }
}

@end

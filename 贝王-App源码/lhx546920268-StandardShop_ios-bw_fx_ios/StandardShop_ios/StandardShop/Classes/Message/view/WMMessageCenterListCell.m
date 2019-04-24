//
//  WMMessageCenterListCell.m
//  StandardShop
//
//  Created by 罗海雄 on 16/7/15.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMMessageCenterListCell.h"
#import "WMMessageCenterInfo.h"

@implementation WMMessageCenterListCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.red_point.layer.cornerRadius = 6.0;
    self.red_point.layer.borderColor = [UIColor whiteColor].CGColor;
    self.red_point.layer.borderWidth = 1.0;
    self.red_point.backgroundColor = WMRedColor;

    self.title_label.font = [UIFont fontWithName:MainFontName size:13.0];
    
    self.bottom_line.sea_heightLayoutConstraint.constant = _separatorLineWidth_;
    self.right_line.sea_widthLayoutConstraint.constant = _separatorLineWidth_;
    self.bottom_line.backgroundColor = _separatorLineColor_;
    self.right_line.backgroundColor = _separatorLineColor_;
    
    [self.red_point.superview bringSubviewToFront:self.red_point];
}

- (void)setInfo:(WMMessageCenterInfo *)info
{
    _info = info;
    [self.icon_imageView sea_setImageWithURL:_info.imageURL];
    self.title_label.text = _info.name;
    self.red_point.hidden = _info.unreadMsgCount == 0;
    self.icon_imageView.hidden = _info == nil;
    self.title_label.hidden = _info == nil;
}

- (void)setIndex:(NSInteger)index
{
    if(_index != index)
    {
        _index = index;
        
        if((_index + 1) % WMMessageCenterListCellCountPerRow == 0)
        {
            self.right_line.hidden = YES;
        }
        else
        {
            self.right_line.hidden = NO;
        }
    }
}

@end

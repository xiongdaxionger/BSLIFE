//
//  WMMessageSystemReplyListCell.m
//  StandardShop
//
//  Created by 罗海雄 on 16/8/1.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMMessageSystemReplyListCell.h"
#import "WMMessageInfo.h"

@implementation WMMessageSystemReplyListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.title_label.font = [UIFont fontWithName:MainFontName size:16.0];
    self.content_label.font = [UIFont fontWithName:MainFontName size:14.0];
    self.time_label.font = [UIFont fontWithName:MainFontName size:11.0];
    self.content_label.textColor = MainGrayColor;
    self.time_label.textColor = [UIColor grayColor];
}

- (void)setInfo:(WMMessageSystemInfo *)info
{
    if(_info != info)
    {
        _info = info;
        self.title_label.text = _info.title;
        self.time_label.text = _info.time;
        self.content_label.text = _info.subtitle;
    }
}

///行高
+ (CGFloat)rowHeightForInfo:(WMMessageSystemInfo*) info
{
    if(info.subtitleHeight == 0)
    {
        CGFloat width = _width_ - 10 * 2 - 15.0 - 5.0;
        CGSize size = [info.subtitle stringSizeWithFont:[UIFont fontWithName:MainFontName size:14.0] contraintWith:width];
        info.subtitleHeight = size.height + 1.0;
    }
    
    return 10.0 + 20.0 + 10.0 + (info.subtitleHeight > 0 ? (10.0 + info.subtitleHeight) : 0);
}

@end

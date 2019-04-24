//
//  WuliuTableViewCell.m
//  WuMei
//
//  Created by mac on 15/7/29.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "WMLogisticsListCell.h"
#import "WMLogisticsInfo.h"

@implementation WMLogisticsListCell

- (void)awakeFromNib {
    // Initialization code
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.content_label.font = [UIFont fontWithName:MainFontName size:12];
    
    self.time_label.font = [UIFont fontWithName:MainFontName size:12];
    
    [self.content_label setTextColor:[UIColor lightGrayColor]];
    [self.time_label setTextColor:[UIColor lightGrayColor]];
    
    [self.contentView bringSubviewToFront:self.point_imageView];
}

- (void)setInfo:(WMLogisticsDetailInfo *)info
{
    if(_info != info)
    {
        _info = info;
        
        self.content_label.text = info.content;
        self.time_label.text = info.time;
    }
}

///通过物流信息获取cell高度
+ (CGFloat)rowHeightWithInfo:(WMLogisticsDetailInfo*) info
{
    if(info.contentHeight == 0)
    {
        info.contentHeight = MAX(21.0, [info.content stringSizeWithFont:[UIFont fontWithName:MainFontName size:12] contraintWith:_width_ - WMLogisticsListCellMargin - 15.0].height + 1.0);
    }
    
    return info.contentHeight + 10.0 * 2 + 21.0;
}

@end

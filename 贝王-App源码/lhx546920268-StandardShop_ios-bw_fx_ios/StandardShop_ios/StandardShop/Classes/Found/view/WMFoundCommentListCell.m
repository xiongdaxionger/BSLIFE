//
//  WMFoundCommentListCell.m
//  WanShoes
//
//  Created by 罗海雄 on 16/3/23.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "WMFoundCommentListCell.h"
#import "WMFoundCommentInfo.h"

///边距
#define WMFoundCommentListCellMargin 10.0

@implementation WMFoundCommentListCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.head_imageView.layer.cornerRadius = 40.0 / 2.0;
    self.head_imageView.layer.masksToBounds = YES;
    self.head_imageView.userInteractionEnabled = YES;
    self.head_imageView.sea_placeHolderImage = [UIImage imageNamed:@"default_head_image"];
    [self.head_imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)]];
    
    self.name_label.textColor = MainGrayColor;
    self.name_label.font = [UIFont fontWithName:MainFontName size:15.0];
    self.time_label.font = [UIFont fontWithName:MainFontName size:12.0];
    self.content_label.font = [UIFont fontWithName:MainFontName size:15.0];
    self.time_label.textColor = [UIColor grayColor];
    self.content_label.textColor = [UIColor blackColor];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.level_label.font = [UIFont fontWithName:MainFontName size:11.0];
    self.level_label.textColor = [UIColor whiteColor];
    self.level_bgView.layer.cornerRadius = self.level_label.font.lineHeight / 2.0;
    self.level_bgView.backgroundColor = WMRedColor;
    self.level_bgView.layer.masksToBounds = YES;
    [self.contentView bringSubviewToFront:self.level_label];
    self.head_imageView.sea_originContentMode = UIViewContentModeScaleAspectFit;
}

- (void)setInfo:(WMFoundCommentInfo *)info
{
    if(_info != info)
    {
        _info = info;
        [self.head_imageView sea_setImageWithURL:_info.userInfo.headImageURL];
        self.time_label.text = _info.time;
        self.content_label.text = _info.content;
        self.name_label.text = _info.userInfo.displayName;
        self.level_label.text = _info.userInfo.level;
    }
}

///通过评论信息计算行高
+ (CGFloat)rowHeightWithInfo:(WMFoundCommentInfo*) info
{
    if(info.contentHeight == 0)
    {
        info.contentHeight = [info.content stringSizeWithFont:[UIFont fontWithName:MainFontName size:15.0] contraintWith:_width_ - WMFoundCommentListCellMargin * 3 - 40.0].height + 1.0;
    }
    
    return WMFoundCommentListCellMargin + 40.0 + 10.0 + info.contentHeight + WMFoundCommentListCellMargin;
}

///点击头像
- (void)handleTap:(UITapGestureRecognizer*) tap
{
    if([self.delegate respondsToSelector:@selector(foundCommentListCellHeaderImageDidTap:)])
    {
        [self.delegate foundCommentListCellHeaderImageDidTap:self];
    }
}

@end

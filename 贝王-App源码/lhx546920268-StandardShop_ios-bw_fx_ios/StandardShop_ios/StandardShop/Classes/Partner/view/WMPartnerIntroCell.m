//
//  WMPartnerDetailIntroCell.m
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/3.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMPartnerIntroCell.h"
#import "WMPartnerIntroInfo.h"
#import "WMPartnerLevelView.h"

@implementation WMPartnerIntroCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIFont *font = WMPartnerIntroCellFont;
        CGFloat y = (WMPartnerIntroCellHeight - font.lineHeight) / 2.0;
        
        self.titleWidth = WMPartnerIntroCellTitleWidth;
        self.contentHeight = font.lineHeight;
        
        //标题
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(WMPartnerIntroCellMargin, y, WMPartnerIntroCellTitleWidth, font.lineHeight)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor grayColor];
        _titleLabel.font = font;
        [self.contentView addSubview:_titleLabel];
        
        //内容
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.right + WMPartnerIntroCellControlInterval, y, _width_ - WMPartnerIntroCellMargin * 2 - WMPartnerIntroCellControlInterval - WMPartnerIntroCellTitleWidth, font.lineHeight)];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.font = font;
        _contentLabel.numberOfLines = 0;
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_contentLabel];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _titleLabel.width = _titleWidth;
    
    CGRect frame = _contentLabel.frame;
    frame.origin.x = _titleLabel.right + WMPartnerIntroCellControlInterval;
    
    CGFloat width = self.contentView.width - WMPartnerIntroCellMargin * 2 - WMPartnerIntroCellControlInterval - _titleWidth;
    
    frame.size.width = width;
    frame.size.height = _contentHeight;
    _contentLabel.frame = frame;
}

- (void)setInfo:(WMPartnerIntroInfo *)info
{
    if(_info != info)
    {
        _info = info;
        self.titleWidth = _info.titleWidth;
        self.contentHeight = _info.contentHeight;
        self.titleLabel.text = _info.title;
        self.contentLabel.text = _info.content;
    }
}

@end

@implementation WMPartnerIntroLevelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIFont *font = WMPartnerIntroCellFont;
        CGFloat y = (WMPartnerIntroCellHeight - font.lineHeight) / 2.0;
        
        //标题
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(WMPartnerIntroCellMargin, y, WMPartnerIntroCellTitleWidth, font.lineHeight)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor grayColor];
        _titleLabel.font = font;
        [self.contentView addSubview:_titleLabel];
        
        _levelView = [[WMPartnerLevelView alloc] initWithFrame:CGRectMake(_titleLabel.right + WMPartnerIntroCellControlInterval, (WMPartnerIntroCellHeight - 20.0) / 2.0, _width_ - WMPartnerIntroCellControlInterval - _titleLabel.right - WMPartnerIntroCellMargin, 20.0)];
        [self.contentView addSubview:_levelView];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _titleLabel.width = _titleWidth;
    
    CGRect frame = _levelView.frame;
    frame.origin.x = _titleLabel.right + WMPartnerIntroCellControlInterval;
    
    CGFloat width = self.contentView.width - WMPartnerIntroCellMargin * 2 - WMPartnerIntroCellControlInterval - _titleWidth;
    
    frame.size.width = width;
    _levelView.frame = frame;
}

@end

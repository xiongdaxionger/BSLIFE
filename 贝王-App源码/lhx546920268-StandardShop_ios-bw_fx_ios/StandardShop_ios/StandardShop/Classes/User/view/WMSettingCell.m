//
//  WMSettingCell.m
//  WestMailDutyFee
//
//  Created by 罗海雄 on 15/8/26.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMSettingCell.h"
#import "WMSettingInfo.h"

@implementation WMSettingCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        UIFont *font = WMSettingCellFont;
        CGFloat y = (WMSettingCellHeight - font.lineHeight) / 2.0;
        
        self.titleWidth = WMSettingCellTitleWidth;
        self.contentHeight = font.lineHeight;
        
        //标题
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(WMSettingCellMargin, y, WMSettingCellTitleWidth, font.lineHeight)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = font;
        [self.contentView addSubview:_titleLabel];
        
        //内容
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.right + WMSettingCellControlInterval, y, _width_ - WMSettingCellMargin * 2 - WMSettingCellArrowWidth - WMSettingCellControlInterval * 2 - WMSettingCellTitleWidth, font.lineHeight)];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.textColor = [UIColor grayColor];
        _contentLabel.font = font;
        _contentLabel.numberOfLines = 0;
        _contentLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_contentLabel];
        
        //箭头
        UIImage *image = [UIImage imageNamed:@"arrow_gray"];
        _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_width_ - WMSettingCellMargin - WMSettingCellArrowWidth, 0, WMSettingCellArrowWidth, image.size.height)];
        _arrowImageView.contentMode = UIViewContentModeCenter;
        _arrowImageView.image = image;
        [self.contentView addSubview:_arrowImageView];
        
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _titleLabel.width = _titleWidth;
    
    CGRect frame = _contentLabel.frame;
    frame.origin.x = _titleLabel.right + WMSettingCellControlInterval;
    
    CGFloat width = _width_ - WMSettingCellMargin * 2 - WMSettingCellArrowWidth - WMSettingCellControlInterval * 2 - _titleWidth;
    
    //箭头隐藏
    if(_arrowImageView.hidden)
    {
        width += WMSettingCellControlInterval + WMSettingCellArrowWidth;
    }
    else
    {
        _arrowImageView.top = (self.contentView.height - _arrowImageView.height) / 2.0 + 1.0;
    }
    
    frame.size.width = width;
    frame.size.height = _contentHeight;
    _contentLabel.frame = frame;
}

@end


@implementation WMSettingHeadImageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        UIFont *font = WMSettingCellFont;
        CGFloat y = (WMSettingCellHeight - font.lineHeight) / 2.0;
        
        CGFloat height = WMSettingHeadImageCellHeight + y * 2 ;
        
        CGFloat margin = 10.0;
        CGFloat size = height - margin * 2;
        //头像
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(WMSettingCellMargin, margin, size, size)];
        _headImageView.layer.cornerRadius = size / 2.0;
        _headImageView.layer.masksToBounds = YES;
        _headImageView.sea_thumbnailSize = _headImageView.bounds.size;
        [self addSubview:_headImageView];
        
        //箭头
        UIImage *image = [UIImage imageNamed:@"arrow_gray"];
        _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_width_ - WMSettingCellMargin - WMSettingCellArrowWidth, (height - image.size.height) / 2.0 + 1.0, WMSettingCellArrowWidth, image.size.height)];
        _arrowImageView.contentMode = UIViewContentModeCenter;
        _arrowImageView.image = image;
        [self.contentView addSubview:_arrowImageView];
        
        //标题
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headImageView.right + margin, (height - font.lineHeight) / 2.0, _arrowImageView.left - _headImageView.right - margin - WMSettingCellControlInterval, font.lineHeight)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor grayColor];
        _titleLabel.textAlignment = NSTextAlignmentRight;
        _titleLabel.font = font;
        [self.contentView addSubview:_titleLabel];
    }
    
    return self;
}

@end


@implementation WMSettingSwitchCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIFont *font = WMSettingCellFont;
        CGFloat y = (WMSettingCellHeight- font.lineHeight) / 2.0;
        
        //标题
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(WMSettingCellMargin, y, WMSettingCellTitleWidth, font.lineHeight)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = font;
        [self.contentView addSubview:_titleLabel];
        

        //开关
        CGFloat width = 50.0;
        CGFloat height = 30.0;
        
        _switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(_width_ - WMSettingCellMargin - width, (WMSettingCellHeight - height) / 2.0, width, height)];
        [_switchButton addTarget:self action:@selector(switchDidChange:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:_switchButton];
    }
    
    return self;
}

- (void)switchDidChange:(id) sender
{
    if([self.delegate respondsToSelector:@selector(settingSwitchCellSwitchDidChange:)])
    {
        [self.delegate settingSwitchCellSwitchDidChange:self];
    }
}

@end

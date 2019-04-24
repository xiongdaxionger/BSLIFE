//
//  WMGoodCategoryCell.m
//  WuMei
//
//  Created by 罗海雄 on 15/7/18.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "WMGoodCategoryCell.h"
#import "WMCategoryInfo.h"

@implementation WMGoodCategoryFirstCell

/**创建给定宽度的cell
 */
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier width:(CGFloat) width
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor whiteColor];

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat interval = 10.0;
//        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(interval, margin, WMGoodCategoryFirstCellHeight - margin * 2, WMGoodCategoryFirstCellHeight - margin * 2)];
//       // _iconImageView.backgroundColor = _SeaImageBackgroundColorBeforeDownload_;
//        [self.contentView addSubview:_iconImageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconImageView.right + interval, 0, width - interval * 2, WMGoodCategoryFirstCellHeight)];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont fontWithName:MainFontName size:13.0];
        [self.contentView addSubview:_nameLabel];
        
        _line = [[UIView alloc] initWithFrame:CGRectMake(width - _separatorLineWidth_, 0, _separatorLineWidth_, WMGoodCategoryFirstCellHeight)];
        _line.backgroundColor = _separatorLineColor_;
        [self.contentView addSubview:_line];
    }
    
    return self;
}

- (void)setInfo:(WMCategoryInfo *)info
{
    if(_info != info)
    {
        _info = info;
        self.nameLabel.text = _info.categoryName;
    }
}

- (void)setSea_selected:(BOOL)sea_selected
{
    if(sea_selected != _sea_selected)
    {
        _sea_selected = sea_selected;
        if(sea_selected)
        {
            self.nameLabel.textColor = WMRedColor;
            self.contentView.backgroundColor = [UIColor clearColor];
        }
        else
        {
            self.nameLabel.textColor = [UIColor blackColor];
            self.contentView.backgroundColor = [UIColor whiteColor];
        }
        
        _line.hidden = sea_selected;
    }
}

@end



@implementation WMGoodSecondaryCategoryCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        CGFloat margin = 5.0;
        CGFloat margin1 = 10.0;
        CGFloat width = frame.size.width - margin1 * 2;
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(margin1, margin1, width, width)];
        _iconImageView.sea_originContentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_iconImageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin ,_iconImageView.bottom, frame.size.width - margin * 2, frame.size.height - width)];
        _nameLabel.textColor = MainTextColor;
        _nameLabel.font = [UIFont fontWithName:MainFontName size:13.0];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_nameLabel];

        self.contentView.backgroundColor = [UIColor whiteColor];
        
//        _line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _separatorLineWidth_, frame.size.height)];
//        _line.backgroundColor = _separatorLineColor_;
//        [self.contentView addSubview:_line];
    }
    
    return self;
}

- (void)setPosition:(int)position
{
    if(_position != position)
    {
        _position = position;
        _line.left = _position == 0 ? 0 : self.contentView.width - _line.width;
    }
}

- (void)setInfo:(WMCategoryInfo *)info
{
    _info = info;

    if(_info)
    {
        [self.iconImageView sea_setImageWithURL:info.imageURL];
        self.nameLabel.text = info.categoryName;
    }

    self.nameLabel.hidden = _info == nil;
    self.iconImageView.hidden = self.nameLabel.hidden;
}

/**item大小
 */
+ (CGSize)sea_itemSize
{
    CGFloat width = floor((_width_ - WMGoodCategoryFirstCellWidth - WMGoodSecondaryCategoryCellMargin * 2 - WMGoodSecondaryCategoryCellInterval * 4) / 3.0);
    
    return CGSizeMake(width, width + 30.0);
}


@end

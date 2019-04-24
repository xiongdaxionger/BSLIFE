//
//  WMMeFuncCell.m
//  StandardShop
//
//  Created by 罗海雄 on 16/8/31.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMMeFuncCell.h"
#import "WMMeListInfo.h"

@implementation WMMeFuncCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.contentView.backgroundColor = [UIColor whiteColor];

        UIFont *font = [UIFont fontWithName:MainFontName size:12.0];
        CGFloat margin = 5.0;
        _title_label = [[UILabel alloc] initWithFrame:CGRectMake(margin, 0, frame.size.width - margin * 2, font.lineHeight)];
        _title_label.textAlignment = NSTextAlignmentCenter;
        _title_label.font = font;
        [self.contentView addSubview:_title_label];
        
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - _separatorLineWidth_, frame.size.width, _separatorLineWidth_)];
        _line.backgroundColor = _separatorLineColor_;
        [self.contentView addSubview:_line];
    }
    
    return self;
}

- (void)setInfo:(WMMeListInfo *)info
{
    _info = info;
    self.title_label.text = info.title;
    self.title_label.hidden = info == nil;
}

- (void)setPosition:(WMMeFuncCellPosition)position
{
    _position = position;
    if(_position == WMMeFuncCellPositionBottom)
    {
        self.line.hidden = YES;
    }
    else
    {
        self.line.hidden = NO;
        CGRect frame = self.line.frame;
        CGFloat margin = [self margin];
        
        switch (_position)
        {
            case WMMeFuncCellPositionLeft:
            {
                frame.size.width = self.width - margin;
                frame.origin.x = margin;
            }
                break;
            case WMMeFuncCellPositionRight :
            {
                frame.origin.x = 0;
                frame.size.width = self.width - margin;
            }
                break;
            case WMMeFuncCellPositionMiddle :
            {
                frame.origin.x = 0;
                frame.size.width = self.width;
            }
                break;
            default:
                break;
        }
        
        self.line.frame = frame;
    }
}

///获取边距
- (CGFloat)margin
{
    return 15.0;
}

///通过位置获取position
+ (WMMeFuncCellPosition)positionFromIndex:(NSInteger) index itemCount:(NSInteger) itemCount
{
    NSInteger countPerRow = 4;
    NSInteger row = itemCount > 0 ? ((itemCount - 1) / countPerRow + 1) : 0;
    
    if (index / countPerRow >= row - 1)
    {
        return WMMeFuncCellPositionBottom;
    }
    else if(index % countPerRow == 0)
    {
        return WMMeFuncCellPositionLeft;
    }
    else if ((index + 1) % countPerRow == 0)
    {
        return WMMeFuncCellPositionRight;
    }
    
    return WMMeFuncCellPositionMiddle;
}

///按钮大小
+ (CGSize)sizeForIndex:(NSInteger) index
{
    CGFloat width = (int)((_width_ / 4.0) * 10) / 10.0;
    
    if((index + 1 ) % 4 == 0)
    {
        width = _width_ - width * 3;
    }
    
    return CGSizeMake(width, 93.0 * WMDesignScale);
}

@end

@implementation WMMeFuncIconCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        CGFloat size = 36.0 * WMDesignScale;
        CGFloat margin = 8.0;
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width - size) / 2.0, (frame.size.height - size - margin - self.title_label.height) / 2.0, size, size)];
        _imageView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:_imageView];
        self.title_label.top = _imageView.bottom + margin;
    }
    
    return self;
}

- (void)setInfo:(WMMeListInfo *)info
{
    [super setInfo:info];
    
    self.imageView.image = info.icon;
    self.imageView.hidden = info == nil;
}

@end


@implementation WMMeFuncTextCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        CGRect tframe = self.title_label.frame;
        UIFont *font = [UIFont fontWithName:MainNumberFontName size:18.0];
        CGFloat margin = 8.0;
        CGFloat size = 36.0 * WMDesignScale;
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(tframe.origin.x, (frame.size.height - self.title_label.height - margin - size) / 2.0, tframe.size.width, size)];
        _textLabel.font = font;
        _textLabel.textColor = WMRedColor;
        _textLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_textLabel];
        
        self.title_label.top = _textLabel.bottom + margin;
    }
    
    return self;
}

- (void)setInfo:(WMMeListInfo *)info
{
    [super setInfo:info];
    
    self.textLabel.text = info.subtitle;
    self.textLabel.hidden = info == nil;
}

@end

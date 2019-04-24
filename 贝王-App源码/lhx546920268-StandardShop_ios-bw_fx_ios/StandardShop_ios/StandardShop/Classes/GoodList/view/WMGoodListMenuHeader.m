//
//  WMGoodListMenuHeader.m
//  StandardShop
//
//  Created by 罗海雄 on 16/8/3.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodListMenuHeader.h"
#import "SeaDropDownMenu.h"

@implementation WMGoodListMenuHeader


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width_, _separatorLineWidth_)];
        _line.backgroundColor = _separatorLineColor_;
        [self addSubview:_line];
        
        self.backgroundColor = [UIColor clearColor];
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _menuBar.bottom, self.width, WMGoodListMenuHeaderNoGoodHeight)];
        _textLabel.hidden = YES;
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.textColor = [UIColor grayColor];
        _textLabel.font = [UIFont fontWithName:MainFontName size:17.0];
        [self addSubview:_textLabel];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    if(!_textLabel.hidden)
    {
        frame.size.height -= _textLabel.height;
    }
    
    _menuBar.frame = frame;
    _textLabel.top = _menuBar.bottom;
}

- (void)setMenuBar:(SeaDropDownMenu *)menuBar
{
    _menuBar = menuBar;
    if(_menuBar.superview != self)
    {
        [_menuBar removeFromSuperview];
        [self insertSubview:_menuBar belowSubview:_line];
    }
}


@end

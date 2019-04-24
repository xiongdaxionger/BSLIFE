//
//  WMGoodMarkView.m
//  StandardShop
//
//  Created by 罗海雄 on 16/6/3.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodMarkView.h"
#import "WMGoodMarkInfo.h"

///默认属性
#define WMGoodMarkInterval 5.0 ///图片间隔

///图片起始tag
#define WMGoodMarkViewStartTag 1000

@implementation WMGoodMarkCell

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.textColor = [UIColor whiteColor];
        self.backgroundColor = WMRedColor;
        self.textAlignment = NSTextAlignmentCenter;
        self.layer.cornerRadius = 3.0;
        self.layer.masksToBounds = YES;
        self.font = [UIFont fontWithName:MainFontName size:10.0];
    }

    return self;
}

@end

@implementation WMGoodMarkView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self initialization];
    }

    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self initialization];
    }

    return self;
}



///初始化
- (void)initialization
{
    self.maxWidth = CGFLOAT_MAX;
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = YES;
}

- (void)setMarks:(NSArray *)marks
{
    if(_marks != marks)
    {
        _marks = marks;
        [self reloadData];
    }
}

- (void)setMaxWidth:(CGFloat)maxWidth
{
    if(_maxWidth != maxWidth)
    {
        _maxWidth = MAX(0, maxWidth);
    }
}

///刷新数据
- (void)reloadData
{
    CGFloat width = 0;

    NSInteger index = 0;
    CGFloat size = self.height;
    if(self.constraints.count > 0)
    {
        size = self.sea_heightLayoutConstraint.constant;
    }

    UIFont *font = [UIFont fontWithName:MainFontName size:10.0];
    for(NSInteger i = 0;i < self.marks.count;i ++)
    {
        WMGoodMarkInfo *info = [self.marks objectAtIndex:index];
        if(CGSizeEqualToSize(info.size, CGSizeZero))
        {
            info.size = [info.text stringSizeWithFont:font contraintWith:_width_];
            info.size = CGSizeMake(MAX(info.size.width + 5.0, size), size);
        }

        ///判断有没有超出最大宽度限制
        if(width + info.size.width + WMGoodMarkInterval <= self.maxWidth)
        {
            [self configCellForIndex:i];
            width += info.size.width + WMGoodMarkInterval;
            index ++;
        }
        else
        {
            break;
        }
    }

    ///移除无用的视图
    NSInteger i = index;
    while ([self cellForIndex:i])
    {
        [self removeCellAtIndex:i];
        i ++;
    }

    if(self.constraints.count > 0)
    {
        self.sea_widthLayoutConstraint.constant = width;
    }
}

///获取cell
- (WMGoodMarkCell*)cellForIndex:(NSInteger) index
{
    return (WMGoodMarkCell*)[self viewWithTag:WMGoodMarkViewStartTag + index];
}

#pragma mark- private method

///配置cell
- (void)configCellForIndex:(NSInteger) index
{
    WMGoodMarkInfo *info = [self.marks objectAtIndex:index];
    WMGoodMarkCell *cell = [self cellForIndex:index];
    if(!cell)
    {
        
        if(self.reusedCells.count > 0)
        {
            cell = [self.reusedCells anyObject];
            [self.reusedCells removeObject:cell];
        }
        else
        {
            cell = [[WMGoodMarkCell alloc] initWithFrame:CGRectZero];
        }
        [self addSubview:cell];

        [self.visibleCells addObject:cell];
    }

    WMGoodMarkCell *cell1 = [self cellForIndex:index - 1];
    cell.frame = CGRectMake(cell1.right + (cell1 != nil ? WMGoodMarkInterval : 0), 0, info.size.width, info.size.height);
    cell.text = info.text;
    cell.tag = WMGoodMarkViewStartTag + index;
}

///移除cell
- (void)removeCellAtIndex:(NSInteger) index
{
    WMGoodMarkCell *cell = [self cellForIndex:index];
    if(cell)
    {
        [self.reusedCells addObject:cell];
        [self.visibleCells removeObject:cell];
        [cell removeFromSuperview];
    }
}

@end

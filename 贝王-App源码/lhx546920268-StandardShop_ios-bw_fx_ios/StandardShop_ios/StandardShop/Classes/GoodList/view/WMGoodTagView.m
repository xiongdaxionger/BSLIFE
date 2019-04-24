//
//  WMGoodTagView.m
//  StandardShop
//
//  Created by 罗海雄 on 16/6/3.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodTagView.h"
#import "WMGoodTagInfo.h"

///默认属性
#define WMGoodTagInterval 5.0 ///图片间隔

///图片起始tag
#define WMGoodTagViewStartTag 1000

@implementation WMGoodTagCell

- (void)setPosition:(WMGoodTagPosition)position
{
    _position = position;
    switch (_position)
    {
        case WMGoodTagPositionLeftTop :
        {
            self.center = CGPointMake(self.width / 2.0, self.height / 2.0);
        }
            break;
        case WMGoodTagPositionRightTop :
        {
            self.center = CGPointMake(self.superview.width - self.width / 2.0, self.height / 2.0);
        }
            break;
        case WMGoodTagPositionLeftBottom :
        {
            self.center = CGPointMake(self.width / 2.0, self.superview.height - self.height / 2.0);
        }
            break;
        case WMGoodTagPositionRightBottom :
        {
            self.center = CGPointMake(self.superview.width - self.width / 2.0, self.superview.height - self.height / 2.0);
        }
            break;
    }
}

@end

@implementation WMGoodTagTextCell

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 0, frame.size.width - 10.0, 25.0)];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.numberOfLines = 0;
        _textLabel.font = [UIFont fontWithName:MainFontName size:8.0];
        [self addSubview:_textLabel];
    }

    return self;
}

- (void)setPosition:(WMGoodTagPosition)position
{
    [super setPosition:position];
    switch (self.position)
    {
        case WMGoodTagPositionLeftBottom :
        {
            self.frame = CGRectMake(0, self.superview.height - self.textLabel.height, self.width, self.height);
        }
            break;
        case WMGoodTagPositionRightBottom :
        {
            self.frame = CGRectMake(self.superview.width - self.width, self.superview.height - self.textLabel.height, self.width, self.height);
        }
            break;
            default:
            break;
    }
}

- (void)setFillColor:(UIColor *)fillColor
{
    _fillColor = fillColor;
    [self setNeedsDisplay];

    switch (self.position)
    {
        case WMGoodTagPositionLeftBottom :
        case WMGoodTagPositionRightBottom :
        {
            self.backgroundColor = self.fillColor;
        }
            break;
        default:
        {
            self.backgroundColor = [UIColor clearColor];
        }
            break;
    }
}

- (void)drawRect:(CGRect)rect
{
    switch (self.position)
    {
        case WMGoodTagPositionRightTop :
        case WMGoodTagPositionLeftTop  :
        {
            self.backgroundColor = [UIColor clearColor];
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSetFillColorWithColor(context, self.fillColor.CGColor);

            CGContextMoveToPoint(context, 0, 0);
            CGContextAddLineToPoint(context, 0, self.height);
            CGContextAddLineToPoint(context, self.width / 2.0, self.textLabel.bottom);
            CGContextAddLineToPoint(context, self.width, self.height);
            CGContextAddLineToPoint(context, self.width, 0);
            CGContextAddLineToPoint(context, 0, 0);

            CGContextFillPath(context);
        }
            break;

        default:
            break;
    }
}

- (void)setInfo:(WMGoodTagInfo *)info
{
    [super setInfo:info];

    self.position = info.position;
    self.fillColor = info.backgroundColor;
    self.textLabel.textColor = info.textColor;
    self.textLabel.text = info.text;
}

@end

@implementation WMGoodTagImageCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_imageView];
    }

    return self;
}

- (void)setInfo:(WMGoodTagInfo *)info
{
    [super setInfo:info];
    
    self.position = info.position;
    [_imageView sea_setImageWithURL:info.imageURL];
}

@end

@implementation WMGoodTagView

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
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = YES;
}

- (void)setTags:(NSArray *)tags
{
    if(_tags != tags)
    {
        _tags = tags;
        [self reloadData];
    }
}

///刷新数据
- (void)reloadData
{
    for(NSInteger i = 0;i < self.tags.count;i ++)
    {
        [self configCellForIndex:i];
    }

    ///移除无用的视图
    NSInteger i = self.tags.count;
    while ([self cellForIndex:i])
    {
        [self removeCellAtIndex:i];
        i ++;
    }
}

///获取cell
- (WMGoodTagCell*)cellForIndex:(NSInteger) index
{
    return (WMGoodTagCell*)[self viewWithTag:WMGoodTagViewStartTag + index];
}

#pragma mark- private method

///配置cell
- (void)configCellForIndex:(NSInteger) index
{
    WMGoodTagInfo *info = [self.tags objectAtIndex:index];
    WMGoodTagCell *cell = [self cellForIndex:index];

    Class class = info.type == WMGoodTagTypeText ? [WMGoodTagTextCell class] : [WMGoodTagImageCell class];

    if(![cell isKindOfClass:class])
    {
        ///cell跑回重用列表
        NSString *identifier = NSStringFromClass(class);
        if(cell)
        {
            [self removeCellAtIndex:index];
        }

        NSMutableSet *reusedSet = [self.reusedCells objectForKey:identifier];
        if(!reusedSet)
        {
            reusedSet = [NSMutableSet set];
            [self.reusedCells setObject:reusedSet forKey:identifier];
        }

        if(reusedSet.count > 0)
        {
            cell = [reusedSet anyObject];
            [reusedSet removeObject:cell];
        }
        else
        {
            if(info.type == WMGoodTagTypeText)
            {
                cell = [[class alloc] initWithFrame:CGRectMake(0, 0, 30, 35)];
            }
            else
            {
                cell = [[class alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
            }
        }

        [self addSubview:cell];

        NSMutableSet *visibleSet = [self.visibleCells objectForKey:identifier];
        if(!visibleSet)
        {
            visibleSet = [NSMutableSet set];
            [self.visibleCells setObject:visibleSet forKey:identifier];
        }

        [visibleSet addObject:cell];
    }

    cell.frame = CGRectMake(0, 0, cell.width, cell.height);
    cell.tag = WMGoodTagViewStartTag + index;
    cell.info = info;
}

///移除cell
- (void)removeCellAtIndex:(NSInteger) index
{
    WMGoodTagCell *cell = [self cellForIndex:index];
    if(cell)
    {
        NSString *identifier = NSStringFromClass([cell class]);
        NSMutableSet *set = [self.reusedCells objectForKey:identifier];
        [set addObject:cell];
        [cell removeFromSuperview];
    }
}

@end

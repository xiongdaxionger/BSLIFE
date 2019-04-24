//
//  WMGoodCommentScoreView.m
//  StandardShop
//
//  Created by 罗海雄 on 16/6/2.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodCommentScoreView.h"

///星星tag
#define WMGoodCommentScoreViewStarTag 1000

@implementation WMGoodCommentScoreView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self initialization];
    }

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self initialization];
    }

    return self;
}

///初始化
- (void)initialization
{
    self.userInteractionEnabled = NO;
    CGFloat width = self.width / WMGoodCommentScoreMax;
    for(int i = 0;i < WMGoodCommentScoreMax;i ++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * width, 0, width, self.height)];
        imageView.contentMode = UIViewContentModeCenter;
        imageView.tag = WMGoodCommentScoreViewStarTag + i;
        imageView.image = [UIImage imageNamed:@"star_empty"];
        imageView.highlightedImage = [UIImage imageNamed:@"star_fill"];
        
        [self addSubview:imageView];
    }
}

- (void)setScore:(NSInteger)score
{
//    if(_score != score)
//    {
        _score = score;
        for(int i = 0;i < _score;i ++)
        {
            UIImageView *imageView = [self starForIndex:i];
            imageView.highlighted = YES;
        }

        for(int i = _score;i < WMGoodCommentScoreMax;i ++)
        {
            UIImageView *imageView = [self starForIndex:i];
            imageView.highlighted = NO;
        }
//    }
}

- (void)setEditable:(BOOL)editable
{
    if(_editable != editable)
    {
        _editable = editable;
        self.userInteractionEnabled = _editable;
        
        for(int i = 0;i < WMGoodCommentScoreMax;i ++)
        {
            UIImageView *imageView = [self starForIndex:i];
            if(imageView.gestureRecognizers.count == 0)
            {
                [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)]];
                imageView.userInteractionEnabled = YES;
            }
        }
    }
}

///获取星星
- (UIImageView*)starForIndex:(NSInteger) index
{
    return (UIImageView*)[self viewWithTag:WMGoodCommentScoreViewStarTag + index];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self setScoreWithTouchs:touches];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self setScoreWithTouchs:touches];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self setScoreWithTouchs:touches];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self setScoreWithTouchs:touches];
}

///点击
- (void)handleTap:(UITapGestureRecognizer*) tap
{
    UIImageView *imageView = (UIImageView*)tap.view;
    NSInteger index = imageView.tag - WMGoodCommentScoreViewStarTag;
    
    if(imageView.highlighted)
    {
        self.score = index;
    }
    else
    {
        self.score = index + 1;
    }
}

///设置评分
- (void)setScoreWithTouchs:(NSSet*) touches
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];

    NSInteger index = point.x / (self.width / WMGoodCommentScoreMax);
    self.score = index + 1;
}

@end

//
//  WMGoodCommentScoreProgressView.m
//  StandardShop
//
//  Created by 罗海雄 on 16/6/28.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodCommentScoreProgressView.h"

///星星tag
#define WMGoodCommentScoreViewStarTag 1000

///最大评分
#define WMGoodCommentScoreMax 5

@interface WMGoodCommentScoreProgressCell ()

///空心 星星
@property(nonatomic,readonly) UIImageView *hollowImageView;

///实心 星星
@property(nonatomic,readonly) UIImageView *solidImageView;

@end

@implementation WMGoodCommentScoreProgressCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _hollowImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _hollowImageView.image = [UIImage imageNamed:@"star_empty"];
        _hollowImageView.contentMode = UIViewContentModeLeft;
        [self addSubview:_hollowImageView];

        _solidImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _solidImageView.image = [UIImage imageNamed:@"star_fill"];
        _solidImageView.contentMode = UIViewContentModeLeft;
        _solidImageView.clipsToBounds = YES;
        [self addSubview:_solidImageView];

        _progress = 2.0;
    }

    return self;
}

- (void)setProgress:(float)progress
{
    if(_progress != progress)
    {
        _progress = progress;
        _solidImageView.width = _progress * _hollowImageView.width;
    }
}

@end

@implementation WMGoodCommentScoreProgressView

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
        WMGoodCommentScoreProgressCell *imageView = [[WMGoodCommentScoreProgressCell alloc] initWithFrame:CGRectMake(i * width, 0, width, self.height)];
        imageView.tag = WMGoodCommentScoreViewStarTag + i;
        [self addSubview:imageView];
    }
}

- (void)setScore:(float)score
{
//    if(_score != score)
//    {
        _score = score;

        for(int i = 0;i < WMGoodCommentScoreMax;i ++)
        {
            WMGoodCommentScoreProgressCell *cell = [self starForIndex:i];
            if(i + 1 < _score)
            {
                cell.progress = 1.0;
            }
            else
            {
                float progress = _score - i;
                if(progress < 0)
                    progress = 0;
                cell.progress = progress;
            }
        }
    //}
}

///获取星星
- (WMGoodCommentScoreProgressCell*)starForIndex:(NSInteger) index
{
    return (WMGoodCommentScoreProgressCell*)[self viewWithTag:WMGoodCommentScoreViewStarTag + index];
}


@end

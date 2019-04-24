//
//  WMMeTagAdView.m
//  StandardShop
//
//  Created by 罗海雄 on 16/6/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMMeTagAdView.h"
#import "WMHomeAdInfo.h"

@implementation WMMeTagAdCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.insets = UIEdgeInsetsMake(0, 5, 0, 5);
        self.layer.cornerRadius = frame.size.height / 2.0;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor colorFromHexadecimal:@"FF8F8F"];
        self.textAlignment = NSTextAlignmentCenter;
        self.numberOfLines = 2;
        self.textColor = [UIColor whiteColor];
        self.font = [UIFont fontWithName:MainFontName size:13.0];
    }

    return self;
}

@end

///起始tag
#define WMMeTagAdViewStartTag 1200

@interface WMMeTagAdView ()

@end

@implementation WMMeTagAdView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        self.height = MAX(235.0, _width_ * 712.0 / 1242.0) - 45.0;
        self.backgroundColor = [UIColor clearColor];

//        WMHomeAdInfo *info = [[WMHomeAdInfo alloc] init];
//        info.text = @"爱生活";
//
//        NSMutableArray *infos = [NSMutableArray arrayWithCapacity:4];
//        [infos addObject:info];
//
//        info = [[WMHomeAdInfo alloc] init];
//        info.text = @"爱网购";
//        [infos addObject:info];
//
//        info = [[WMHomeAdInfo alloc] init];
//        info.text = @"出来咋到";
//        [infos addObject:info];
//
//        info = [[WMHomeAdInfo alloc] init];
//        info.text = @"爱运动";
//        [infos addObject:info];
//
//        self.tags = infos;
    }

    return self;
}

- (void)setTags:(NSArray *)tags
{
    if(_tags != tags)
    {
        _tags = tags;

        int count = 4;
        if(self.tags.count > 0)
        {
            for(NSInteger i = 0;i < MIN(_tags.count, count);i ++)
            {
                WMHomeAdInfo *info = [self.tags objectAtIndex:i];
                WMMeTagAdCell *cell = [self cellForIndex:i];
                cell.hidden = NO;
                cell.text = info.text;
            }
        }

        ///隐藏没有标签的cell
        for(NSInteger i = self.tags.count;i < count;i ++)
        {
            [self cellForIndex:i].hidden = YES;
        }

        [self show];
    }
}

///显示标签
- (void)show
{
    CGPoint point = CGPointMake(_width_ / 2.0, self.height / 2.0);
    for(NSInteger i = 0;i < self.tags.count; i ++)
    {
        WMMeTagAdCell *cell = [self cellForIndex:i];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
        animation.fromValue = [NSValue valueWithCGPoint:point];
        animation.toValue = [NSValue valueWithCGPoint:cell.center];
        animation.duration = 0.25;
        animation.removedOnCompletion = YES;
        [cell.layer addAnimation:animation forKey:nil];
    }
}

///获取cell
- (WMMeTagAdCell*)cellForIndex:(NSInteger) index
{
    WMMeTagAdCell *cell = (WMMeTagAdCell*)[self viewWithTag:index + WMMeTagAdViewStartTag];

    if(!cell)
    {
        CGFloat x = 0;
        CGFloat y = 0;
        CGFloat width = 45.0;
        CGFloat height = 45.0;
        CGFloat headImageSize = 75.0;
        CGFloat margin1 = 20.0;
        CGFloat margin2 = 50.0;

        switch (index)
        {
            case 0 :
            {
                x = (_width_ - headImageSize) / 2.0 - width - margin1;
                y = (self.height - headImageSize) / 2.0 - height / 2.0;
            }
                break;
            case 1 :
            {
                x = (_width_ - headImageSize) / 2.0 + headImageSize + margin1;
                y = (self.height - headImageSize) / 2.0 - height / 2.0;
            }
                break;
            case 2 :
            {
                x = (_width_ - headImageSize) / 2.0 - width - margin2;
                y = (self.height - headImageSize) / 2.0 + headImageSize - height / 2.0;
            }
                break;
            case 3 :
            {
                x = (_width_ - headImageSize) / 2.0 + headImageSize + margin2;
                y = (self.height - headImageSize) / 2.0 + headImageSize - height / 2.0;
            }
                break;
            default:
                break;
        }

        cell = [[WMMeTagAdCell alloc] initWithFrame:CGRectMake(x, y, width, height)];
        
        cell.userInteractionEnabled = YES;

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellDidTap:)];
        [cell addGestureRecognizer:tap];

        cell.tag = index + WMMeTagAdViewStartTag;
        [self addSubview:cell];
    }

    return cell;
}

- (void)cellDidTap:(UITapGestureRecognizer*) tap
{
    WMHomeAdInfo *info = [self.tags objectAtIndex:tap.view.tag - WMMeTagAdViewStartTag];
    UIViewController *vc = [info viewController];
    if(vc)
    {
        [SeaPresentTransitionDelegate pushViewController:vc useNavigationBar:YES parentedViewConttroller:self.navigationController];
    }
}

@end

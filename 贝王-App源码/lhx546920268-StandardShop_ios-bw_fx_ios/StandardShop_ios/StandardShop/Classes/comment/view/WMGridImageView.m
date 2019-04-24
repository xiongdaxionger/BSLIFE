//
//  WMGridImageView.m
//  StandardShop
//
//  Created by 罗海雄 on 16/6/2.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGridImageView.h"

///默认属性
#define WMGridImageViewInterval 5.0 ///图片间隔
#define WMGridImageViewMaxCountPerRow 3 ///每行最大图片数量

///图片起始tag
#define WMGridImageViewStartTag 1000

@interface WMGridImageView ()


@end

@implementation WMGridImageView

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

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

///初始化
- (void)initialization
{
    self.backgroundColor = [UIColor clearColor];
    self.interval = WMGridImageViewInterval;
    self.maxCountPerRow = WMGridImageViewMaxCountPerRow;
    self.imageSize = 75.0;
    self.showWithOriginalScaleWhenOnlyOneImage = NO;
    self.maxImageSizeWhenOnlyOneImage = CGSizeMake(self.imageSize * self.maxCountPerRow + (self.maxCountPerRow - 1) * self.interval, self.imageSize * self.maxCountPerRow + (self.maxCountPerRow - 1) * self.interval);


}

- (void)setImages:(NSArray *)images
{
    if(_images != images)
    {
        _images = images;
        [self reloadData];
    }
}

///刷新数据
- (void)reloadData
{
    for(NSInteger i = 0;i < self.images.count;i ++)
    {
        [self configCellForIndex:i];
    }

    ///移除无用的视图
    NSInteger i = self.images.count;
    while ([self cellForIndex:i])
    {
        [self removeCellAtIndex:i];
        i ++;
    }
}

///获取cell
- (UIImageView*)cellForIndex:(NSInteger) index
{
    return (UIImageView*)[self viewWithTag:WMGridImageViewStartTag + index];
}

#pragma mark- private method

///配置cell
- (void)configCellForIndex:(NSInteger) index
{
    NSString *url = [self.images objectAtIndex:index];
    UIImageView *cell = [self cellForIndex:index];
    if(!cell)
    {
        
        if(self.reusedCells.count > 0)
        {
            cell = [self.reusedCells anyObject];
            [self.reusedCells removeObject:cell];
        }
        else
        {
            cell = [[UIImageView alloc] init];
            cell.userInteractionEnabled = YES;
        }
        
        ///移除以前的手势，防止重用时报错
        if(cell.gestureRecognizers.count > 0)
        {
            [cell removeGestureRecognizer:[cell.gestureRecognizers firstObject]];
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellDidSelect:)];
        [cell addGestureRecognizer:tap];
        
        [self addSubview:cell];

        [self.visibleCells addObject:cell];
    }

    cell.tag = WMGridImageViewStartTag + index;
    if(index == 0 && self.images.count == 1 && self.showWithOriginalScaleWhenOnlyOneImage)
    {
        WeakSelf(self);
        cell.frame = CGRectMake(0, 0, self.maxImageSizeWhenOnlyOneImage.width, self.maxImageSizeWhenOnlyOneImage.height);
        cell.sea_thumbnailSize = cell.bounds.size;

        [cell sea_setImageWithURL:url completion:^(UIImage *image, BOOL fromNetwork){

            CGSize size = [image shrinkWithSize:weakSelf.maxImageSizeWhenOnlyOneImage type:SeaImageShrinkTypeWidthAndHeight];
            cell.frame = CGRectMake(0, 0, size.width, size.height);
            if([weakSelf.delegate respondsToSelector:@selector(gridImageViewDidLayoutAgain:)])
            {
                [weakSelf.delegate gridImageViewDidLayoutAgain:weakSelf];
            }
        }];
    }
    else
    {
        int row = index / self.maxCountPerRow;
        int column = index % self.maxCountPerRow;

        cell.frame = CGRectMake(column * (self.imageSize + self.interval), row * (self.imageSize + self.interval), self.imageSize, self.imageSize);
        cell.sea_thumbnailSize = cell.bounds.size;
        [cell sea_setImageWithURL:url];
    }
    
}

///移除cell
- (void)removeCellAtIndex:(NSInteger) index
{
    UIImageView *cell = [self cellForIndex:index];
    if(cell)
    {
        [cell sea_setImageWithURL:nil];
        [cell removeFromSuperview];
        [self.reusedCells addObject:cell];
        [self.visibleCells removeObject:cell];
    }
}

///点击某个cell
- (void)cellDidSelect:(UITapGestureRecognizer*) tap
{
    if([self.delegate respondsToSelector:@selector(gridImageView:didSelectAtIndex:)])
    {
        [self.delegate gridImageView:self didSelectAtIndex:tap.view.tag - WMGridImageViewStartTag];
    }
}

#pragma mark- Class method

/**通过图片数量获取视图高度 使用默认的图片间隔和每行图片数量
 */
+ (CGFloat)heightForImageCount:(NSInteger) count imageSize:(CGFloat) imageSize
{
    return [WMGridImageView heightForImageCount:count imageSize:imageSize interval:WMGridImageViewInterval countPerRow:WMGridImageViewMaxCountPerRow showWithOriginalScaleWhenOnlyOneImage:NO];
}

/**通过图片数量、图片间隔和每行图片数量获取视图高度
 */
+ (CGFloat)heightForImageCount:(NSInteger) count imageSize:(CGFloat) imageSize interval:(CGFloat) interval countPerRow:(int) countPerRow showWithOriginalScaleWhenOnlyOneImage:(BOOL)flag
{
    if(count == 0)
        return 0;
    else if (count == 1 && flag)
    {
        return imageSize * countPerRow;
    }
    else
    {
        int row = (count - 1) / countPerRow + 1;
        return row * imageSize + (row - 1) * interval;
    }
}

@end

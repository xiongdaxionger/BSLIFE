//
//  WMPartnerLevelView.m
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/2.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMPartnerLevelView.h"
#import "WMPartnerInfo.h"

///星星tag
#define WMPartnerLevelViewStarTag 1000

///最大等级
#define WMPartnerMaxLevel 5

@interface WMPartnerLevelView ()

/**等级名称
 */
@property(nonatomic,strong) UILabel *nameLabel;

@end

@implementation WMPartnerLevelView

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
    CGFloat width = 15.0;
    for(int i = 0;i < WMPartnerMaxLevel;i ++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * width, 0, width, self.height)];
        imageView.contentMode = UIViewContentModeLeft;
        imageView.tag = WMPartnerLevelViewStarTag + i;
        imageView.image = [UIImage imageNamed:@"partner_level_icon"];
        [self addSubview:imageView];
    }
    
    CGFloat x = [self viewWithTag:WMPartnerMaxLevel - 1 + WMPartnerLevelViewStarTag].right;
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, self.width - x, self.height)];
    self.nameLabel.textColor = [UIColor grayColor];
    self.nameLabel.font = [UIFont fontWithName:MainFontName size:12.0];
    self.nameLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:self.nameLabel];
}

- (void)setInfo:(WMPartnerInfo *)info
{
    if(_info != info)
    {
        _info = info;
        int level = [_info.userInfo.levelNumber intValue];
        for(int i = 0;i < level;i ++)
        {
            UIImageView *imageView = [self levelStarForIndex:i];
            imageView.hidden = NO;
        }
        
        for(int i = level;i < WMPartnerMaxLevel;i ++)
        {
            UIImageView *imageView = [self levelStarForIndex:i];
            imageView.hidden = YES;
        }
        
        self.nameLabel.left = [self levelStarForIndex:level - 1].right;
        self.nameLabel.text = info.userInfo.level;
    }
}

///获取等级星星
- (UIImageView*)levelStarForIndex:(NSInteger) index
{
   return (UIImageView*)[self viewWithTag:WMPartnerLevelViewStarTag + index];
}

@end

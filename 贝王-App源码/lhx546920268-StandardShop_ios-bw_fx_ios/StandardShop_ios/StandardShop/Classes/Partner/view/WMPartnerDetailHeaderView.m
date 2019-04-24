//
//  WMPartnerDetailHeaderView.m
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/3.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMPartnerDetailHeaderView.h"
#import "WMPartnerInfo.h"

@implementation WMPartnerDetailHeaderView

/**构造方法
 *@param info 客户信息
 *@return 一个已经设置好大小的实例
 */
- (instancetype)initWithPartnerInfo:(WMPartnerInfo*) info
{
    UIImage *bgImage = [UIImage imageNamed:@"partner_detail_bg"];
    self = [super initWithFrame:CGRectMake(0, 0, _width_, bgImage.size.height)];
    if(self)
    {
        ///背景
        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        bgImageView.contentMode = UIViewContentModeCenter;
        bgImageView.image = bgImage;
        bgImageView.clipsToBounds = YES;
        [self addSubview:bgImageView];
        
        ///头像
        CGFloat size = 70.0;
        CGFloat interval = 5.0;
        UIFont *font = [UIFont fontWithName:MainFontName size:17.0];
        
        UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - size) / 2.0, (self.height - size - interval - font.lineHeight) / 2.0, size, size)];
        headImageView.layer.cornerRadius = size / 2.0;
        headImageView.layer.masksToBounds = YES;
        headImageView.sea_placeHolderImage = [UIImage imageNamed:@"default_head_image"];
        headImageView.sea_thumbnailSize = CGSizeMake(size, size);
        [headImageView sea_setImageWithURL:info.userInfo.headImageURL];
        [self addSubview:headImageView];
        
        ///昵称
        CGFloat margin = 10.0;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(margin, headImageView.bottom + interval, self.width - margin * 2, font.lineHeight)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = font;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = info.userInfo.displayName;
        [self addSubview:label];
    }
    
    return self;
}

@end

//
//  WMGoodCategorySectionHeader.m
//  StandardShop
//
//  Created by 罗海雄 on 16/6/27.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodCategorySectionHeader.h"
#import "WMCategoryInfo.h"

@implementation WMGoodCategorySectionHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        _title_label = [[UILabel alloc] initWithFrame:self.bounds];
        _title_label.font = [UIFont boldSystemFontOfSize:13.0];
        _title_label.textColor = [UIColor colorWithWhite:0.3 alpha:1.0];
        [self addSubview:_title_label];
        
//        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - _separatorLineWidth_, self.width, _separatorLineWidth_)];
//        line.backgroundColor = _separatorLineColor_;
//        [self addSubview:line];
    }
    
    return self;
}

@end

@implementation WMGoodCategorySectionImageHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        _title_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, WMGoodCategorySectionHeaderHeight)];
        _title_label.font = [UIFont boldSystemFontOfSize:13.0];
        _title_label.textColor = [UIColor blackColor];
        [self addSubview:_title_label];
        
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _title_label.bottom, self.width, self.height - _title_label.height)];
        _imageView.backgroundColor = [UIColor whiteColor];
        _imageView.userInteractionEnabled = YES;
        _imageView.sea_originContentMode = UIViewContentModeScaleAspectFit;
//        _imageView.layer.borderWidth = _separatorLineWidth_;
//        _imageView.layer.borderColor = _separatorLineColor_.CGColor;
        [self addSubview:_imageView];
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self.imageView addGestureRecognizer:tap];
    }
    
    return self;
}

///点击图片
- (void)handleTap:(UITapGestureRecognizer*) tap
{
    if([self.delegate respondsToSelector:@selector(goodCategorySectionImageHeaderDidTapImage:)])
    {
        [self.delegate goodCategorySectionImageHeaderDidTapImage:self];
    }
}

- (void)setInfo:(WMCategoryInfo *)info
{
    if(_info != info)
    {
        _info = info;
        self.title_label.text = info.categoryName;
        [self.imageView sea_setImageWithURL:info.imageURL];
    }
}

///通过collectionView宽度获取header大小
+ (CGSize)sizeForWidth:(CGFloat) width
{
    return CGSizeMake(width, width / 2.0 + WMGoodCategorySectionHeaderHeight);
}

@end

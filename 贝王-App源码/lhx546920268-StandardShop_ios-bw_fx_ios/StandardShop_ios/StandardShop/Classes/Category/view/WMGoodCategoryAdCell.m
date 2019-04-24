//
//  WMGoodCategoryAdCell.m
//  StandardShop
//
//  Created by 罗海雄 on 16/6/27.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodCategoryAdCell.h"

@implementation WMGoodCategoryAdCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.contentView.backgroundColor = [UIColor whiteColor];

        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:_imageView];
    }

    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = self.contentView.bounds;
}

@end

//
//  WMBrandSquareCell.m
//  WanShoes
//
//  Created by 罗海雄 on 16/3/31.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "WMBrandSquareCell.h"

@implementation WMBrandSquareCell

- (void)awakeFromNib {
    // Initialization code
    
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.imageView.sea_originContentMode = UIViewContentModeScaleAspectFit;
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    self.contentView.layer.cornerRadius = 8.0;
//    self.contentView.layer.masksToBounds = YES;
//}

@end

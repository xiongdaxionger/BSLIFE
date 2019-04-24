//
//  WMMeBindPhoneCell.m
//  StandardShop
//
//  Created by 罗海雄 on 16/9/1.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMMeBindPhoneCell.h"

@implementation WMMeBindPhoneCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        CGFloat margin = 10.0;
        UIImage *image = [UIImage imageNamed:@"arrow_gray"];
        
        _arrow = [[UIImageView alloc] initWithImage:image];
        _arrow.frame = CGRectMake(_width_ - margin - image.size.width, (frame.size.height - image.size.height) / 2.0, image.size.width, image.size.height);
        [self.contentView addSubview:_arrow];
        
        margin = 15.0;
        _title_label = [[UILabel alloc] initWithFrame:CGRectMake(margin, 0, _arrow.left - margin, frame.size.height)];
        _title_label.font = [UIFont fontWithName:MainFontName size:14.0];
        _title_label.textColor = MainGrayColor;
        [self.contentView addSubview:_title_label];
    }
    
    return self;
}

@end

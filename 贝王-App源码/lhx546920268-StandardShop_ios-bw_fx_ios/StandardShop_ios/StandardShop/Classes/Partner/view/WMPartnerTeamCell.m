//
//  WMPartnerTeamCell.m
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/3.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMPartnerTeamCell.h"
#import "WMPartnerInfo.h"

@implementation WMPartnerTeamCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    CGFloat width = (WMPartnerTeamCellHeight - 1.0 - WMPartnerTeamCellMargin * 2);
    self.head_imageView.layer.cornerRadius =  width / 2.0;
    self.head_imageView.layer.masksToBounds = YES;
    self.head_imageView.sea_placeHolderImage = [UIImage imageNamed:@"default_head_image"];
    self.head_imageView.sea_thumbnailSize = CGSizeMake(width, width);
    self.name_label.font = [UIFont fontWithName:MainFontName size:17.0];
    self.earn_label.font = [UIFont fontWithName:MainFontName size:14.0];
    self.order_count_label.font = [UIFont fontWithName:MainFontName size:14.0];
}

- (void)setInfo:(WMPartnerInfo *)info
{
    if(_info != info)
    {
        _info = info;
        [self.head_imageView sea_setImageWithURL:_info.userInfo.headImageURL];
        self.name_label.text = _info.userInfo.displayName;
        self.earn_label.attributedText = _info.earnAmountAttributedString;
        self.order_count_label.attributedText = _info.orderCountAttributedString;
    }
}


@end

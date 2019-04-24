//
//  WMPartnerListCell.m
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/2.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMPartnerListCell.h"
#import "WMPartnerLevelView.h"
#import "WMPartnerInfo.h"

@implementation WMPartnerListCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    CGFloat width = (WMPartnerListCellHeight - 1.0 - WMPartnerListCellMargin * 2);
    self.head_imageView.layer.cornerRadius = width / 2.0;
    self.head_imageView.layer.masksToBounds = YES;
    self.head_imageView.sea_placeHolderImage = [UIImage imageNamed:@"default_head_image"];
    self.head_imageView.sea_thumbnailSize = CGSizeMake(width, width);
    self.name_label.font = [UIFont fontWithName:MainFontName size:17.0];
    self.level_view.backgroundColor = [UIColor clearColor];
    self.earn_amount_label.textColor = WMPriceColor;
    self.earn_amount_label.font = [UIFont fontWithName:MainFontName size:15.0];
    self.earn_title_label.font = [UIFont fontWithName:MainFontName size:14.0];
    self.referral_num_label.font = [UIFont fontWithName:MainFontName size:14.0];
}

- (void)setInfo:(WMPartnerInfo *)info
{
    if(_info != info)
    {
        _info = info;
        [self.head_imageView sea_setImageWithURL:_info.userInfo.headImageURL];
        self.name_label.text = _info.userInfo.displayName;
        self.level_view.info = _info;
        self.earn_amount_label.text = formatStringPrice(_info.earnAmount);
        self.referral_num_label.text = [NSString stringWithFormat:@"团队 %d 人", _info.referral];
    }
}

@end

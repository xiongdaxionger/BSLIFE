//
//  WMPartnerLevelupCell.m
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/3.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMPartnerLevelupCell.h"
#import "WMPartnerInfo.h"

@implementation WMPartnerLevelupCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    CGFloat width = (WMPartnerLevelupCellHeight - 1.0 - 10 * 2);
    self.head_imageView.layer.cornerRadius = width / 2.0;
    self.head_imageView.layer.masksToBounds = YES;
    self.head_imageView.sea_thumbnailSize = CGSizeMake(width, width);
    self.name_label.font = [UIFont fontWithName:MainFontName size:17.0];
    self.phone_number_label.font = [UIFont fontWithName:MainFontName size:15.0];
    self.levelup_btn.backgroundColor = WMButtonBackgroundColor;
    self.levelup_btn.layer.cornerRadius = 3.0;
    self.levelup_btn.layer.masksToBounds = YES;
    [self.levelup_btn setTitleColor:WMTintColor forState:UIControlStateNormal];
    self.levelup_btn.titleLabel.font = [UIFont fontWithName:MainFontName size:15.0];
}

///升级
- (IBAction)levelup:(id)sender
{
    if([self.delegate respondsToSelector:@selector(partnerLevelupCellDidLevelup:)])
    {
        [self.delegate partnerLevelupCellDidLevelup:self];
    }
}

- (void)setInfo:(WMPartnerInfo *)info
{
    if(_info != info)
    {
        _info = info;
        [self.head_imageView sea_setImageWithURL:_info.userInfo.headImageURL];
        self.name_label.text = _info.userInfo.displayName;
        
        self.phone_number_label.text = [NSString stringWithFormat:@"电话：%@", _info.userInfo.accountSecurityInfo.phoneNumber];
    }
}

@end

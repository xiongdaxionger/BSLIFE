//
//  WMMessageNoticeListCell.m
//  StandardShop
//
//  Created by 罗海雄 on 16/7/15.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMMessageNoticeListCell.h"
#import "WMMessageInfo.h"

@implementation WMMessageNoticeListCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.selectionStyle = UITableViewCellSelectionStyleGray;
    
    self.red_point.layer.cornerRadius = self.red_point.sea_widthLayoutConstraint.constant / 2.0;
    self.red_point.layer.borderColor = [UIColor whiteColor].CGColor;
    self.red_point.layer.borderWidth = 1.0;
    self.red_point.backgroundColor = WMRedColor;

    self.title_label.font = [UIFont fontWithName:MainFontName size:16.0];
    self.subtitle_label.font = [UIFont fontWithName:MainFontName size:14.0];
    self.subtitle_label.textColor = [UIColor grayColor];
}

- (void)setInfo:(WMMessageNoticeInfo *)info
{
    if(_info != info)
    {
        _info = info;
        self.title_label.text = _info.title;
        self.subtitle_label.text = [NSString stringWithFormat:@"时间：%@", _info.time];
        self.red_point.hidden = _info.read;
        [self.icon_imageView sea_setImageWithURL:_info.imageURL];
    }
}

@end

//
//  WMTopupActivityCell.m
//  StandardShop
//
//  Created by 罗海雄 on 16/7/6.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMTopupActivityCell.h"
#import "WMTopupActivityInfo.h"

@implementation WMTopupActivityCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.name_label.insets = UIEdgeInsetsMake(0, 5.0, 0, 5.0);
    self.name_label.backgroundColor = [UIColor colorFromHexadecimal:@"F6F6F6"];
    self.name_label.font = [UIFont fontWithName:MainFontName size:17.0];
    self.name_label.textColor = WMRedColor;
    self.desc_label.font = [UIFont fontWithName:MainFontName size:14.0];
    self.topup_btn.backgroundColor = WMButtonBackgroundColor;
    [self.topup_btn setTitleColor:WMButtonTitleColor forState:UIControlStateNormal];
    self.topup_btn.layer.cornerRadius = 3.0;
    self.topup_btn.titleLabel.font = [UIFont fontWithName:MainFontName size:13.0];
}

- (void)setInfo:(WMTopupActivityInfo *)info
{
    if(_info != info)
    {
        _info = info;
        self.name_label.attributedText = _info.name;
        self.desc_label.text = _info.desc;
    }
}

///充值信息
- (IBAction)topupAction:(id)sender
{
    if([self.delegate respondsToSelector:@selector(topupActivityCellDidTopup:)])
    {
        [self.delegate topupActivityCellDidTopup:self];
    }
}

@end

@implementation WMTopupActivityNoTopupBtnCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        CGFloat margin = 10.0;
        
        _name_label = [[SeaTextInsetLabel alloc] initWithFrame:CGRectMake(margin, margin, (WMTopupActivityCellHeight - margin * 2) * 5 / 4, WMTopupActivityCellHeight - margin * 2)];
        _name_label.insets = UIEdgeInsetsMake(0, 5.0, 0, 5.0);
        _name_label.font = [UIFont fontWithName:MainFontName size:17.0];
        _name_label.textColor = WMRedColor;
        _name_label.textAlignment = NSTextAlignmentCenter;
        _name_label.numberOfLines = 0;
        _name_label.backgroundColor = [UIColor colorFromHexadecimal:@"F6F6F6"];
        [self.contentView addSubview:_name_label];

        _desc_label = [[UILabel alloc] initWithFrame:CGRectMake(_name_label.right + margin, _name_label.top, _width_ - _name_label.right - margin * 2, _name_label.height)];
        _desc_label.font = [UIFont fontWithName:MainFontName size:14.0];
        _desc_label.numberOfLines = 3;
        [self.contentView addSubview:_desc_label];
    }

    return self;
}

- (void)setInfo:(WMTopupActivityInfo *)info
{
    if(_info != info)
    {
        _info = info;
        self.name_label.attributedText = _info.name;
        self.desc_label.text = _info.desc;
    }
}

@end

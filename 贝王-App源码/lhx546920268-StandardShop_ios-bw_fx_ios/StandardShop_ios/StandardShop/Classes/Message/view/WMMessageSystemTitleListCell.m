//
//  WMMessageSystemTitleListCell.m
//  StandardShop
//
//  Created by 罗海雄 on 16/7/15.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMMessageSystemTitleListCell.h"

@implementation WMMessageSystemTitleListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(WMMessageSystemTitleListCellMargin, 0, _width_ - WMMessageSystemTitleListCellMargin * 2, WMMessageSystemTitleListCellHeight)];
        _titleLabel.font = [UIFont fontWithName:MainFontName size:15.0];
        _titleLabel.textColor = WMRedColor;
        [self.contentView addSubview:_titleLabel];
    }

    return self;
}

@end

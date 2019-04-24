//
//  WMMeListCell.m
//  WanShoes
//
//  Created by 罗海雄 on 16/3/14.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "WMMeListCell.h"

@implementation WMMeListCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    self.title_label.font = [UIFont fontWithName:MainFontName size:15.0];
    self.content_label.font = [UIFont fontWithName:MainFontName size:12.0];
    self.content_label.textColor = [UIColor grayColor];
}


@end

@implementation WMMeListNoIconCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        CGFloat margin = 10.0;
        UIImage *image = [UIImage imageNamed:@"arrow_gray"];

        _arrow = [[UIImageView alloc] initWithImage:image];
        _arrow.frame = CGRectMake(_width_ - margin - image.size.width, (WMMeListCellHeight - image.size.height) / 2.0, image.size.width, image.size.height);
        [self.contentView addSubview:_arrow];

        margin = 15.0;
        _title_label = [[UILabel alloc] initWithFrame:CGRectMake(margin, 0, _arrow.left - margin, WMMeListCellHeight)];
        _title_label.font = [UIFont fontWithName:MainFontName size:14.0];
        _title_label.textColor = MainGrayColor;
        [self.contentView addSubview:_title_label];
    }

    return self;
}

@end

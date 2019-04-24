//
//  WMGoodCommentScoreSelectCell.m
//  StandardShop
//
//  Created by 罗海雄 on 16/6/29.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodCommentScoreSelectCell.h"
#import "WMGoodCommentScoreView.h"

@implementation WMGoodCommentScoreSelectCell

- (instancetype)init
{
    return [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WMGoodCommentScoreSelectCell"];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        CGFloat margin = 15.0;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, 0, 90.0, WMGoodCommentScoreSelectCellHeight)];
        _titleLabel.textColor = MainGrayColor;
        _titleLabel.font = [UIFont fontWithName:MainFontName size:15.0];
        [self.contentView addSubview:_titleLabel];

        _scoreView = [[WMGoodCommentScoreView alloc] initWithFrame:CGRectMake(_titleLabel.right, (WMGoodCommentScoreSelectCellHeight - 20.0) / 2.0, 100.0, 20.0)];
        _scoreView.editable = YES;
        [self.contentView addSubview:_scoreView];
    }

    return self;
}

@end

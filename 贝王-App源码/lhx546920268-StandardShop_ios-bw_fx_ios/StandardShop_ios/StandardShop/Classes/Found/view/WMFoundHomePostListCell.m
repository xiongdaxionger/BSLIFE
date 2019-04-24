//
//  WMFoundHomePostListCell.m
//  SuYan
//
//  Created by 罗海雄 on 16/4/29.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMFoundHomePostListCell.h"
#import "WMFoundListInfo.h"

@implementation WMFoundHomePostListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.title_label.font = [UIFont fontWithName:MainFontName size:15.0];
    self.name_label.font = [UIFont fontWithName:MainFontName size:13.0];
    self.name_label.backgroundColor = [UIColor colorWithWhite:0.80 alpha:1.0];
    self.name_label.layer.cornerRadius = 3.0;
    self.name_label.layer.masksToBounds = YES;
    
    self.praise_btn.titleLabel.font = [UIFont fontWithName:MainNumberFontName size:13.0];
    self.praise_btn.tintColor = [UIColor grayColor];
    [self.praise_btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.comment_btn.titleLabel.font = self.praise_btn.titleLabel.font;
    self.comment_btn.tintColor = self.praise_btn.tintColor;
    [self.comment_btn setTitleColor:[self.praise_btn titleColorForState:UIControlStateNormal] forState:UIControlStateNormal];
    
    self.imageView.sea_originContentMode = UIViewContentModeScaleAspectFit;
}

- (void)setInfo:(WMFoundListInfo *)info
{
    if(_info != info)
    {
        _info = info;
        self.title_label.text = _info.title;
        self.name_label.text = _info.pName;
        [self.imageView sea_setImageWithURL:_info.smallImageURL];
        
        if(_info.pNameWidth == 0)
        {
            _info.pNameWidth = [_info.pName stringSizeWithFont:self.name_label.font contraintWith:WMFoundHomePostListCellSize.width - WMFoundHomePostListCellSize.height * 5 / 4 - 15.0 * 2 - WMFoundHomePostListCellMargin].width + 10.0;
        }
        
        self.name_widthLayoutConstraint.constant = _info.pNameWidth;
        
        self.praise_btn.selected = _info.isPraised;
        [self.praise_btn setTitle:[NSString stringWithFormat:@" %d", _info.praisedCount] forState:UIControlStateNormal];
        [self.comment_btn setTitle:[NSString stringWithFormat:@" %d", _info.commentCount] forState:UIControlStateNormal];
    }
}

///点赞
- (IBAction)praiseAction:(id)sender
{
    if([self.delegate respondsToSelector:@selector(foundHomePostListCellDidPraise:)])
    {
        [self.delegate foundHomePostListCellDidPraise:self];
    }
}

///评论
- (IBAction)commentAction:(id)sender
{
    if([self.delegate respondsToSelector:@selector(foundHomePostListCellDidComment:)])
    {
        [self.delegate foundHomePostListCellDidComment:self];
    }
}

@end

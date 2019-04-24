//
//  WMFoundCommentBottomView.m
//  WanShoes
//
//  Created by 罗海雄 on 16/3/23.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "WMFoundCommentBottomView.h"
#import "WMFoundListInfo.h"

@interface WMFoundCommentBottomView ()


@end

@implementation WMFoundCommentBottomView

- (instancetype)init
{
    WMFoundCommentBottomView *view = [[[NSBundle mainBundle] loadNibNamed:@"WMFoundCommentBottomView" owner:nil options:nil] lastObject];
    view.frame = CGRectMake(0, 0, _width_, WMFoundCommentBottomViewHeight);

    return view;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.line.backgroundColor = _separatorLineColor_;
    self.line.sea_heightLayoutConstraint.constant = _separatorLineWidth_;

    self.praise_btn.tintColor = WMRedColor;
    self.comment_btn.tintColor = self.praise_btn.tintColor;
    self.share_btn.tintColor = self.praise_btn.tintColor;

    self.praise_btn.titleLabel.font = [UIFont fontWithName:MainFontName size:14.0];
    self.comment_btn.titleLabel.font = self.praise_btn.titleLabel.font;

    [self.praise_btn setTitleColor:WMRedColor forState:UIControlStateNormal];
    [self.comment_btn setTitleColor:WMRedColor forState:UIControlStateNormal];

    [self.praise_btn setTitleColor:WMRedColor forState:UIControlStateSelected];
}

- (void)setInfo:(WMFoundListInfo *)info
{
    if(_info != info)
    {
        _info = info;
        [self.praise_btn setTitle:[NSString stringWithFormat:@" %d", _info.praisedCount] forState:UIControlStateNormal];
        [self.comment_btn setTitle:[NSString stringWithFormat:@" %d", _info.commentCount] forState:UIControlStateNormal];
        self.praise_btn.selected = _info.isPraised;
    }
}

///点赞
- (IBAction)praiseAction:(id)sender
{
    if([self.delegate respondsToSelector:@selector(foundCommentBottomViewDidPraise:)])
    {
        [self.delegate foundCommentBottomViewDidPraise:self];
    }
}

///评论
- (IBAction)commentAction:(id)sender
{
    if([self.delegate respondsToSelector:@selector(foundCommentBottomViewDidComment:)])
    {
        [self.delegate foundCommentBottomViewDidComment:self];
    }
}

///分享
- (IBAction)shareAction:(id)sender
{
    if([self.delegate respondsToSelector:@selector(foundCommentBottomViewDidShare:)])
    {
        [self.delegate foundCommentBottomViewDidShare:self];
    }
}

@end
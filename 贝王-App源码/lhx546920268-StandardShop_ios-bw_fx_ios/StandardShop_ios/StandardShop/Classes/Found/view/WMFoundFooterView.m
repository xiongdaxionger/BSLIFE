//
//  WMFoundFooterView.m
//  WanShoes
//
//  Created by 罗海雄 on 16/3/22.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "WMFoundFooterView.h"
#import "WMFoundListInfo.h"

@implementation WMFoundFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if(self)
    {
        _footerContentView = [[[NSBundle mainBundle] loadNibNamed:@"WMFoundFooterView" owner:nil options:nil] lastObject];
        _footerContentView.frame = CGRectMake(WMFoundBaseCellMargin, 0, _width_ - WMFoundBaseCellMargin * 2, 50.0);
        [_footerContentView.praise_btn addTarget:self action:@selector(praiseAction:) forControlEvents:UIControlEventTouchUpInside];
        [_footerContentView.comment_btn addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
        _footerContentView.layer.shadowColor = _separatorLineColor_.CGColor;
        _footerContentView.layer.shadowOpacity = 0.8;
        _footerContentView.layer.shadowOffset = CGSizeMake(0, 1.0);
        _footerContentView.layer.shadowRadius = 1.0;
        
        [self.contentView addSubview:_footerContentView];
    }
    
    return self;
}

- (void)setInfo:(WMFoundListInfo *)info
{
    _info = info;
    self.footerContentView.time_label.text = info.time;
    [self.footerContentView.praise_btn setTitle:[NSString stringWithFormat:@" %d", info.praisedCount] forState:UIControlStateNormal];
    [self.footerContentView.comment_btn setTitle:[NSString stringWithFormat:@" %d", info.commentCount] forState:UIControlStateNormal];
    self.footerContentView.praise_btn.selected = info.isPraised;
    self.footerContentView.name_label.text = info.author;
}

///点赞
- (void)praiseAction:(UIButton*) btn
{
    if([self.delegate respondsToSelector:@selector(foundFooterViewDidPraise:)])
    {
        [self.delegate foundFooterViewDidPraise:self];
    }
}

///评论
- (void)commentAction:(UIButton*) btn
{
    if([self.delegate respondsToSelector:@selector(foundFooterViewDidComment:)])
    {
        [self.delegate foundFooterViewDidComment:self];
    }
}

@end

@implementation WMFoundFooterContentView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.time_label.font = [UIFont fontWithName:MainFontName size:13.0];
    self.name_label.font = [UIFont fontWithName:MainFontName size:14.0];
    self.name_label.textColor = MainLightGrayColor;
    self.name_label.text = appName();
    
    self.praise_btn.titleLabel.font = [UIFont fontWithName:MainNumberFontName size:13.0];
    self.praise_btn.tintColor = [UIColor grayColor];
    [self.praise_btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.comment_btn.titleLabel.font = self.praise_btn.titleLabel.font;
    self.comment_btn.tintColor = self.praise_btn.tintColor;
    [self.comment_btn setTitleColor:[self.praise_btn titleColorForState:UIControlStateNormal] forState:UIControlStateNormal];
}

@end

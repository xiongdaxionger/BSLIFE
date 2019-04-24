//
//  WMGoodCommentListCell.m
//  StandardShop
//
//  Created by 罗海雄 on 16/6/2.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodCommentListCell.h"
#import "WMGoodCommentInfo.h"
#import "WMGridImageView.h"
#import "WMGoodCommentScoreView.h"

@interface WMGoodCommentListCell ()<WMGridImageViewDelegate,SeaImageBrowserDelegate>

///
@property(nonatomic,strong) SeaImageBrowser *browser;

@end

@implementation WMGoodCommentListCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.head_imageView.layer.cornerRadius = 40.0 / 2.0;
    self.head_imageView.layer.masksToBounds = YES;
    self.name_label.font = [UIFont fontWithName:MainFontName size:16.0];
    self.level_label.font = [UIFont fontWithName:MainFontName size:11.0];
    self.time_label.font = [UIFont fontWithName:MainFontName size:11.0];
    self.time_label.textColor = [UIColor grayColor];
    self.level_bg_view.backgroundColor = WMRedColor;
    self.content_label.font = WMGoodCommentContentFont;
    self.content_label.lineBreakMode = NSLineBreakByWordWrapping;

    self.grid_imageView.interval = 5.0;
    self.grid_imageView.maxCountPerRow = 3;
    CGFloat width = _width_ - 15.0 * 3 - 45.0;
    self.grid_imageView.imageSize = (width - self.grid_imageView.interval * (self.grid_imageView.maxCountPerRow - 1)) / self.grid_imageView.maxCountPerRow;
    self.grid_imageView.delegate = self;

    self.level_bg_view.layer.cornerRadius = 7.0;
    self.level_bg_view.layer.masksToBounds = YES;


    self.reply_content_label.font = self.content_label.font;
    self.reply_content_label.textColor = MainGrayColor;
    self.reply_content_label.lineBreakMode = NSLineBreakByWordWrapping;

    self.more_btn.titleLabel.font = [UIFont fontWithName:MainFontName size:15.0];
    [self.more_btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.more_btn setTitle:@"隐藏更多评价" forState:UIControlStateSelected];
    [self.more_btn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    
    self.head_imageView.sea_placeHolderImage = [UIImage imageNamed:@"default_head_image"];

//    self.content_label.backgroundColor = [UIColor cyanColor];
//    self.reply_content_label.backgroundColor = [UIColor redColor];
}

- (void)setInfo:(WMGoodCommentInfo *)info
{
    _info = info;
    [self.head_imageView sea_setImageWithURL:_info.userInfo.headImageURL];
    self.name_label.text = _info.userInfo.displayName;
    self.level_label.text = _info.userInfo.level;
    self.time_label.text = _info.time;
    self.content_label.text = _info.content;
    self.content_heightLayoutConstraint.constant = _info.contentHeight;
    self.grid_imageView.images = _info.images;
    self.grid_imageView_heightLayoutConstraint.constant = _info.imageHeight;
    self.score_view.score = _info.score;
    self.reply_content_label.attributedText = _info.expand ? _info.replyAttributedString : _info.partialReplyAttributedString;
    self.reply_content_heightLayoutConstraint.constant = _info.expand ? _info.replyHeight : _info.partialReplyHeight;

    self.more_btn.hidden = _info.replyInfos.count <= WMGoodCommentInfoPartialReplayMaxCount;
    if(!self.more_btn.hidden)
    {
        self.more_btn.selected = _info.expand;
        [self.more_btn setTitle:[NSString stringWithFormat:@"更多%d条评价", (int)_info.replyInfos.count - WMGoodCommentInfoPartialReplayMaxCount] forState:UIControlStateNormal];
    }

    self.reply_content_topLayoutConstraint.constant = _info.images.count > 0 ? 10.0 : 0;
}

///点击更多
- (IBAction)moreAction:(id)sender
{
    self.more_btn.selected = !self.more_btn.selected;
    self.info.expand = !self.info.expand;
    if([self.delegate respondsToSelector:@selector(goodCommentListCellExpandStateDidChange:)])
    {
        [self.delegate goodCommentListCellExpandStateDidChange:self];
    }
}

///回复
- (IBAction)replyAction:(id)sender
{
    if([self.delegate respondsToSelector:@selector(goodCommentListCellDidReply:)])
    {
        [self.delegate goodCommentListCellDidReply:self];
    }
}

#pragma mark- WMGridImageView delegate

- (void)gridImageView:(WMGridImageView *)view didSelectAtIndex:(NSInteger)index
{
    if(!self.browser)
    {
        SeaImageBrowser *browser = [[SeaImageBrowser alloc] initWithSource:view.images visibleIndex:index];
        browser.delegate = self;
        UIImageView *imageView = [view cellForIndex:index];
        CGRect rect = [view convertRect:imageView.frame toView:[UIApplication sharedApplication].keyWindow];
        browser.previousImage = imageView.image;
        
        [browser setShowFullScreen:YES fromRect:rect animate:YES];
        self.browser = browser;
    }
}

#pragma mark- SeaImageBrowser delegate

- (void)imageBrowserWillExistFullScreen:(SeaImageBrowser *)browser
{
    UIImageView *imageView = [self.grid_imageView cellForIndex:browser.visibleIndex];
    browser.previousImage = imageView.image;
    CGRect rect = [self.grid_imageView convertRect:imageView.frame toView:[UIApplication sharedApplication].keyWindow];
    browser.previousFrame = rect;
    self.browser = nil;
}

///获取行高
+ (CGFloat)rowHeightForInfo:(WMGoodCommentInfo*) info
{
    if(info.contentHeight == 0)
    {
        CGFloat width = _width_ - 15.0 * 3 - 45.0;
        UIFont *font = WMGoodCommentContentFont;
        info.contentHeight = [info.content stringSizeWithFont:font contraintWith:width].height + 1.0;
        info.imageHeight = [WMGridImageView heightForImageCount:info.images.count imageSize:(width - 5.0 * 2) / 3];
    }

    if(info.replyInfos.count > 0)
    {
        if(info.expand)
        {
            if(info.replyHeight == 0)
            {
                CGFloat width = _width_ - 15.0 * 3 - 40.0;
                CGFloat height = [info.replyAttributedString boundsWithConstraintWidth:width].height + 1.0;
                info.replyHeight = height;
            }
        }
        else
        {
            if(info.partialReplyHeight == 0)
            {
                CGFloat width = _width_ - 15.0 * 3 - 40.0;
                CGFloat height = [info.partialReplyAttributedString boundsWithConstraintWidth:width].height + 1.0;
                info.partialReplyHeight = height;
            }
        }
    }

    //正文内容高度
    CGFloat height = 15.0 + 40.0 + 10.0 + info.contentHeight + (info.images.count > 0 ? 10.0 : 0) + info.imageHeight + 15.0;

    ///回复内容高度
    CGFloat replyHeight = 0;
    if(info.replyInfos.count > 0)
    {
        replyHeight += 10.0;
        replyHeight += info.expand ? info.replyHeight : info.partialReplyHeight;
        
        if(info.replyInfos.count > WMGoodCommentInfoPartialReplayMaxCount)
        {
            ///要显示更多按钮
            replyHeight += 10.0 + 20.0;
        }
    }

    return height + replyHeight;
}

@end

//
//  WMGoodListCell.m
//  SuYan
//
//  Created by 罗海雄 on 16/4/14.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodListCell.h"
#import "WMGoodInfo.h"
#import "WMShareActionSheet.h"
#import "WMGoodTagView.h"
#import "WMGoodMarkView.h"

@implementation WMGoodListCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.good_imageView.sea_originContentMode = UIViewContentModeScaleAspectFit;
    self.good_imageView.layer.borderWidth = _separatorLineWidth_;
    self.good_imageView.layer.borderColor = _separatorLineColor_.CGColor;
    self.name_label.font = [UIFont fontWithName:MainFontName size:16.0];
    self.price_label.textColor = WMPriceColor;
    self.price_label.font = [UIFont fontWithName:MainNumberFontName size:20.0];
    self.comment_count_label.font = [UIFont fontWithName:MainFontName size:10.0];
    self.comment_count_label.textColor = [UIColor grayColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.commission_label.textColor = [UIColor darkGrayColor];
    self.commission_label.font = [UIFont fontWithName:MainFontName size:17.0];

    self.commission_label.text = nil;
    self.commission_label.hidden = YES;
    self.sales_label.font = [UIFont fontWithName:MainFontName size:13.0];
    self.sales_label.textColor = [UIColor grayColor];

    self.collect_btn.titleLabel.font = [UIFont fontWithName:MainFontName size:14.0];
    self.share_btn.titleLabel.font = self.collect_btn.titleLabel.font;

    self.contentView.layer.borderColor = _separatorLineColor_.CGColor;
    self.contentView.layer.borderWidth = _separatorLineWidth_;

    self.mark_view.maxWidth = _width_ - 125.0 - 10.0 * 3 - 5.0 - 30.0;
    
//    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
//    
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:WMGoodListCellMargin]];
//    
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:WMGoodListCellMargin]];
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:WMGoodListCellMargin]];
}




- (void)setInfo:(WMGoodInfo *)info
{
    [super setInfo:info];
    
    CGFloat maxWidth = _width_ - WMGoodListCellMargin * 2 - 125.0 - 10.0 * 3 - 5.0 - 30.0;
    self.comment_count_label.text = [NSString stringWithFormat:@"%lld人评论", info.commentCount];
    if(info.commentCountWidth == 0)
    {
        info.commentCountWidth = [self.comment_count_label.text stringSizeWithFont:self.comment_count_label.font contraintWith:maxWidth].width + 1.0;
    }
    
    self.mark_view.maxWidth = maxWidth - info.commentCountWidth;
    
    [self.good_imageView sea_setImageWithURL:info.imageURL];
    self.name_label.text = info.goodName;
    self.price_label.attributedText = info.formatPriceConbination;
    
    if (info.isPresell) {
        
        if (info.preapreType == PrepareSaleTypeBargainBegin || info.preapreType == PrepareSaleTypeNoBeign) {
            
            self.soldout_imageView.hidden = YES;
        }
        else{
            
            self.soldout_imageView.hidden = NO;
        }
        
        self.soldout_imageView.image = [UIImage imageNamed:@"prepare_finish"];
    }
    else
    {
        self.soldout_imageView.hidden = info.inventory > 0;
        self.soldout_imageView.image = [UIImage imageNamed:@"soldout_icon"];
    }
    
    self.tag_view.tags = info.tagInfos;
    self.mark_view.marks = info.markInfos;
    self.shopcart_btn.hidden = !self.soldout_imageView.hidden;
    self.collect_btn.selected = info.isCollect;
    self.sales_label.text = info.sales == 0 ? nil : [NSString stringWithFormat:@"销量 %lld", info.sales];
}

///加入购物车
- (IBAction)shopcartAction:(id)sender
{
    if([self.delegate respondsToSelector:@selector(goodListCellDidShopcartAdd:)])
    {
        [self.delegate goodListCellDidShopcartAdd:self];
    }
}

///收藏商品
- (IBAction)collectAction:(id)sender
{
    if([self.delegate respondsToSelector:@selector(goodListCellDidCollect:)])
    {
        [self.delegate goodListCellDidCollect:self];
    }
}

///对比商品
- (IBAction)compareAction:(id)sender
{

}

///分享商品
- (IBAction)shareAction:(id)sender
{
    WMShareActionSheet *actionSheet = [[WMShareActionSheet alloc] init];
    actionSheet.shareContentView.shareType = WMShareTypeGoodH5;
    actionSheet.shareContentView.goodInfo = self.info;
    actionSheet.shareContentView.navigationController = self.navigationController;
    [actionSheet show];
}

@end

//
//  WMGoodGridCell.m
//  StandardShop
//
//  Created by 罗海雄 on 16/6/3.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodGridCell.h"
#import "WMGoodInfo.h"
#import "WMGoodTagView.h"
#import "WMGoodMarkView.h"

@implementation WMGoodGridCell

- (void)awakeFromNib {
    [super awakeFromNib];

    CGSize size = WMGoodGridCellSize;
    
    self.good_imageView.sea_originContentMode = UIViewContentModeScaleAspectFit;
    self.tag_view.bounds = CGRectMake(0, 0, size.width, size.width);
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.name_label.font = [UIFont fontWithName:MainFontName size:14.0];
    self.price_label.font = [UIFont fontWithName:MainFontName size:17.0];
    self.price_label.textColor = WMPriceColor;
    self.comment_count_label.font = [UIFont fontWithName:MainFontName size:10.0];
    self.comment_count_label.textColor = [UIColor grayColor];
    self.mark_view.maxWidth = WMGoodGridCellSize.width - 5.0 * 2;
}

///加入购物车
- (IBAction)shopcartAction:(id)sender
{
    if([self.delegate respondsToSelector:@selector(goodListCellDidShopcartAdd:)])
    {
        [self.delegate goodListCellDidShopcartAdd:self];
    }
}

- (void)setInfo:(WMGoodInfo *)info
{
    [super setInfo:info];
    
    CGFloat maxWidth = WMGoodGridCellSize.width - 5.0 * 2;
    self.comment_count_label.text = [NSString stringWithFormat:@"%lld人评论", info.commentCount];
    if(info.commentCountWidth == 0)
    {
        info.commentCountWidth = [self.comment_count_label.text stringSizeWithFont:self.comment_count_label.font contraintWith:maxWidth].width + 1.0;
    }
    
    self.mark_view.maxWidth = maxWidth - info.commentCountWidth;
    
    self.name_label.text = info.goodName;
    [self.good_imageView sea_setImageWithURL:info.imageURL];
    self.price_label.attributedText = info.formatPrice;
    self.tag_view.tags = info.tagInfos;
    self.mark_view.marks = info.markInfos;
    
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
    
    self.shopcart_btn.hidden = !self.soldout_imageView.hidden;
}

@end

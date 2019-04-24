//
//  WMOrderGoodViewCell.m
//  AKYP
//
//  Created by mac on 15/11/28.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import "WMOrderGoodViewCell.h"

#import "WMOrderInfo.h"
#import "WMRefundGoodModel.h"
#import "WMOrderdetailInfo.h"
#import "WMMyOrderOperation.h"

@implementation WMOrderGoodViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _goodQuantityLabel.font = [UIFont fontWithName:MainFontName size:12.0];

    _goodNameLabel.font = [UIFont fontWithName:MainFontName size:14.0];
    
    _goodNameLabel.numberOfLines = 2;
    
    _goodSpecInfoLabel.font = [UIFont fontWithName:MainFontName size:12.0];
    
    _goodPriceLabel.textColor = WMPriceColor;
    
    _commentButton.layer.borderColor = WMPriceColor.CGColor;
    
    _commentButton.layer.borderWidth = 1.0;
    
    _commentButton.layer.cornerRadius = WMLongButtonCornerRaidus;
    
    [_commentButton setTitleColor:WMPriceColor forState:UIControlStateNormal];
    
    [_commentButton addTarget:self action:@selector(commentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_goodImageView makeBorderWidth:_separatorLineWidth_ Color:_separatorLineColor_ CornerRadius:WMLongButtonCornerRaidus];
    
    _goodImageView.sea_originContentMode = UIViewContentModeScaleAspectFit;
}


- (void)configureCellWithModel:(id)model{
        
    if ([model isKindOfClass:[WMOrderGoodInfo class]]) {
        
        WMOrderGoodInfo *viewModel = (WMOrderGoodInfo *)model;
        
        _commentButton.hidden = !viewModel.canGoodComment;
        
        [_goodImageView sea_setImageWithURL:viewModel.image];
        
        _goodNameLabel.attributedText = viewModel.formatGoodName;
        
        _goodPriceLabel.attributedText = viewModel.price;
        
        _goodSpecInfoLabel.text = viewModel.specInfo;
        
        _goodQuantityLabel.text = [NSString stringWithFormat:@"x%@",viewModel.quantity];
    }
    else if ([model isKindOfClass:[WMOrderDetailGoodInfo class]]){
        
        WMOrderDetailGoodInfo *goodInfo = (WMOrderDetailGoodInfo *)model;
        
        _commentButton.hidden = !goodInfo.canGoodComment;
        
        [_goodImageView sea_setImageWithURL:goodInfo.image];
        
        _goodPriceLabel.attributedText = goodInfo.price;
        
        _goodNameLabel.attributedText = goodInfo.formatGoodName;
        
        _goodSpecInfoLabel.text = goodInfo.specInfo;
        
        _goodQuantityLabel.text = [NSString stringWithFormat:@"x%@",goodInfo.quantity];
    }
    else if ([model isKindOfClass:[WMRefundGoodModel class]]){
        
        _commentButton.hidden = YES;
        
        WMRefundGoodModel *goodModel = (WMRefundGoodModel *)model;
        
        [_goodImageView sea_setImageWithURL:goodModel.image];
        
        _goodPriceLabel.attributedText = goodModel.price;
        
        _goodNameLabel.text = goodModel.name;
        
        _goodSpecInfoLabel.text = goodModel.specInfo;
        
        _goodQuantityLabel.text = [NSString stringWithFormat:@"x%@",goodModel.num];
    }
}

- (void)commentButtonClick:(UIButton *)button{
    
    if (self.commentGood) {
        
        self.commentGood(self);
    }
}

@end

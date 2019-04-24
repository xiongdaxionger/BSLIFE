//
//  ValuesQuantityViewCell.m
//  WuMei
//
//  Created by qsit on 15/7/21.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "ValuesQuantityViewCell.h"

#import "WMGoodDetailInfo.h"
@interface ValuesQuantityViewCell()
/**商品购买最大数量
 */
@property (assign,nonatomic) NSInteger goodBuyLimit;
@end

@implementation ValuesQuantityViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _quantityLabel.font = [UIFont fontWithName:MainFontName size:15];
    
    UIFont *font = [UIFont fontWithName:MainNumberFontName size:13];
    
    _quantityCountLabel.font = font;
    
    _buyLimitCountLabel.font = font;
    
    _buyLimitCountLabel.textColor = WMMarketPriceColor;
    
    [_quantityView makeBorderWidth:_separatorLineWidth_ Color:_separatorLineColor_ CornerRadius:0.0];
    
    [_quantityCountLabel makeBorderWidth:_separatorLineWidth_ Color:_separatorLineColor_ CornerRadius:0.0];
    
    [_addButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_minusButton addTarget:self action:@selector(minusButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)configureWithModel:(WMGoodDetailInfo *)info{
    
    _buyQuantity = info.goodBuyQuantity;
    
    _quantityCountLabel.text = [NSString stringWithFormat:@"%ld",info.goodBuyQuantity];
    
    _goodBuyLimit = info.goodLismitCout;
    
    switch (info.type) {
        case GoodPromotionTypeSecondKill:
        {
            _buyLimitCountLabel.hidden = NO;
            
            _buyLimitCountLabel.text = [NSString stringWithFormat:@"限购:%ld%@",(long)info.goodLismitCout,info.goodUnit];
        }
            break;
        default:
        {
            _buyLimitCountLabel.hidden = YES;
        }
            break;
    }
}

- (void)addButtonClick:(UIButton *)button{
    
    if (_quantityCountLabel.text.integerValue + 1 > _goodBuyLimit) {
        
        [[AppDelegate instance] alertMsg:@"超过限购数量，请减少数量"];
        
        return;
    }
    
    _buyQuantity += 1;
    
    _quantityCountLabel.text = [NSString stringWithFormat:@"%ld",(long)_buyQuantity];
    
    if ([self.delegate respondsToSelector:@selector(changeBuyQuantityWithNewQuantity:)]) {
        
        [self.delegate changeBuyQuantityWithNewQuantity:_buyQuantity];
    }
}
- (void)minusButtonClick:(UIButton *)button{
    
    if (_quantityCountLabel.text.integerValue == 1) {
        
        return;
    }
    
    _buyQuantity -= 1;
    
    _quantityCountLabel.text = [NSString stringWithFormat:@"%ld",(long)_buyQuantity];
    
    if ([self.delegate respondsToSelector:@selector(changeBuyQuantityWithNewQuantity:)]) {
        
        [self.delegate changeBuyQuantityWithNewQuantity:_buyQuantity];
    }
}



@end

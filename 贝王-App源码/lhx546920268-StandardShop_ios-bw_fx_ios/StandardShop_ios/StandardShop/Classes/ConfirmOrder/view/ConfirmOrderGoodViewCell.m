//
//  ConfirmOrderGoodViewCell.m
//  WuMei
//
//  Created by qsit on 15/7/27.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "ConfirmOrderGoodViewCell.h"

#import "WMShopCarGoodInfo.h"
#import "WMMyOrderOperation.h"

@implementation ConfirmOrderGoodViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _orderGoodImage.layer.cornerRadius = 6.0;
    
    _orderGoodImage.clipsToBounds = YES;
    
    _orderGoodImage.sea_originContentMode = UIViewContentModeScaleAspectFit;
    
    _orderGoodNameLabel.font = [UIFont fontWithName:MainFontName size:14];
    
    _orderGoodNameLabel.numberOfLines = 2;
        
    _orderGoodPriceLabel.font = [UIFont fontWithName:MainNumberFontName size:14];
    
    _orderGoodQuantityLabel.font = [UIFont fontWithName:MainNumberFontName size:14];
    
    _orderGoodSpecInfo.font = [UIFont fontWithName:MainFontName size:14.0];
    
    _orderGoodSpecInfo.textColor = MainTextColor;
}


- (void)configureCellWithModel:(id)model{
    
    NSDictionary *contentDict = (NSDictionary *)model;
    
    NSInteger type = [[contentDict numberForKey:@"type"] integerValue];
    
    NSString *quantity;
    
    NSString *image;
    
    NSAttributedString *price;
    
    NSString *specInfo;
    
    switch (type) {
        case ShopCarGoodTypeAdjunctGood:
        {
            WMShopCarAdjunctGoodInfo *adjunctGoodInfo = (WMShopCarAdjunctGoodInfo *)[model objectForKey:@"model"];
            
            quantity = adjunctGoodInfo.quantity;
            
            image = adjunctGoodInfo.thumbnail;
            
            price = adjunctGoodInfo.salePrice;
            
            specInfo = adjunctGoodInfo.specInfo;
            
            _orderGoodNameLabel.attributedText = adjunctGoodInfo.formatGoodName;
        }
            break;
        case ShopCarGoodTypeExchangeGood:
        {
            WMShopCarExchangeGoodInfo *exchangeGoodInfo = (WMShopCarExchangeGoodInfo *)[model objectForKey:@"model"];
            
            quantity = exchangeGoodInfo.quantity;
            
            image = exchangeGoodInfo.thumbnail;
            
            price = exchangeGoodInfo.salePrice;
            
            specInfo = exchangeGoodInfo.specInfo;
            
            _orderGoodNameLabel.attributedText = exchangeGoodInfo.formatGoodName;
        }
            break;
        case ShopCarGoodTypeGiftGood:
        {
            WMShopCarOrderGiftGoodInfo *giftGoodInfo = (WMShopCarOrderGiftGoodInfo *)[model objectForKey:@"model"];
            
            quantity = giftGoodInfo.quantity;
            
            image = giftGoodInfo.thumbnail;
            
            price = giftGoodInfo.salePrice;
            
            _orderGoodNameLabel.attributedText = giftGoodInfo.formatGoodName;
        }
            break;
        case ShopCarGoodTypeNormalGood:
        {
            WMShopCarGoodInfo *normalGoodInfo = (WMShopCarGoodInfo *)[model objectForKey:@"model"];
            
            quantity = normalGoodInfo.quantity;
            
            image = normalGoodInfo.thumbnail;
            
            price = normalGoodInfo.buyPrice;
            
            specInfo = normalGoodInfo.specInfo;
            
            _orderGoodNameLabel.text = normalGoodInfo.goodName;
        }
            break;
        default:
            break;
    }
    
    [_orderGoodImage sea_setImageWithURL:image];

    _orderGoodPriceLabel.attributedText = price;
    
    _orderGoodQuantityLabel.text = [NSString stringWithFormat:@"x%@",quantity];
    
    _orderGoodSpecInfo.text = specInfo;
}

@end

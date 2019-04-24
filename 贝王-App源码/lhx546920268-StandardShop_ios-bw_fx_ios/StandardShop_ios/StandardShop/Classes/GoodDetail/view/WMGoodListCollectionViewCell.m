//
//  WMGoodListCollectionViewCell.m
//  StandardShop
//
//  Created by mac on 16/6/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodListCollectionViewCell.h"

#import "WMGoodDetailAdjGroupInfo.h"
#import "WMGoodSimilarInfo.h"
#import "WMShopCarGoodInfo.h"
#import "WMPriceOperation.h"

@interface WMGoodListCollectionViewCell ()
/**配件商品
 */
@property (strong,nonatomic) WMGoodDetailAdjGoodInfo *adjGoodInfo;
@end

@implementation WMGoodListCollectionViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.goodImage.sea_originContentMode = UIViewContentModeScaleAspectFit;
    
    self.goodNameLabel.font = [UIFont fontWithName:MainFontName size:12.0];
    
    self.goodNameLabel.textColor = WMMarketPriceColor;
    
    [self.addShopCarButton addTarget:self action:@selector(addShopCarButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)configureCellWithAdjGoodInfoWith:(WMGoodDetailAdjGoodInfo *)adjGoodInfo{
    
    self.adjGoodInfo = adjGoodInfo;
    
    [self.addShopCarButton setImage:[WMImageInitialization tickingIcon] forState:UIControlStateSelected];
    
    [self.addShopCarButton setImage:[WMImageInitialization untickIcon] forState:UIControlStateNormal];
    
    self.addShopCarButton.selected = self.adjGoodInfo.isSelect;
    
    [self.goodImage sea_setImageWithURL:adjGoodInfo.goodImage];
    
    self.goodNameLabel.text = adjGoodInfo.goodName;
    
    self.goodPriceLabel.attributedText = [WMPriceOperation formatPrice:adjGoodInfo.goodAdjPrice font:[UIFont fontWithName:MainFontName size:14.0]];
    
    self.goodPriceLabel.textColor = [UIColor blackColor];
    
    self.productID = adjGoodInfo.productID;
}

- (void)configureCellWithSimilarInfoWith:(WMGoodSimilarInfo *)similarInfo{
    
    [self.goodImage sea_setImageWithURL:similarInfo.similarImageUrl];
    
    self.goodNameLabel.text = similarInfo.similarGoodName;
    
    self.goodPriceLabel.attributedText = [WMPriceOperation formatPrice:similarInfo.similarGoodPrice font:[UIFont fontWithName:MainFontName size:14.0]];
    
    self.goodPriceLabel.textColor = [UIColor blackColor];
    
    self.productID = similarInfo.similarProductID;
    
    self.addShopCarButton.hidden = YES;
}

- (void)addShopCarButtonAction{
    
    self.addShopCarButton.selected = !self.addShopCarButton.selected;
    
    if (self.adjGoodInfo) {
        
        self.adjGoodInfo.isSelect = self.addShopCarButton.selected;
    }
    else{
        
        if (self.addShopCarCallBack) {
            
            self.addShopCarCallBack(self.productID);
        }
    }
}

- (void)configureCellWithForOrderGoodInfoWith:(WMShopCarForOrderGoodInfo *)goodInfo{
    
    [self.addShopCarButton setImage:[UIImage imageNamed:@"shopcart_add_btn"] forState:UIControlStateNormal];
    
    [self.goodImage sea_setImageWithURL:goodInfo.image];
    
    self.goodNameLabel.text = goodInfo.name;
    
    self.goodPriceLabel.attributedText = [WMPriceOperation formatPrice:goodInfo.price font:[UIFont fontWithName:MainFontName size:14.0]];
    
    self.goodPriceLabel.textColor = [UIColor blackColor];
    
    self.productID = goodInfo.productID;
    
}












@end

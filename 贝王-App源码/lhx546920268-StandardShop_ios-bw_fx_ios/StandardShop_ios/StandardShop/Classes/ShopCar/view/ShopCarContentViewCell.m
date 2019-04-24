//
//  ShopCarContentViewCell.m
//  WuMei
//
//  Created by qsit on 15/7/18.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "ShopCarContentViewCell.h"
#import "WMShopCarViewController.h"
#import "UITextField+Utilities.h"

#import "WMShopCarGoodInfo.h"
#import "WMMyOrderOperation.h"

@interface ShopCarContentViewCell ()<UITextFieldDelegate>
/**购物车控制器
 */
@property (weak,nonatomic) WMShopCarViewController *shopCarController;
/**上次的数量
 */
@property (copy,nonatomic) NSString *lastCount;
/**商品类型
 */
@property (assign,nonatomic) ShopCarGoodType type;
/**最大购买量
 */
@property (assign,nonatomic) NSInteger maxBuyCount;
/**是否处于编辑状态
 */
@property (assign,nonatomic) BOOL isEdit;
@end

@implementation ShopCarContentViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
        
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _shopIconImage.sea_originContentMode = UIViewContentModeScaleAspectFit;
    
    _goodSpecInfoLabel.font = [UIFont fontWithName:MainFontName size:11];
    
    _goodSpecInfoLabel.textColor = MainTextColor;
    
    _shopPriceLabel.font = [UIFont fontWithName:MainNumberFontName size:14.0];
    
    _shopNameLabel.font = [UIFont fontWithName:MainFontName size:15.0];
    
    _giftQuantityLabel.font = [UIFont fontWithName:MainFontName size:13.0];
    
    _shopCountLabel.textColor = [UIColor blackColor];
    
    _shopCountLabel.textAlignment = NSTextAlignmentCenter;
    
    _shopCountLabel.keyboardType = UIKeyboardTypeNumberPad;

    [_shopCountLabel setDefaultInputAccessoryViewWithTarget:self action:@selector(tapClearView)];
    
    _shopCountLabel.returnKeyType = UIReturnKeyDone;
    
    _shopCountLabel.delegate = self;
    
    [_shopSelecteButton addTarget:self action:@selector(selecteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_shopDeleteButton addTarget:self action:@selector(deleteShopItem:) forControlEvents:UIControlEventTouchUpInside];
    [_shopAddButton addTarget:self action:@selector(addShopItemCount:) forControlEvents:UIControlEventTouchUpInside];
    [_shopMinusButton addTarget:self action:@selector(minusShopItemCount:) forControlEvents:UIControlEventTouchUpInside];
    
    [_goodQuantityView makeBorderWidth:_separatorLineWidth_ Color:_separatorLineColor_ CornerRadius:0.0];
    
    [_shopCountLabel makeBorderWidth:_separatorLineWidth_ Color:_separatorLineColor_ CornerRadius:0.0];
    
    [_shopIconImage makeBorderWidth:_separatorLineWidth_ Color:_separatorLineColor_ CornerRadius:4.0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapClearView) name:@"tapShowView" object:nil];
    
    _selectImage = [WMImageInitialization tickingIcon];
    
    _unSelectImage = [WMImageInitialization untickIcon];
    
    _noUseImage = [UIImage imageNamed:@"good_no_use"];
}


#pragma mark - 配置数据
- (void)configureCellWithModel:(id)model{

    NSDictionary *contentDict = (NSDictionary *)model;
    
    _type = [[contentDict numberForKey:@"type"] integerValue];
    
    _shopCarController = [model objectForKey:@"controller"];
    
    BOOL isEdit = [[contentDict numberForKey:@"isEdit"] boolValue];
    
    self.isEdit = isEdit;
    
    NSString *quantity;
    
    NSString *image;
    
    NSString *specInfo;
    
    switch (_type) {
        case ShopCarGoodTypeAdjunctGood:
        {
            WMShopCarAdjunctGoodInfo *adjunctGoodInfo = (WMShopCarAdjunctGoodInfo *)[model objectForKey:@"model"];
            
            _maxBuyCount = adjunctGoodInfo.maxBuyCount.integerValue;
            
            quantity = adjunctGoodInfo.quantity;
            
            image = adjunctGoodInfo.thumbnail;
            
            _shopPriceLabel.attributedText = adjunctGoodInfo.salePrice;
            
            specInfo = adjunctGoodInfo.specInfo;
            
            _shopSelecteButton.hidden = YES;
            
            _goodQuantityView.hidden = NO;
            
            _shopNameLabel.attributedText = adjunctGoodInfo.formatGoodName;
            
            _giftQuantityLabel.hidden = YES;
            
            [_shopSelecteButton setSelected:YES];
            
            _goodSpecInfoLabel.textColor = MainTextColor;
        }
            break;
        case ShopCarGoodTypeExchangeGood:
        {
            WMShopCarExchangeGoodInfo *exchangeGoodInfo = (WMShopCarExchangeGoodInfo *)[model objectForKey:@"model"];
            
            _maxBuyCount = exchangeGoodInfo.maxBuyCount.integerValue;
            
            image = exchangeGoodInfo.thumbnail;
            
            _shopPriceLabel.attributedText = exchangeGoodInfo.salePrice;
            
            specInfo = exchangeGoodInfo.specInfo;
            
            quantity = exchangeGoodInfo.quantity;
            
            _shopSelecteButton.hidden = NO;
            
            _goodQuantityView.hidden = NO;
            
            _shopNameLabel.attributedText = exchangeGoodInfo.formatGoodName;
            
            _giftQuantityLabel.hidden = YES;
            
            [_shopSelecteButton setSelected:isEdit ? exchangeGoodInfo.isEditSelect : exchangeGoodInfo.isSelect];
            
            [_shopSelecteButton setImage:_selectImage forState:UIControlStateSelected];
            
            [_shopSelecteButton setImage:_unSelectImage forState:UIControlStateNormal];
            
            _goodSpecInfoLabel.textColor = MainTextColor;
        }
            break;
        case ShopCarGoodTypeGiftGood:
        {
            WMShopCarOrderGiftGoodInfo *giftGoodInfo = (WMShopCarOrderGiftGoodInfo *)[model objectForKey:@"model"];
            
            _maxBuyCount = 1;
            
            quantity = giftGoodInfo.quantity;
            
            image = giftGoodInfo.thumbnail;
            
            _shopPriceLabel.attributedText = giftGoodInfo.salePrice;
            
            _shopSelecteButton.hidden = YES;
            
            _goodQuantityView.hidden = YES;
            
            _giftQuantityLabel.text = [NSString stringWithFormat:@"x%@",quantity];
            
            specInfo = giftGoodInfo.specInfo;
            
            _shopNameLabel.attributedText = giftGoodInfo.formatGoodName;
            
            _giftQuantityLabel.hidden = NO;
            
            [_shopSelecteButton setSelected:YES];
            
            _goodSpecInfoLabel.textColor = MainTextColor;
        }
            break;
        case ShopCarGoodTypeNormalGood:
        {
            WMShopCarGoodInfo *normalGoodInfo = (WMShopCarGoodInfo *)[model objectForKey:@"model"];
            
            _maxBuyCount = normalGoodInfo.maxBuyCount.integerValue;
            
            image = normalGoodInfo.thumbnail;
            
            _shopPriceLabel.attributedText = normalGoodInfo.buyPrice;
            
            _shopSelecteButton.hidden = NO;
            
            specInfo = normalGoodInfo.specInfo;
            
            quantity = normalGoodInfo.quantity;
            
            _shopNameLabel.text = normalGoodInfo.goodName;
            
            _giftQuantityLabel.hidden = YES;
            
            if (normalGoodInfo.goodStore.integerValue == 0) {
                
                _shopSelecteButton.selected = NO;
                
                [_shopSelecteButton setImage:_noUseImage forState:UIControlStateNormal];
                
                _goodQuantityView.hidden = YES;
                
                _goodSpecInfoLabel.textColor = WMRedColor;
                
                specInfo = @"该商品无库存或已售完";
            }
            else{
                
                _goodQuantityView.hidden = NO;
                
                [_shopSelecteButton setSelected:isEdit ? normalGoodInfo.isEditSelect : normalGoodInfo.isSelect];
                
                [_shopSelecteButton setImage:_selectImage forState:UIControlStateSelected];
                
                [_shopSelecteButton setImage:_unSelectImage forState:UIControlStateNormal];
                
                _goodSpecInfoLabel.textColor = MainTextColor;
            }
        }
            break;
        default:
            break;
    }
    
    _shopCountLabel.text = quantity;
    
    _lastCount = quantity;
    
    [_shopIconImage sea_setImageWithURL:image];
    
    _goodSpecInfoLabel.text = specInfo;
    
}

#pragma mark - 改变商品数量
- (void)addShopItemCount:(UIButton *)button{
    
    [_shopCountLabel resignFirstResponder];
    
    if (_shopCountLabel.text.integerValue + 1 > _maxBuyCount) {
        
        [[AppDelegate instance] alertMsg:@"超过限购量，无法修改"];
        
        return;
    }

    _lastCount = [NSString stringWithFormat:@"%ld",(long)(_lastCount.integerValue + 1)];
    
    [_shopCarController changeShopCarGoodQuantityWithCell:self quantity:1 isMinus:NO];
}

- (void)minusShopItemCount:(UIButton *)button{
    
    [_shopCountLabel resignFirstResponder];
    
    NSInteger newQuantity = self.lastCount.integerValue - 1;
    
    if(newQuantity <= 0)
        return;
    
    _lastCount = [NSString stringWithFormat:@"%ld",(long)(_lastCount.integerValue - 1)];
    
    [_shopCarController changeShopCarGoodQuantityWithCell:self quantity:1 isMinus:YES];
}

- (void)deleteShopItem:(UIButton *)button{
    
    [_shopCountLabel resignFirstResponder];
}


- (void)selecteButtonClick:(UIButton *)button{
    
    if (_lastCount.integerValue == 0) {
        
        return;
    }
    
    [_shopCountLabel resignFirstResponder];
    
    [button setSelected:!button.isSelected];
    
    [_shopCarController selectShopCarGoodWithCell:self isSelect:button.isSelected];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    return [textField textShouldChangeCharactersInRange:range replacementString:string limitedCount:3];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    NSIndexPath *indexPath = [_shopCarController.tableView indexPathForCell:self];
    
    [_shopCarController.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void)tapClearView{
    
    if (_shopCountLabel.text.integerValue > _maxBuyCount) {
        
        _shopCountLabel.text = [NSString stringWithFormat:@"%@",_lastCount];
        
        [[AppDelegate instance] alertMsg:[NSString stringWithFormat:@"商品库存%ld件，请减少数量",(long)_maxBuyCount]];
        
        return;
    }
    
    if (self.shopCountLabel.text.integerValue == 0) {
        
        self.shopCountLabel.text = _lastCount;
    }
    else if (self.shopCountLabel.text.integerValue == _lastCount.integerValue){
        
        
    }
    else{
        
        [self changeQuantity];
    }
    
    [self.shopCountLabel resignFirstResponder];
}

- (void)changeQuantity{
    
    BOOL isMinus = NO;
    
    NSInteger quantityChange = 0;
    
    if (_lastCount.integerValue < self.shopCountLabel.text.integerValue) {
        
        isMinus = NO;
        
        quantityChange = self.shopCountLabel.text.integerValue - _lastCount.integerValue;
    }
    else{
        
        isMinus = YES;
        
        quantityChange = _lastCount.integerValue - self.shopCountLabel.text.integerValue;
    }
    
    _lastCount = self.shopCountLabel.text;

    [_shopCarController changeShopCarGoodQuantityWithCell:self quantity:quantityChange isMinus:isMinus];
}



@end

//
//  ShopCarContentViewCell.m
//  WuMei
//
//  Created by qsit on 15/7/18.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "WMRefundGoodViewCell.h"

#import "UITableViewCell+addLineForCell.h"
#import "UITextField+Utilities.h"

#import "WMOrderInfo.h"
#import "WMRefundGoodModel.h"

@interface WMRefundGoodViewCell ()<UITextFieldDelegate>
/**选中的商品
 */
@property (copy,nonatomic) NSString *lastCount;
/**商品模型
 */
@property (strong,nonatomic) WMRefundGoodModel *goodViewModel;
@end

@implementation WMRefundGoodViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _shopIconImage.layer.cornerRadius = 4.0;
    
    _shopIconImage.sea_originContentMode = UIViewContentModeScaleAspectFit;
    
    _shopIconImage.layer.masksToBounds = YES;
    
    _shopIconImage.clipsToBounds = YES;
    
    _shopPriceLabel.font = [UIFont fontWithName:MainNumberFontName size:15.0];
    
    _shopNameLabel.font = [UIFont fontWithName:MainFontName size:13];
    
    _shopCountLabel.textColor = [UIColor blackColor];
    
    _shopCountLabel.textAlignment = NSTextAlignmentCenter;
    
    _shopCountLabel.keyboardType = UIKeyboardTypeNumberPad;
    
    _specInfoLabel.font = [UIFont fontWithName:MainFontName size:11.0];

    [_shopCountLabel setDefaultInputAccessoryViewWithTarget:self action:@selector(tapClearView)];
    
    _shopCountLabel.returnKeyType = UIReturnKeyDone;
    
    _shopCountLabel.delegate = self;
    
    [_shopSelecteButton addTarget:self action:@selector(selecteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_shopAddButton addTarget:self action:@selector(addShopItemCount:) forControlEvents:UIControlEventTouchUpInside];
    
    [_shopMinusButton addTarget:self action:@selector(minusShopItemCount:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addLineForTopWithFloat:4.0];
    
    [_goodQuantityView makeBorderWidth:_separatorLineWidth_ Color:_separatorLineColor_ CornerRadius:0.0];
    
    [_shopCountLabel makeBorderWidth:_separatorLineWidth_ Color:_separatorLineColor_ CornerRadius:0.0];
    
    [_shopSelecteButton setImage:[WMImageInitialization tickingIcon] forState:UIControlStateSelected];
    
    [_shopSelecteButton setImage:[WMImageInitialization untickIcon] forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapClearView) name:@"hiddenShowView" object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configureCellWithModel:(id)model{

    _goodViewModel = (WMRefundGoodModel *)model;
    
    if (_goodViewModel.isSelect) {
        
        [_shopSelecteButton setSelected:YES];
    }
    else{
        [_shopSelecteButton setSelected:NO];
    }
    
    _shopCountLabel.text = self.goodViewModel.refundFinalCount;
    
    _lastCount = self.goodViewModel.refundFinalCount;
    
    [_shopIconImage sea_setImageWithURL:_goodViewModel.image];
        
    _shopNameLabel.text = _goodViewModel.name;
    
    _specInfoLabel.text = _goodViewModel.specInfo;
        
    _shopPriceLabel.text = _goodViewModel.formatPrice;
}
/**增加商品数量
 */
- (void)addShopItemCount:(UIButton *)button{
    
    [_shopCountLabel resignFirstResponder];
    
    if (_shopCountLabel.text.integerValue == 99) {
        
        return;
    }
    
    if (_shopCountLabel.text.integerValue + 1 > self.goodViewModel.num.integerValue) {
        
        [[AppDelegate instance] alertMsg:@"购买量低于售后量，无法修改"];
        
        return;
    }

    _lastCount = [NSString stringWithFormat:@"%ld",(long)(_lastCount.integerValue + 1)];
    
    _goodViewModel.refundFinalCount = _lastCount;
    
    [self pushRefundChangeNotifi];
    
    _shopCountLabel.text = _lastCount;
}

/**减少商品数量
 */
- (void)minusShopItemCount:(UIButton *)button{
    
    [_shopCountLabel resignFirstResponder];
    
    NSInteger newQuantity = self.goodViewModel.refundFinalCount.integerValue - 1;
    
    if(newQuantity <= 0)
        
        return;
    
    _lastCount = [NSString stringWithFormat:@"%ld",(long)(_lastCount.integerValue - 1)];
    
    _goodViewModel.refundFinalCount = _lastCount;
    
    [self pushRefundChangeNotifi];
    
    _shopCountLabel.text = _lastCount;
}

/**选择按钮
 */
- (void)selecteButtonClick:(UIButton *)button{
    
    [_shopCountLabel resignFirstResponder];
    
    [button setSelected:!button.isSelected];
    
    if(button.isSelected){
        
        _goodViewModel.isSelect = YES;
    }
    else{
        _goodViewModel.isSelect = NO;
    }
    
    [self pushRefundChangeNotifi];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    return [textField textShouldChangeCharactersInRange:range replacementString:string limitedCount:2];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
//    NSIndexPath *indexPath = [_shopCarController.tableView indexPathForCell:self];
//    
//    [_shopCarController.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void)tapClearView{
    
    if (_shopCountLabel.text.integerValue > _goodViewModel.num.integerValue) {
        
        _shopCountLabel.text = [NSString stringWithFormat:@"%@",_lastCount];
        
        _goodViewModel.refundFinalCount = _lastCount;
        
        [[AppDelegate instance] alertMsg:@"购买量低于售后量，无法修改"];
        
        return;
    }
    
    if (self.shopCountLabel.text.integerValue == 0) {
        
        self.shopCountLabel.text = _lastCount;
    }
    else{
        
        _lastCount = self.shopCountLabel.text;
    }
    
    _goodViewModel.refundFinalCount = _lastCount;
    
    [self pushRefundChangeNotifi];
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

- (void)pushRefundChangeNotifi{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didChangeRefundMoney" object:nil];
}



@end

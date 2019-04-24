//
//  WMShopCarBottomView.m
//  WestMailDutyFee
//
//  Created by qsit on 15/8/27.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMShopCarBottomView.h"
#import "UIView+XQuickControl.h"
#import "WMImageInitialization.h"
#import "WMShopCarInfo.h"
@interface WMShopCarBottomView ()
/**购物车总价
 */
@property (copy,nonatomic) NSString *shopAllPrice;
/**商品购买数量
 */
@property (assign,nonatomic) NSInteger goodBuyQuantity;
/**节省的总金额
 */
@property (copy,nonatomic) NSString *discountPrice;
/**全选状态--网络状态的选中
 */
@property (assign,nonatomic) BOOL isSelectAll;

@end

@implementation WMShopCarBottomView

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame shopCarModel:(WMShopCarInfo *)model{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _shopAllPrice = model.subtotalPrice;
        
        _discountPrice = model.subtotalDiscount;
        
        _goodBuyQuantity = [model returnCurrentShopCarQuantity];
        
        _isSelectAll = [model returnCurrentShopCarSelectStatus];
        
        [self configureUI];
                
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

#pragma mark - 配置UI
- (void)configureUI{
    
    WeakSelf(self);
    
    CGFloat margin = 5.0;
    
    CGFloat labelHeight = (self.height - 3 * margin) / 2.0;
    
    CGFloat buttonWidth = 100.0;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width_, _separatorLineWidth_)];
    
    lineView.backgroundColor = WMRedColor;
    
    [self addSubview:lineView];
    
    _selectAllImageButton = [self addNoBackImageButtonWithFrame:CGRectMake(7, 9, 30, 30) tittle:nil backgroundImage:@"" action:^(UIButton *button) {
        
        [weakSelf.selectAllImageButton setSelected:!weakSelf.selectAllImageButton.selected];
        
        if (weakSelf.selectAllClick) {
            
            weakSelf.selectAllClick(weakSelf.selectAllImageButton.selected);
        }
    }];
    
    [_selectAllImageButton setImage:[WMImageInitialization tickingIcon] forState:UIControlStateSelected];
    
    [_selectAllImageButton setImage:[WMImageInitialization untickIcon] forState:UIControlStateNormal];
    
    [_selectAllImageButton setSelected:_isSelectAll];
    
    _selectAllButton = [self addSystemButtonWithFrame:CGRectMake(38, 9, 32, 30) tittle:@"全选" action:^(UIButton *button) {
        
        [weakSelf.selectAllImageButton setSelected:!weakSelf.selectAllImageButton.selected];

        if (weakSelf.selectAllClick) {
            
            weakSelf.selectAllClick(weakSelf.selectAllImageButton.selected);
        }
    }];
    
    _selectAllButton.titleLabel.font = [UIFont fontWithName:MainFontName size:14.0];
    
    _selectAllButton.backgroundColor = [UIColor clearColor];
    
    [_selectAllButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    _payButton = [self addSystemButtonWithFrame:CGRectMake(_width_ - buttonWidth,0, buttonWidth, self.height) tittle:[NSString stringWithFormat:@"结算(%ld)",(long)_goodBuyQuantity] action:^(UIButton *button) {
        
        if (weakSelf.payButtonClick) {
            
            weakSelf.payButtonClick(button);
        }
    }];
    
    _payButton.backgroundColor = WMPriceColor;
        
    _payButton.titleLabel.font = [UIFont fontWithName:MainFontName size:18.0];
    
    [_payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    NSString *promotionPrice = [NSString stringWithFormat:@"节省:%@",_discountPrice];
    
    NSString *allPrice = [NSString stringWithFormat:@"合计:%@\n%@",_shopAllPrice,promotionPrice];
    
    NSMutableAttributedString *totalPriceString = [[NSMutableAttributedString alloc] initWithString:allPrice];
    
    [totalPriceString addAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont fontWithName:MainFontName size:15.0]} range:NSMakeRange(0, 3)];
    
    [totalPriceString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:MainFontName size:16.0],NSForegroundColorAttributeName:WMRedColor} range:NSMakeRange(3, _shopAllPrice.length)];
    
    [totalPriceString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:MainFontName size:13.0],NSForegroundColorAttributeName:MainTextColor} range:[allPrice rangeOfString:promotionPrice]];
    
    _priceLabel = [self addLableWithFrame:CGRectMake(_selectAllButton.right + 6.0, 0.0, _width_ - 64 - buttonWidth - 3 * WMShopCarBottomRightMargin, self.height) attrText:totalPriceString];
    
    _priceLabel.textAlignment = NSTextAlignmentLeft;
    
    _priceLabel.numberOfLines = 0;
    
    _promotionLabel = [self addLableWithFrame:CGRectMake(_priceLabel.left, _priceLabel.bottom + margin, _priceLabel.width, labelHeight) text:[NSString stringWithFormat:@"节省:%@",_discountPrice]];
    
    _promotionLabel.textAlignment = NSTextAlignmentRight;
    
    _promotionLabel.textColor = MainTextColor;
    
    _promotionLabel.font = [UIFont fontWithName:MainFontName size:13.0];
    
    _promotionLabel.hidden = YES;
    
    CGFloat deleteButtonWidth = 60.0;
    
    CGFloat deleteButtonHeight = 35.0;
    
    _deleteButton = [self addSystemButtonWithFrame:CGRectMake(_width_ - deleteButtonWidth - WMShopCarBottomRightMargin, (self.height - deleteButtonHeight) / 2.0, deleteButtonWidth, deleteButtonHeight) tittle:@"删除" action:^(UIButton *button) {
        
        if (weakSelf.deleteButtonClick) {
            
            weakSelf.deleteButtonClick(button);
        }
    }];
    
    [_deleteButton makeBorderWidth:1.0 Color:WMRedColor CornerRadius:3.0];
    
    [_deleteButton setTitleColor:WMRedColor forState:UIControlStateNormal];
    
    [_deleteButton setBackgroundColor:[UIColor whiteColor]];
    
    _deleteButton.hidden = YES;
}

/**更改总价/节省价/购买数量
 */
- (void)changeBuyInfoWithShopCarInfo:(WMShopCarInfo *)info{
    
    _shopAllPrice = info.subtotalPrice;
    
    _discountPrice = info.subtotalDiscount;
    
    _goodBuyQuantity = [info returnCurrentShopCarQuantity];
    
    NSString *promotionPrice = [NSString stringWithFormat:@"节省:%@",_discountPrice];
    
    NSString *allPrice = [NSString stringWithFormat:@"合计:%@\n%@",_shopAllPrice,promotionPrice];
    
    NSMutableAttributedString *totalPriceString = [[NSMutableAttributedString alloc] initWithString:allPrice];
    
    [totalPriceString addAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont fontWithName:MainFontName size:15.0]} range:NSMakeRange(0, 3)];
    
    [totalPriceString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:MainFontName size:16.0],NSForegroundColorAttributeName:WMRedColor} range:NSMakeRange(3, _shopAllPrice.length)];
    
    [totalPriceString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:MainFontName size:13.0],NSForegroundColorAttributeName:MainTextColor} range:[allPrice rangeOfString:promotionPrice]];
        
    _priceLabel.attributedText = totalPriceString;
    
    _promotionLabel.text = [NSString stringWithFormat:@"节省:%@",_discountPrice];
    
    [_payButton setTitle:[NSString stringWithFormat:@"结算(%ld)",(long)_goodBuyQuantity] forState:UIControlStateNormal];
}

- (void)setIsEdit:(BOOL)isEdit{
    
    _isEdit = isEdit;
    
    _promotionLabel.hidden = isEdit;
    
    _priceLabel.hidden = isEdit;
    
    _payButton.hidden = isEdit;
    
    _deleteButton.hidden = !isEdit;
}










@end

//
//  ConfirmOrderBottomView.m
//  WuMei
//
//  Created by qsit on 15/7/27.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "ConfirmOrderBottomView.h"

#import "UIView+Screen.h"
#import "UIView+XQuickStyle.h"
#import "UIView+XQuickControl.h"

@interface ConfirmOrderBottomView ()
/**订单价格
 */
@property (copy,nonatomic) NSString *orderPrice;
/**创建订单按钮
 */
@property (strong,nonatomic) UIButton *createOrderButton;
/**价格文本框
 */
@property (strong,nonatomic) UILabel *priceLabel;
@end

@implementation ConfirmOrderBottomView

- (instancetype)initWithOrderPrice:(NSString *)price frame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _orderPrice = price;
        
        [self layOutUI];
    }
    return self;
}

- (void)layOutUI{
    
    WeakSelf(self);
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width_, _separatorLineWidth_)];
    
    lineView.backgroundColor = WMButtonBackgroundColor;
    
    [self addSubview:lineView];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (self.height - 21) / 2.0, 180, 21)];
    
    _priceLabel.attributedText = [self createCommonAttrWith:@"实付款:" andContent:_orderPrice];
    
    [self addSubview:_priceLabel];
    
    _createOrderButton = [self addSystemButtonWithFrame:CGRectMake(_width_ - 100, 0, 100, self.height) tittle:@"提交订单" action:^(UIButton *button) {
        
        if (weakSelf.createOrderButtonClick) {
            
            weakSelf.createOrderButtonClick(button);
        }
    }];
    
    _createOrderButton.backgroundColor = WMButtonBackgroundColor;
    
    [_createOrderButton setTitleColor:WMButtonTitleColor forState:UIControlStateNormal];
    
    _createOrderButton.titleLabel.font = [UIFont fontWithName:MainFontName size:17];
}
- (void)changePrice:(NSString *)price{
    
    _priceLabel.attributedText = [self createCommonAttrWith:@"实付款:" andContent:price];
}
- (NSAttributedString *)createCommonAttrWith:(NSString *)title andContent:(NSString *)content{
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",title,content]];
    
    [attStr addAttributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor],
                            NSFontAttributeName:[UIFont fontWithName:MainFontName size:17]} range:[attStr.string rangeOfString:title]];
    
    [attStr addAttributes:@{NSForegroundColorAttributeName:WMPriceColor,
                            NSFontAttributeName:[UIFont fontWithName:MainFontName size:17]} range:[attStr.string rangeOfString:content]];
    return attStr;
}

@end

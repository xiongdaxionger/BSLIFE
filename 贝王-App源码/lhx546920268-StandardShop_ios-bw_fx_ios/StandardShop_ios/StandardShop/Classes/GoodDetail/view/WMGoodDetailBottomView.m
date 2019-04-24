//
//  GoodDetailBottomView.m
//  WestMailDutyFee
//
//  Created by qsit on 15/8/27.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMGoodDetailBottomView.h"

#import "WMShopCarOperation.h"
#import "WMUserInfo.h"

#import "UIView+XQuickControl.h"

@interface WMGoodDetailBottomView ()
/**货架图片按钮
 */
@property (strong,nonatomic) UIButton *addFavButton;
/**购物车图片按钮
 */
@property (strong,nonatomic) UIButton *shopCarButton;
/**客服图片按钮
 */
@property (strong,nonatomic) UIButton *helpButton;

@end

@implementation WMGoodDetailBottomView

/**商品详情底部视图
 */
- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor colorFromHexadecimal:@"d3d3d4"];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeGoodQuantity:) name:WMShopCarAddSuccessNotifi object:nil];
    }
    
    return self;
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**商品详情底部
 */
- (void)layOutGoodBottomView{
    
    WeakSelf(self);
    
    CGFloat imageButtonWidth = 53.0;
    
    CGFloat buttonWidth = _width_ - 3 * imageButtonWidth;
    
    _helpButton = [self addNoBackImageButtonWithFrame:CGRectMake(0.0, 0.5, imageButtonWidth, WMGoodDetailBottomViewHeight - 0.5) tittle:@"" backgroundImage:@"good_help" action:^(UIButton *button) {
        
        if (weakSelf.customServiceAction) {
            
            weakSelf.customServiceAction(button);
        }
    }];
        
    _helpButton.backgroundColor = [UIColor whiteColor];
    
    _addFavButton = [self addNoBackImageButtonWithFrame:CGRectMake(_helpButton.right + 0.5, 0.5, imageButtonWidth - 0.5, WMGoodDetailBottomViewHeight - 0.5) tittle:@"" backgroundImage:self.goodIsFav ? @"good_fav" : @"good_no_fav" action:^(UIButton *button) {
        
        if (weakSelf.addFavButtonAction) {
            
            weakSelf.addFavButtonAction(button);
        }
    }];
    
    _addFavButton.backgroundColor = [UIColor whiteColor];
    
    _shopCarButton = [self addNoBackImageButtonWithFrame:CGRectMake(_addFavButton.right + 0.5, 0.5, imageButtonWidth, WMGoodDetailBottomViewHeight - 0.5) tittle:@"" backgroundImage:@"good_shop_car" action:^(UIButton *button) {
        
        if (weakSelf.shopCarButtonAction) {
            
            weakSelf.shopCarButtonAction(button);
        }
    }];
    
    _shopCarButton.backgroundColor = [UIColor whiteColor];
    
    _badgeView = [[SeaNumberBadge alloc] initWithFrame:CGRectMake(_shopCarButton.width - _badgeViewWidth_ + 8, - 8, _badgeViewWidth_, _badgeViewHeight_)];
    
    _badgeView.value = _quantity;
    
    _badgeView.userInteractionEnabled = NO;
    
    [_shopCarButton addSubview:_badgeView];
    
    _buttonView = [[WMSpecInfoSelectFooterView alloc] initWithFrame:CGRectMake(_shopCarButton.right, 0, buttonWidth, WMGoodDetailBottomViewHeight)];
    
    _buttonView.buttonListArr = self.buttonPageList;

    [_buttonView configureUI];
    
    [self addSubview:_buttonView];
}

- (void)changeGoodQuantity:(NSNotification *)notifi{
    
    _badgeView.value = [WMUserInfo displayShopcarCount];
}

/**更新UI
 */
- (void)updateUI{
    
    [self.addFavButton setImage:[UIImage imageNamed:self.goodIsFav ? @"good_fav" : @"good_no_fav"] forState:UIControlStateNormal];
}








@end

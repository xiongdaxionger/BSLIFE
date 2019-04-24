//
//  WMSpecInfoSelectHeaderView.m
//  StandardShop
//
//  Created by mac on 16/6/12.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMSpecInfoSelectHeaderView.h"

@interface WMSpecInfoSelectHeaderView ()
/**货品图片
 */
@property (strong,nonatomic) UIImageView *productImageView;
/**货品价格
 */
@property (strong,nonatomic) UILabel *priceLabel;
/**货品编号
 */
@property (strong,nonatomic) UILabel *bnCodeLabel;
/**商品名称
 */
@property (strong,nonatomic) UILabel *nameLabel;
@end

@implementation WMSpecInfoSelectHeaderView
/**初始化
 */
- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}
/**初始化界面
 */
- (void)configureUI{
    
    CGFloat margin = 10.0;
    
    CGFloat imageSize = 95.0;
    
    CGFloat labelHeight = 21.0;
    
    CGFloat buttonSize = 30.0;
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 3 * margin, _width_, self.height - 3 * margin)];
    
    backView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:backView];
    
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(_width_ - buttonSize - margin / 2.0, margin / 2.0, buttonSize, buttonSize)];
    
    [closeButton setImage:[UIImage imageNamed:@"close_dialog"] forState:UIControlStateNormal];
    
    [closeButton addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [backView addSubview:closeButton];

    UIView *imageBackView = [[UIView alloc] initWithFrame:CGRectMake(margin, self.height - margin - imageSize, imageSize, imageSize)];
    
    imageBackView.clipsToBounds = YES;
    
    imageBackView.backgroundColor = [UIColor whiteColor];
    
    _productImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageSize, imageSize)];
    
    [_productImageView sea_setImageWithURL:_productImage];
    
    [imageBackView addSubview:_productImageView];
    
    [imageBackView makeBorderWidth:_separatorLineWidth_ Color:_separatorLineColor_ CornerRadius:3.0];
    
    [self addSubview:imageBackView];
    
    CGFloat labelWidth = _width_ - margin * 3 - imageBackView.width;
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageBackView.right + margin, self.height - margin - labelHeight, 30, labelHeight)];
    
    textLabel.textColor = MainTextColor;
    
    textLabel.font = [UIFont fontWithName:MainFontName size:13.0];
    
    textLabel.text = @"已选:";
    
    [self addSubview:textLabel];
    
    _bnCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(textLabel.right, self.height - margin - labelHeight, labelWidth - textLabel.width, labelHeight)];
    
    _bnCodeLabel.attributedText = self.specInfoAttrString;
    
    _bnCodeLabel.font = [UIFont fontWithName:MainFontName size:13.0];
    
    _bnCodeLabel.textAlignment = NSTextAlignmentLeft;
    
    [self addSubview:_bnCodeLabel];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageBackView.right + margin, _bnCodeLabel.top - labelHeight, labelWidth, labelHeight)];
    
    _priceLabel.textAlignment = NSTextAlignmentLeft;
    
    _priceLabel.attributedText = [self returnPriceAndStoreStringWithPrice:_productPrice store:_productStore];
    
    [self addSubview:_priceLabel];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_priceLabel.left, 5.0, labelWidth - closeButton.width, 21.0)];
    
    _nameLabel.font = [UIFont fontWithName:MainFontName size:15.0];
    
    _nameLabel.text = _productName;
    
    [backView addSubview:_nameLabel];
    
    self.height = imageBackView.bottom + margin;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - _separatorLineWidth_, _width_, _separatorLineWidth_)];
    
    lineView.backgroundColor = _separatorLineColor_;
    
    [self addSubview:lineView];
}

- (void)closeButtonAction{
    
    if (self.closeSpecInfoSelect) {
        
        self.closeSpecInfoSelect();
    }
}

- (void)updateUI{
    
    [_productImageView sea_setImageWithURL:_productImage];
    
    _priceLabel.attributedText = [self returnPriceAndStoreStringWithPrice:_productPrice store:_productStore];

    _bnCodeLabel.attributedText = self.specInfoAttrString;
}

- (NSAttributedString *)returnPriceAndStoreStringWithPrice:(NSString *)price store:(NSString *)store{
    
    store = [NSString isEmpty:store] ? @"" : store;
    
    if (self.type == GoodPromotionTypeGift) {
        
        price = [NSString stringWithFormat:@"兑换所需积分:%@",price];
    }
    else{
        
        price = formatStringPrice(price);
    }
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",price,store]];
    
    [attrString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:18.0],NSForegroundColorAttributeName:WMRedColor} range:NSMakeRange(0, price.length)];
    
    [attrString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:MainFontName size:14.0],NSForegroundColorAttributeName:MainTextColor} range:NSMakeRange(price.length, store.length + 1)];
    
    return attrString;
}




@end

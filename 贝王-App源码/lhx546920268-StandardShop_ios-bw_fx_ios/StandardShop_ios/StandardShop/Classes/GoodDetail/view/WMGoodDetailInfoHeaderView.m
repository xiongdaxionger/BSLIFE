//
//  GoodDetailTableHeaderView.m
//  WuMei
//
//  Created by qsit on 15/8/5.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "WMGoodDetailInfoHeaderView.h"
#import "WMGoodDetailBannerView.h"
#import "UIView+XQuickControl.h"
#import "WMCountDownView.h"

#import "WMGoodDetailInfo.h"
#import "WMGoodDetailPrepareInfo.h"
#import "WMGoodDetailGiftInfo.h"
#import "WMServerTimeOperation.h"
#import "WMShopCarOperation.h"


@interface WMGoodDetailInfoHeaderView ()<WMCountDownViewDelegate>
/**商品信息模型
 */
@property (strong,nonatomic) WMGoodDetailInfo *goodDetailInfo;
/**倒计时
 */
@property (strong,nonatomic) WMCountDownView *countDownView;
/**商品轮播视图
 */
@property (strong,nonatomic) WMGoodDetailBannerView *bannerView;
/**价格视图
 */
@property (strong,nonatomic) UIView *priceView;
/**商品价格文本
 */
@property (strong,nonatomic) UILabel *priceLabel;
/**最低价格文本
 */
@property (strong,nonatomic) UILabel *minPriceLabel;
/**商品名称
 */
@property (strong,nonatomic) UILabel *goodNameLabel;
@end

@implementation WMGoodDetailInfoHeaderView

- (instancetype)initWithGoodInfo:(WMGoodDetailInfo *)info{
    
    self = [super init];
    
    if (self) {
        
        self.goodDetailInfo = info;
        
        [self configureGoodInfoUI];
    }
    return self;
}

- (void)dealloc{
    
    [_countDownView stopTimer];
}

#pragma mark - 设置商品信息界面
- (void)configureGoodInfoUI{
        
    _bannerView = [[WMGoodDetailBannerView alloc] initWithImageArr:_goodDetailInfo.goodImagesArr];
    
    [_bannerView setFrame:CGRectMake(0, 0, _width_, _width_)];
    
    [_bannerView setDraggingLastPage:^{
       
    }];
    
    [self addSubview:_bannerView];
    
    CGFloat margin = 6.0;
    
    CGFloat nameHeight = [_goodDetailInfo.goodName stringSizeWithFont:[UIFont fontWithName:MainFontName size:16.0] contraintWith:_width_ - 2 * margin].height;
    
    _goodNameLabel = [self addLableWithFrame:CGRectMake(margin, _bannerView.bottom + margin, _width_ - 2 * margin, nameHeight) text:_goodDetailInfo.goodName];
    
    _goodNameLabel.numberOfLines = 0;
    
    _goodNameLabel.font = [UIFont fontWithName:MainFontName size:16];
    
    _goodNameLabel.textColor = [UIColor blackColor];
    
    _priceView = [[UIView alloc] initWithFrame:CGRectMake(0, _goodNameLabel.bottom + 5.0, _width_, 65.0)];
    
    CGFloat priceLabelHeight = 25.0;
    
    CGFloat priceLabelY = 0.0;
    
    UIColor *priceColor = WMPriceColor;

    if ([NSString isEmpty:_goodDetailInfo.goodMarketPrice]) {
        
        priceLabelHeight = 25.0;
    }
    else{
        
        if (self.goodDetailInfo.type == GoodPromotionTypeGift) {
            
            priceLabelHeight = 25.0;
        }
        else{
            
            priceLabelHeight = 65.0;
        }
    }
    
    
    if (_goodDetailInfo.type == GoodPromotionTypePrepare) {
        
        priceLabelY = (_priceView.height - priceLabelHeight) / 2.0;
    }
    else{
        
        if (_goodDetailInfo.type == GoodPromotionTypeNothing) {
            
            priceLabelY = [NSString isEmpty:self.goodDetailInfo.goodMinPrice] ? (_priceView.height - priceLabelHeight) / 2.0 : margin;
            
        }
        else{
            
            priceLabelY = margin;
        }
    }
    
    _priceLabel = [_priceView addLableWithFrame:CGRectMake(margin, priceLabelY, _width_ - 2 * margin, priceLabelHeight) attrText:[self returnAttrStringColor:[UIColor blackColor] priceColor:priceColor]];
    
    _priceLabel.numberOfLines = 0;
    
    if (self.goodDetailInfo.type == GoodPromotionTypeSecondKill || self.goodDetailInfo.type == GoodPromotionTypeGift) {
        
        if (self.goodDetailInfo.type == GoodPromotionTypeSecondKill) {
            
            _countDownView = [[WMCountDownView alloc] initWithFrame:CGRectMake(margin, _priceLabel.bottom + 3.0, _width_ - 2 * margin, 28)];
            
            _countDownView.delegate = self;
            
            _countDownView.pointTextColor = [UIColor blackColor];
            
            _countDownView.numberBackgroundColor = [UIColor colorWithWhite:0.3 alpha:1.0];
                        
            [_countDownView initlization];
            
            _countDownView.contentAlignment = WMCountDownContentAlignmentLeft;
            
            [_countDownView setIcon:[UIImage imageNamed:@"count_down_icon"]];
            
            [_countDownView.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            [self countDownViewDidEnd:_countDownView];
            
            [_priceView addSubview:_countDownView];
            
            _priceView.height = _countDownView.bottom + margin;
        }
        else{
            
            UIButton *giftMessage = [[UIButton alloc] initWithFrame:CGRectMake(margin, _priceLabel.bottom + 3.0, _width_ - 2 * margin, 28.0)];
            
            [giftMessage setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            giftMessage.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            
            giftMessage.titleLabel.font = [UIFont fontWithName:MainFontName size:14.0];
            
            [giftMessage setTitleColor:WMMarketPriceColor forState:UIControlStateNormal];

            if (self.goodDetailInfo.giftMessageInfo.canExchangeGift) {
                
                [giftMessage setTitle:[NSString stringWithFormat:@"起止时间%@至%@",self.goodDetailInfo.giftMessageInfo.beginTime,self.goodDetailInfo.giftMessageInfo.endTime] forState:UIControlStateNormal];
            }
            else{
                
                [giftMessage setTitle:self.goodDetailInfo.giftMessageInfo.notExchangeReason forState:UIControlStateNormal];
            }
            
            giftMessage.titleLabel.adjustsFontSizeToFitWidth = YES;
            
            [_priceView addSubview:giftMessage];
            
            _priceView.height = giftMessage.bottom + margin;
        }
    }
    
    if (self.goodDetailInfo.type == GoodPromotionTypeNothing && ![NSString isEmpty:self.goodDetailInfo.goodMinPrice]) {
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self.goodDetailInfo.goodMinPriceName];
        
        [attrString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:MainFontName size:14.0]} range:NSMakeRange(0, self.goodDetailInfo.goodMinPriceName.length)];
        
        [attrString appendAttributedString:[WMPriceOperation formatPrice:self.goodDetailInfo.goodMinPrice font:[UIFont fontWithName:MainFontName size:14.0]]];
        
        _minPriceLabel = [_priceView addLableWithFrame:CGRectMake(margin, _priceLabel.bottom, _priceLabel.width, 21.0) attrText:attrString];
        
        _minPriceLabel.textColor = WMMarketPriceColor;
        
        _priceView.height = _minPriceLabel.bottom + margin;
    }
    

    [self addSubview:_priceView];
    
    self.height = _priceView.bottom;
}

/**特卖是否已经开始
 */
- (BOOL)isSecondKillBegan
{
    return self.goodDetailInfo.secondKillInfo.secondKillBeginTime.integerValue <= [WMServerTimeOperation sharedInstance].time;
}

/**特卖是否已结束
 */
- (BOOL)isSecondKillEnded
{
    return self.goodDetailInfo.secondKillInfo.secondKillEndTime.integerValue <= [WMServerTimeOperation sharedInstance].time;
}

#pragma mark- WMCountDownView delegate

- (void)countDownViewDidEnd:(WMCountDownView *)view
{
    if(![self isSecondKillBegan])
    {
        _countDownView.text = @" 距开始";
        self.countDownView.timeInterval = self.goodDetailInfo.secondKillInfo.secondKillBeginTime.integerValue;
        
        [self.countDownView startTimer];
    }
    else if(![self isSecondKillEnded])
    {
        _countDownView.text = @" 距结束";
        self.countDownView.timeInterval = self.goodDetailInfo.secondKillInfo.secondKillEndTime.integerValue;
        
        [self.countDownView startTimer];
    }
    else
    {
        self.countDownView.timeInterval = 0;
        
        [self.countDownView timerEnd];
    }
}

- (void)updateUI{
    
    [self.goodNameLabel removeFromSuperview];
    
    [self.priceView removeFromSuperview];
    
    [self.countDownView removeFromSuperview];
    
    [self.priceLabel removeFromSuperview];
    
    [self.minPriceLabel removeFromSuperview];
    
    [self.bannerView removeFromSuperview];
    
    [self configureGoodInfoUI];
}

- (NSAttributedString *)returnAttrStringColor:(UIColor *)priceLabelColor priceColor:(UIColor *)priceColor{
    
    NSMutableAttributedString *attrString;
    
    if (self.goodDetailInfo.type == GoodPromotionTypeGift) {
        
        attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"兑换所需积分:%@",_goodDetailInfo.giftMessageInfo.consumeScore]];
        
        [attrString addAttributes:@{NSForegroundColorAttributeName:priceLabelColor} range:NSMakeRange(0, attrString.string.length)];
        
        [attrString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:MainFontName size:15.0]} range:NSMakeRange(0, attrString.string.length)];
    }
    else{
        
        attrString = [[NSMutableAttributedString alloc] initWithString:_goodDetailInfo.goodShowPriceName];
        
        [attrString appendAttributedString:[WMPriceOperation formatPriceConbinationWithPrice:_goodDetailInfo.goodShowPrice priceFont:[UIFont boldSystemFontOfSize:22.0] marketPrice:_goodDetailInfo.goodMarketPrice marketPriceFontSize:14.0]];
        
        NSMutableAttributedString *marketPrice = [[NSMutableAttributedString alloc] initWithString:[NSString isEmpty:_goodDetailInfo.goodMarketName] ? @"" : [NSString stringWithFormat:@"\n%@",_goodDetailInfo.goodMarketName]];
        
        [marketPrice addAttributes:@{NSFontAttributeName:[UIFont fontWithName:MainFontName size:14.0],NSForegroundColorAttributeName:WMMarketPriceColor} range:NSMakeRange(0, marketPrice.string.length)];
        
        [attrString insertAttributedString:marketPrice atIndex:_goodDetailInfo.goodShowPriceName.length + _goodDetailInfo.goodShowPrice.length];
        
        if(![NSString isEmpty:_goodDetailInfo.goodFxName] && ![NSString isEmpty:_goodDetailInfo.goodFxPrice]){
             NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"   %@%@", _goodDetailInfo.goodFxName, _goodDetailInfo.goodFxPrice]];
           [attr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:MainFontName size:14.0],NSForegroundColorAttributeName:WMMarketPriceColor} range:NSMakeRange(0, attr.string.length)];
            [attrString appendAttributedString:attr];
        }
        
        if (![NSString isEmpty:_goodDetailInfo.goodMarketName]) {
            
            NSMutableParagraphStyle *paragarphStyle = [[NSMutableParagraphStyle alloc] init];
            
            [paragarphStyle setLineSpacing:8.0];
            
            [attrString addAttributes:@{NSParagraphStyleAttributeName:paragarphStyle} range:NSMakeRange(0, attrString.string.length)];
        }
        
        if ([priceColor isEqualToColor:[UIColor whiteColor]]) {
            
            [attrString addAttributes:@{NSForegroundColorAttributeName:priceColor} range:NSMakeRange(0, attrString.string.length)];
        }
        else{
            
            [attrString addAttributes:@{NSForegroundColorAttributeName:priceLabelColor} range:NSMakeRange(0, _goodDetailInfo.goodShowPriceName.length)];
            
        }
        
        [attrString addAttributes:@{NSForegroundColorAttributeName:priceColor} range:NSMakeRange(_goodDetailInfo.goodShowPriceName.length, _goodDetailInfo.goodShowPrice.length)];
    }
    
    return attrString;
}

@end

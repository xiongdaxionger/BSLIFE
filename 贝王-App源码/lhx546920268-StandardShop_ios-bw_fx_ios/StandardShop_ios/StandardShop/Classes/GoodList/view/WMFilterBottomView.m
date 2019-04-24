//
//  WMFilterBottomView.m
//  StandardFenXiao
//
//  Created by mac on 16/1/8.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMFilterBottomView.h"

#import "UIView+XQuickControl.h"

@interface WMFilterBottomView ()
/**商品数量文本
 */
@property (strong,nonatomic) UILabel *goodCountLabel;
@end

@implementation WMFilterBottomView

#pragma mark - 初始化
- (instancetype)initWithGoodCount:(int)goodCount{
    
    self = [super init];
    
    if (self) {
        
        self.goodCount = goodCount;
    }
    
    return self;
}

#pragma mark - 配置UI

- (void)layoutSubviews
{
    
    WeakSelf(self);
    
    CGFloat buttonWidth = self.width / 2.0;
    
    self.goodCountLabel = [self addLableWithFrame:CGRectMake(0, 0, buttonWidth, 49.0) attrText:[self createAttrString]];
    self.goodCountLabel.adjustsFontSizeToFitWidth = YES;
    self.goodCountLabel.textAlignment = NSTextAlignmentCenter;
    
    UIButton *resetButton = [self addSystemButtonWithFrame:CGRectMake(self.goodCountLabel.right, 0, buttonWidth / 2.0, 49.0) tittle:@"重置" action:^(UIButton *button) {
        
        !weakSelf.resetButtonClick ? : weakSelf.resetButtonClick(button);
    }];
    
    [resetButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    resetButton.backgroundColor = _SeaViewControllerBackgroundColor_;
    
    UIButton *commitButton = [self addSystemButtonWithFrame:CGRectMake(resetButton.right, 0, buttonWidth / 2.0, 49.0) tittle:@"完成" action:^(UIButton *button) {
        
        !weakSelf.commitButtonClick ? : weakSelf.commitButtonClick(button);
    }];
    
    [commitButton setTitleColor:WMButtonTitleColor forState:UIControlStateNormal];
    
    commitButton.backgroundColor = WMButtonBackgroundColor;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, _separatorLineWidth_)];
    
    lineView.backgroundColor = _SeaViewControllerBackgroundColor_;
    
    [self addSubview:lineView];
}

- (void)changeFilterGoodCountWith:(int)goodCount{
    
    self.goodCount = goodCount;
    
    self.goodCountLabel.attributedText = [self createAttrString];
}

- (NSAttributedString *)createAttrString{
    
    NSString *goodStr = [NSString stringWithFormat:@"%d",self.goodCount];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%@件商品",goodStr]];
    
    [attrString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:MainFontName size:15.0]} range:NSMakeRange(0, attrString.string.length)];
    
    [attrString addAttributes:@{NSForegroundColorAttributeName:WMPriceColor} range:NSMakeRange(1, goodStr.length)];
    
    return attrString;
}


@end

//
//  WMCommitRefundGoodBottomView.m
//  WanShoes
//
//  Created by mac on 16/4/8.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMCommitRefundGoodBottomView.h"

@implementation WMCommitRefundGoodBottomView


- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        
        self.isAgree = YES;
        
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0.0, _width_, 21)];
        
        infoLabel.text = @"最多上传3张，图片不超过2M,格式为jpg、jpeg、png";
        
        infoLabel.font = [UIFont fontWithName:MainFontName size:13.0];
        
        [self addSubview:infoLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, infoLabel.bottom + 3.0, _width_, _separatorLineWidth_)];
        
        [lineView setBackgroundColor:_separatorLineColor_];
        
        [self addSubview:lineView];
        
        UIButton *agreeButton = [[UIButton alloc] initWithFrame:CGRectMake(5.0, lineView.bottom + 3.0, 70, 30)];
        
        [agreeButton setImage:[WMImageInitialization tickingIcon] forState:UIControlStateNormal];
        
        [agreeButton setTitle:@"同意" forState:UIControlStateNormal];
        
        [agreeButton addTarget:self action:@selector(changeAgree:) forControlEvents:UIControlEventTouchUpInside];
        
        [agreeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        agreeButton.titleLabel.font = [UIFont fontWithName:MainFontName size:15.0];
        
        [self addSubview:agreeButton];
        
        UIButton *protocolButton = [[UIButton alloc] initWithFrame:CGRectMake(agreeButton.right - 8.0, lineView.bottom + 8.0, 120, 21)];
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"售后服务须知"];
        
        [attrString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:MainFontName size:14.0],NSForegroundColorAttributeName:WMPriceColor,NSUnderlineStyleAttributeName:@(1.0)} range:NSMakeRange(0, attrString.string.length)];
        
        protocolButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        [protocolButton setAttributedTitle:attrString forState:UIControlStateNormal];
        
        [protocolButton addTarget:self action:@selector(protocolButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:protocolButton];
        
        self.height = protocolButton.bottom + 15.0;
    }
    
    return self;
}

- (void)changeAgree:(UIButton *)button{
    
    _isAgree = !_isAgree;
    
    [button setImage:_isAgree ? [WMImageInitialization tickingIcon] : [WMImageInitialization untickIcon] forState:UIControlStateNormal];
}

- (void)protocolButtonClick{
    
    if (self.actionCallBack) {
        
        self.actionCallBack();
    }
}



@end

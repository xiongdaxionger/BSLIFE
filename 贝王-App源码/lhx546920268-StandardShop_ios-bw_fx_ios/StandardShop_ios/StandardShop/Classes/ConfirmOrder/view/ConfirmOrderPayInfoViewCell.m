//
//  ConfirmOrderPayInfoViewCell.m
//  WuMei
//
//  Created by qsit on 15/7/27.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//


#import "ConfirmOrderPayInfoViewCell.h"

#import "WMPayMethodModel.h"

@interface ConfirmOrderPayInfoViewCell ()

@end

@implementation ConfirmOrderPayInfoViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _orderPayInfoImage.clipsToBounds = YES;
    
    _orderPayInfoImage.sea_originContentMode = UIViewContentModeScaleAspectFit;
    
    _orderPayInfoName.font = [UIFont fontWithName:MainFontName size:15];
}

- (void)configureCellWithModel:(id)model{

    _orderPaySelect.enabled = NO;
    
    WMPayMethodModel *viewModel;
    
    if ([model isKindOfClass:[NSDictionary class]]) {
        
        viewModel = [model objectForKey:@"model"];
        
        NSString *depositMoney = [NSString stringWithFormat:@"(余额:%@)",[model sea_stringForKey:@"depositMoney"]];
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",viewModel.payInfoName,depositMoney]];
        
        [attrString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:MainFontName size:13.0],NSForegroundColorAttributeName:WMRedColor} range:[attrString.string rangeOfString:depositMoney]];
        
        [attrString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:MainFontName size:15.0]} range:[attrString.string rangeOfString:viewModel.payInfoName]];
        
        _orderPayInfoName.attributedText = attrString;
    }
    else{
        
        viewModel = (WMPayMethodModel *)model;
        
        _orderPayInfoName.text = viewModel.payInfoName;
    }
    
    [_orderPayInfoImage sea_setImageWithURL:viewModel.payInfoIcon];
    
    if (viewModel.payIsSelect) {
        
        [_orderPaySelect setBackgroundImage:[WMImageInitialization tickingIcon] forState:UIControlStateDisabled];
    }
    else{
        
        [_orderPaySelect setBackgroundImage:[WMImageInitialization untickIcon] forState:UIControlStateDisabled];
    }
}





@end

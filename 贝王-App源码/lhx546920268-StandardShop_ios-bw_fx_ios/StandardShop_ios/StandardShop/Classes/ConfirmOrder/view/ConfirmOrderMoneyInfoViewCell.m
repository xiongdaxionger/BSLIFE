//
//  ConfirmOrderMoneyInfoViewCell.m
//  WuMei
//
//  Created by qsit on 15/7/27.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "ConfirmOrderMoneyInfoViewCell.h"

#import "WMConfirmOrderInfo.h"
#import "WMShippingMethodInfo.h"
#import "WMOrderdetailInfo.h"
@implementation ConfirmOrderMoneyInfoViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)configureCellWithModel:(id)model{
    
    if ([model isKindOfClass:[WMConfirmOrderInfo class]]) {
        
        WMConfirmOrderInfo *viewModel = (WMConfirmOrderInfo *)model;
        
        self.orderPriceInfo.attributedText = viewModel.orderTitleAttrString;
        
        self.orderPriceContent.attributedText = viewModel.orderPriceAttrString;
    }
    else if ([model isKindOfClass:[WMOrderDetailInfo class]]){
        
        WMOrderDetailInfo *viewModel = (WMOrderDetailInfo *)model;
        
        self.orderPriceContent.attributedText = viewModel.orderPriceAttrString;
        
        self.orderPriceInfo.attributedText = viewModel.orderTitleAttrString;
    }
}






















@end

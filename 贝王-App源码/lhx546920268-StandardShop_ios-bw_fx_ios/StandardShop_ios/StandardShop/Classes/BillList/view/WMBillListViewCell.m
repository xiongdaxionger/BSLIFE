//
//  WMBillListViewCell.m
//  StandardFenXiao
//
//  Created by mac on 15/12/4.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import "WMBillListViewCell.h"

#import "WMBillInfoModel.h"
@implementation WMBillListViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.billTimeLabel.font = [UIFont fontWithName:MainFontName size:12.0];
    
    self.billTimeLabel.textColor = MainTextColor;
    
    self.billPriceLabel.font = [UIFont fontWithName:MainFontName size:14.0];
    
    self.billPriceLabel.textColor = [UIColor redColor];
    
    self.billContentLabel.font = [UIFont fontWithName:MainFontName size:14.0];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.billImageView.sea_originContentMode = UIViewContentModeScaleAspectFit;
}

- (void)configureWithModel:(WMBillInfoModel *)infoModel{
    
    if (![NSString isEmpty:infoModel.billOrderID]) {
        
        self.billContentLabel.text = [NSString stringWithFormat:@"%@\n%@",infoModel.billContentStr,infoModel.billOrderID];
    }
    else{
        
        self.billContentLabel.text = infoModel.billContentStr;
    }
    
    NSString *price;
    
    if (infoModel.billIsAdd) {
        
        price = [NSString stringWithFormat:@"+%@",infoModel.billPriceStr];
    }
    else{
        
        price = [NSString stringWithFormat:@"-%@",infoModel.billPriceStr];
    }
    
    self.billPriceLabel.text = price;
    
    self.billTimeLabel.text = infoModel.billTimeStr;
    
    [self.billImageView sea_setImageWithURL:infoModel.billImageView];
}

@end

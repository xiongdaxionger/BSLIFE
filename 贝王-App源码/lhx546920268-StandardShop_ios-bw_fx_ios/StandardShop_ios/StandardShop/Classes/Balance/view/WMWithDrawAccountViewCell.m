//
//  WMWithDrawAccountViewCell.m
//  StandardFenXiao
//
//  Created by mac on 15/12/3.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import "WMWithDrawAccountViewCell.h"

#import "WMWithDrawAccountInfo.h"

@implementation WMWithDrawAccountViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


- (void)confirmWithAccountInfo:(WMWithDrawAccountInfo *)info{
    
    [self.typeImageView sea_setImageWithURL:info.accountLogo];
    
    self.typeLabel.text = [NSString stringWithFormat:@"%@  %@",info.blankCardPerson,info.blankName];
    
    if (info.type == WithDrawAccountTypeBlank) {
        
        self.typeNameLabel.attributedText = info.blankAttrString;
    }
    else if (info.type == WithDrawAccountTypeALiPay){
        
        self.typeNameLabel.text = info.blankNumber;
    }
}





@end

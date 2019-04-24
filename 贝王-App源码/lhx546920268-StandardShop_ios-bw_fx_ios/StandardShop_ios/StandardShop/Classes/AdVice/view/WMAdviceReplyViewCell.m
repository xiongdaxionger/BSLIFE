//
//  WMAdviceReplyViewCell.m
//  StandardShop
//
//  Created by Hank on 16/9/27.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMAdviceReplyViewCell.h"

#import "WMAdviceContentInfo.h"
@implementation WMAdviceReplyViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.contentLabel.textColor = WMMarketPriceColor;
    
    self.nameLabel.textColor = WMMarketPriceColor;
    
    self.nameLabel.textColor = [UIColor blackColor];
    
    self.typeLabel.layer.cornerRadius = 3.0;
    
    self.typeLabel.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

}

- (void)configureCellWithModel:(id)model{
    
    WMAdviceContentInfo *contentInfo = (WMAdviceContentInfo *)model;
    
    self.contentLabel.text = contentInfo.adviceContent;
    
    self.nameLabel.text = contentInfo.adviceUserName;
}








@end

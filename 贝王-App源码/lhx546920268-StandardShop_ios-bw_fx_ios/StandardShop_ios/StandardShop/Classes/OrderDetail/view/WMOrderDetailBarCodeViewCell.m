//
//  WMOrderDetailBarCodeViewCell.m
//  StandardShop
//
//  Created by Hank on 2018/6/6.
//  Copyright © 2018年 qianseit. All rights reserved.
//

#import "WMOrderDetailBarCodeViewCell.h"

@implementation WMOrderDetailBarCodeViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.selectionStyle = UITableViewCellSelectionStyleNone;

}

- (void)configureCellWithModel:(id)model {
    
    NSString *orderID = (NSString *)model;
    
    [self.barCodeImage setImage: [UIImage barcodeImageWithContent:orderID codeImageSize:CGSizeMake(_width_ - 32.0, 90.0) red:0.0 green:0.0 blue:0.0]];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:orderID attributes:@{NSKernAttributeName : @(1.5f)}];
    
    self.orderIDLabel.attributedText = attributedString;
}

@end

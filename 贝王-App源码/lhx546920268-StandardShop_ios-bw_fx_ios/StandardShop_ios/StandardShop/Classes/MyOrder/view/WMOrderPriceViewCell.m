//
//  WMOrderWaitSendViewCell.m
//  AKYP
//
//  Created by mac on 15/11/28.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import "WMOrderPriceViewCell.h"

#import "WMOrderInfo.h"
@interface WMOrderPriceViewCell ()

@end

@implementation WMOrderPriceViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _orderExpressLabel.hidden = YES;
}


- (void)configureCellWithModel:(id)model{
    
    WMOrderInfo *orderInfo = (WMOrderInfo *)model;
        
    _orderPriceLabel.attributedText = orderInfo.priceAttrString;
}

- (NSMutableAttributedString *)createCommonAttrWith:(NSString *)title andContent:(NSString *)content{
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",title,content]];
    [attStr addAttributes:@{NSForegroundColorAttributeName:WMPriceColor,
                            NSFontAttributeName:[UIFont systemFontOfSize:14.0]} range:[attStr.string rangeOfString:content]];
    [attStr addAttributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor],
                            NSFontAttributeName:[UIFont systemFontOfSize:14.0]} range:[attStr.string rangeOfString:title]];
    return attStr;
}
@end

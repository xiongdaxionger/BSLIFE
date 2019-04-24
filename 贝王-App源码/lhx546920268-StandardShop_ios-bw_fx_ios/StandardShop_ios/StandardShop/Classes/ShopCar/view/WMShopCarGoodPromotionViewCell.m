//
//  WMShopCarGoodPromotionViewCell.m
//  StandardShop
//
//  Created by mac on 16/6/21.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMShopCarGoodPromotionViewCell.h"

@implementation WMShopCarGoodPromotionViewCell

- (void)awakeFromNib {

    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


/**配置数据
 */
- (void)configureCellWithModel:(id)model{
    
    self.promotionLabel.attributedText = model;
}



@end

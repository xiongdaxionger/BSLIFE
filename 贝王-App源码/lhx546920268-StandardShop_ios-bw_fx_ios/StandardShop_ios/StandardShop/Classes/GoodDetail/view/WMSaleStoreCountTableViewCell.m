//
//  WMSaleStoreCountTableViewCell.m
//  StandardShop
//
//  Created by mac on 16/6/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMSaleStoreCountTableViewCell.h"

#import "WMGoodDetailInfo.h"
#import "WMGoodDetailGiftInfo.h"

@implementation WMSaleStoreCountTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    UIFont *font = [UIFont fontWithName:MainFontName size:14.0];
    
    self.contentabel.font = font;
    
    self.titleLabel.font = font;
    
    self.titleLabel.textColor = WMMarketPriceColor;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


/**配置数据
 */
- (void)configureCellWithModel:(id)model{
    
    WMGoodDetailInfo *info = [model objectForKey:@"model"];
    
    NSNumber *section = [model objectForKey:@"section"];
    
    self.contentabel.textColor = [UIColor blackColor];
    
    if (info.type == GoodPromotionTypeGift) {
        
        if (section.integerValue == GoodSectionTypeSale) {
            
            self.titleLabel.text = @"限兑";
            
            self.contentabel.text = [NSString stringWithFormat:@"%@%@",info.giftMessageInfo.exchangeMax,info.goodUnit];
        }
        else{
            
            self.titleLabel.text = @"可兑";
            
            self.contentabel.text = info.giftMessageInfo.memberLevel;
        }
    }
    else{
        
        switch (info.type) {
            case GoodPromotionTypeSecondKill:
            {
                if (section.integerValue == GoodSectionTypeSale) {
                    
                    self.titleLabel.text = @"月销";
                    
                    self.contentabel.text = [NSString stringWithFormat:@"%@%@",info.goodBuyCount,info.goodUnit];
                }
                else if(section.integerValue == GoodSectionTypeStore){
                        
                    self.titleLabel.text = @"库存";
                    
                    self.contentabel.text = [NSString stringWithFormat:@"%@",info.goodStore];
                }
                else{
                    
                    self.titleLabel.text = @"限购";
                    
                    self.contentabel.textColor = WMRedColor;
                    
                    self.contentabel.text = [NSString stringWithFormat:@"%ld%@",(long)info.goodLismitCout,info.goodUnit];
                }
            }
                break;
            default:
            {
                if (section.integerValue == GoodSectionTypeSale) {
                    
                    self.titleLabel.text = @"月销";
                    
                    self.contentabel.text = [NSString stringWithFormat:@"%@%@",info.goodBuyCount,info.goodUnit];
                }
                else{
                    
                    self.titleLabel.text = @"库存";
                    
                    self.contentabel.text = info.goodStore;
                    
                }
            }
                break;
        }
    }
}






@end

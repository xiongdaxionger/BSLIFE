//
//  WMPrepareTimeViewCell.m
//  StandardShop
//
//  Created by mac on 16/7/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMPrepareTimeViewCell.h"

#import "WMOrderInfo.h"
#import "WMServerTimeOperation.h"

@implementation WMPrepareTimeViewCell

- (void)awakeFromNib {

    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.prepareTimeLabel.font = [UIFont fontWithName:MainFontName size:14.0];
    
    self.prepareTimeLabel.textColor = WMRedColor;
}

- (void)configureCellWithModel:(id)model{
    
    WMOrderInfo *orderInfo = [model objectForKey:@"modelKey"];
        
    if (orderInfo.prepareBeginTime.integerValue >= [WMServerTimeOperation sharedInstance].time) {
        
        self.prepareTimeLabel.text = [NSString stringWithFormat:@"尾款补款期限于%@开启",[NSDate formatTimeInterval:orderInfo.prepareBeginTime format:DateFormatYMdHm]];
    }
    else{
        
        if (orderInfo.prepareFinalTime.integerValue >= [WMServerTimeOperation sharedInstance].time) {
            
            self.prepareTimeLabel.text = [NSString stringWithFormat:@"请在%@前补完尾款",[NSDate formatTimeInterval:orderInfo.prepareFinalTime format:DateFormatYMdHm]];
        }
        else{
            
            self.prepareTimeLabel.text = [NSString stringWithFormat:@"尾款补款期限于%@结束",[NSDate formatTimeInterval:orderInfo.prepareFinalTime format:DateFormatYMdHm]];
        }
    }
}




@end

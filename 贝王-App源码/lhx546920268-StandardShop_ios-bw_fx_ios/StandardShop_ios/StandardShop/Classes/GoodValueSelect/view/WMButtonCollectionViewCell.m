//
//  WMButtonCollectionViewCell.m
//  StandardShop
//
//  Created by mac on 16/6/16.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMButtonCollectionViewCell.h"

@implementation WMButtonCollectionViewCell


- (void)configureWithDict:(NSDictionary *)dict{
    
    NSString *buttonName = [dict sea_stringForKey:@"name"];
    
    NSString *buttonType = [dict sea_stringForKey:@"value"];
    
    [self.buttonLabel setText:buttonName];
    
    [self.buttonLabel setFont:WMLongButtonTitleFont];
    
    if ([buttonType isEqualToString:@"fastbuy"]) {
        
        [self.buttonLabel setBackgroundColor:WMRedColor];
        
        [self.buttonLabel setTextColor:[UIColor whiteColor]];
    }
    else if ([buttonType isEqualToString:@"buy"]){
        
        [self.buttonLabel setBackgroundColor:[UIColor colorWithR:254 G:123 B:0 a:1]];

        [self.buttonLabel setTextColor:[UIColor whiteColor]];
    }
}
@end

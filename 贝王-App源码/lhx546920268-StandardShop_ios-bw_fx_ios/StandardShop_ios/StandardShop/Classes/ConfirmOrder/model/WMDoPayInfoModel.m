//
//  WMDoPayInfoModel.m
//  StandardFenXiao
//
//  Created by mac on 15/12/18.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import "WMDoPayInfoModel.h"

@implementation WMDoPayInfoModel

#pragma mark - 初始化
- (instancetype)initWithDict:(NSDictionary *)dict{
    
    self = [super init];
    
    if (self) {
        
        self.body = [dict sea_stringForKey:@"body"];
        
        self.rel_id = [dict sea_stringForKey:@"rel_id"];
        
        self.key = [dict sea_stringForKey:@"key"];
        
        self.pay_app_type = [dict sea_stringForKey:@"pay_app_type"];
        
        self.payment_id = [dict sea_stringForKey:@"payment_id"];
        
        self.order_id = [dict sea_stringForKey:@"order_id"];
        
        self.mer_id = [dict sea_stringForKey:@"mer_id"];
        
        self.seller_account_name = [dict sea_stringForKey:@"seller_account_name"];
        
        self.total_amount = [dict sea_stringForKey:@"cur_money"];
        
        self.callback_url = [dict sea_stringForKey:@"callback_url"];
        
        self.payStr = [dict sea_stringForKey:@"str"];
    }
    
    return self;
}
@end

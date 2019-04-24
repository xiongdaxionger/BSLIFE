//
//  WMTaxSettingInfo.m
//  StandardShop
//
//  Created by mac on 16/6/26.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMTaxSettingInfo.h"

@implementation WMTaxSettingInfo
/**初始化
 */
+ (instancetype)returnTaxSettingInfoWithDict:(NSDictionary *)dict{
    
    WMTaxSettingInfo *taxSettingInfo = [WMTaxSettingInfo new];
    
    taxSettingInfo.taxContentsArr = [dict arrayForKey:@"tax_content"];
    
    taxSettingInfo.taxTypesArr = [dict arrayForKey:@"tax_type"];
    
    return taxSettingInfo;
}
@end

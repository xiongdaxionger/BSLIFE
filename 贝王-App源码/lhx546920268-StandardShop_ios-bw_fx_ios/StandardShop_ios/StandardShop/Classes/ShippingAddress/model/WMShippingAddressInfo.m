//
//  WMShippingAddressInfo.m
//  WuMei
//
//  Created by 罗海雄 on 15/7/22.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "WMShippingAddressInfo.h"

@implementation WMShippingAddressInfo

- (NSString*)areaId
{
    NSString *areaId = [[self.mainland componentsSeparatedByString:@":"] lastObject];
    
    return areaId;
}

/**地址组合
 */
- (NSString*)addressCombination
{
    NSMutableString *text = [[NSMutableString alloc] init];

    if(![NSString isEmpty:self.area])
    {
        [text appendString:self.area];
    }
    
    if(![NSString isEmpty:self.detailAddress])
    {
        [text appendString:self.detailAddress];
    }
    
    return text;
}

- (NSString*)displayPhoneNumber
{
    
    if(![NSString isEmpty:self.phoneNumber])
    {
        return self.phoneNumber;
    }
    else
    {
        return self.telPhoneNumber;
    }
}

- (id)copyWithZone:(NSZone *)zone
{
    WMShippingAddressInfo *info = [[WMShippingAddressInfo allocWithZone:zone] init];
    info.Id = self.Id;
    info.mainland = self.mainland;
    info.area = self.area;
    info.consignee = self.consignee;
    info.phoneNumber = self.phoneNumber;
    info.telPhoneNumber = self.telPhoneNumber;
    info.detailAddress = self.detailAddress;
    info.isDefaultAdr = self.isDefaultAdr;
    info.jsonValue = self.jsonValue;
    
    return info;
}


@end

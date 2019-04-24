//
//  WMAddressInfo.m
//  StandardFenXiao
//
//  Created by mac on 15/12/7.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import "WMAddressInfo.h"
#import "WMShippingAddressInfo.h"
#import "WMAreaInfo.h"
@implementation WMAddressInfo

/**批量初始化
 */
+ (NSMutableArray *)returnAddressInfosArrWithDictArr:(NSArray *)dictArr{
    
    NSMutableArray *mutArr = [[NSMutableArray alloc] initWithCapacity:dictArr.count];
    
    for (NSDictionary *dict in dictArr) {
        
        [mutArr addObject:[WMAddressInfo returnAddressInfoWithDict:dict]];
    }
    
    return mutArr;
}

+ (instancetype)returnAddressInfoWithDict:(NSDictionary *)dict{
    
    WMAddressInfo *addressInfo = [[WMAddressInfo alloc] init];
    
    addressInfo.addressDetail = [NSString stringWithFormat:@"%@%@",[dict sea_stringForKey:@"txt_area"],[dict sea_stringForKey:@"addr"]];
    
    addressInfo.addressID = [dict sea_stringForKey:@"addr_id"];
    
    addressInfo.addressMobile = [NSString isEmpty:[dict sea_stringForKey:@"mobile"]] ? [dict sea_stringForKey:@"tel"] : [dict sea_stringForKey:@"mobile"];
    
    addressInfo.addressName = [dict sea_stringForKey:@"name"];
    
    addressInfo.addressAreaID = [[[dict sea_stringForKey:@"area"] componentsSeparatedByString:@":"] lastObject];
    
    addressInfo.addressAreaInfo = [dict sea_stringForKey:@"area"];
    
    addressInfo.addressJsonValue = [dict sea_stringForKey:@"value"];
    
    return addressInfo;
}

/**订单详情的地址初始化
 */
+ (instancetype)returnOrderDetailAddressInfoWithDict:(NSDictionary *)dict{
    
    WMAddressInfo *addressInfo = [[WMAddressInfo alloc] init];

    addressInfo.addressDetail = [dict sea_stringForKey:@"addr"];
    
    addressInfo.addressMobile = [NSString isEmpty:[dict sea_stringForKey:@"mobile"]] ? [dict sea_stringForKey:@"telephone"] : [dict sea_stringForKey:@"mobile"];
    
    addressInfo.addressName = [dict sea_stringForKey:@"name"];

    return addressInfo;
}

+ (instancetype)createModelWithShipInfo:(WMShippingAddressInfo *)shipInfo
{
    
    if(shipInfo == nil)
        return nil;
    
    WMAddressInfo *viewModel = [WMAddressInfo new];
    
    viewModel.addressMobile = shipInfo.displayPhoneNumber;
    
    viewModel.addressName = [NSString stringWithFormat:@"%@",shipInfo.consignee];
    
    viewModel.addressDetail = shipInfo.addressCombination;
    
    viewModel.addressID = [NSString stringWithFormat:@"%lld",shipInfo.Id];
    
    viewModel.addressAreaID = shipInfo.areaId;
    
    viewModel.addressJsonValue = shipInfo.jsonValue;
    
    return viewModel;
}

- (WMShippingAddressInfo *)createInfo{
    
    WMShippingAddressInfo *info = [[WMShippingAddressInfo alloc] init];
    
    info.Id = self.addressID.longLongValue;
    
    info.mainland = self.addressAreaInfo;
    
    info.consignee = self.addressName;
    
    info.phoneNumber = self.addressMobile;
        
    info.detailAddress = self.addressDetail;
    
    return info;
}
@end

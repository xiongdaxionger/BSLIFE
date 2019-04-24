//
//  WMCustomerServiceInfo.m
//  StandardShop
//
//  Created by Hank on 16/9/13.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMCustomerServiceInfo.h"

@implementation WMCustomerServiceInfo
/**初始化
 */
+ (NSArray *)returnCustomerServiceInfosArr{
    
    NSMutableArray *infosArr = [NSMutableArray new];
    
    WMCustomerServiceInfo *onLineInfo = [WMCustomerServiceInfo new];

    onLineInfo.name = @"在线客服";
    
    onLineInfo.imageName = @"customer_service_online";
    
    onLineInfo.type = WMCustomerServiceTypeOnLine;
    
    [infosArr addObject:onLineInfo];
    
    WMCustomerServiceInfo *feedBackInfo = [WMCustomerServiceInfo new];
    
    feedBackInfo.name = @"意见反馈";
    
    feedBackInfo.imageName = @"customer_service_feedback";
    
    feedBackInfo.type = WMCustomerServiceTypeFeedBack;
    
    [infosArr addObject:feedBackInfo];
    
    WMCustomerServiceInfo *phoneInfo = [WMCustomerServiceInfo new];
    
    phoneInfo.name = @"客服电话";
    
    phoneInfo.imageName = @"customer_service_phone";

    phoneInfo.type = WMCustomerServiceTypePhone;
    
    [infosArr addObject:phoneInfo];
    
    return infosArr;
}



@end

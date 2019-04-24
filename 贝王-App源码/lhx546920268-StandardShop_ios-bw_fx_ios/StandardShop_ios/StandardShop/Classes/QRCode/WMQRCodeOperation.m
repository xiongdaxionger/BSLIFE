//
//  WMQRCodeOperation.m
//  AKYP
//
//  Created by 罗海雄 on 15/11/25.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMQRCodeOperation.h"
#import "WMUserOperation.h"

@implementation WMQRCodeOperation

/**获取二维码图片 参数
 *@param type 0 邀请二维码，1店铺二维码
 */
+ (NSDictionary*)qrCodeParamWithType:(int) type
{
    NSString *typeString = nil;
    
//    switch (type)
//    {
//        case 0 :
//        {
//            typeString = @"enlist";
//        }
//            break;
//        case 1 :
//        {
//            typeString = @"shop";
//        }
//            break;
//        default:
//            break;
//    }
    
    return [NSDictionary dictionaryWithObjectsAndKeys:@"b2c.activity.register", WMHttpMethod, typeString, @"type", nil];
}

/**获取二维码图片 结果
 *@return 二维码图片链接
 */
+ (NSString*)qrCodeResultFromData:(NSData*) data
{
    NSDictionary *dict = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if ([WMUserOperation resultFromDictionary:dict])
    {
        return [[dict dictionaryForKey:WMHttpData] sea_stringForKey:@"code_image_id"];
    }
    else
    {
        return nil;
    }
}

@end

//
//  WMQRCodeOperation.h
//  AKYP
//
//  Created by 罗海雄 on 15/11/25.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

///二维码网络操作
@interface WMQRCodeOperation : NSObject

/**获取二维码图片 参数
 *@param type 0 邀请二维码，1店铺二维码
 */
+ (NSDictionary*)qrCodeParamWithType:(int) type;

/**获取二维码图片 结果
 *@return 二维码图片链接
 */
+ (NSString*)qrCodeResultFromData:(NSData*) data;

@end

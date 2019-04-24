//
//  WMShippingOpeartion.h
//  WanShoes
//
//  Created by mac on 16/3/15.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMShippingOpeartion : NSObject

/**获取配送方式 参数
 */
+ (NSDictionary *)returnShippingMethodParamWithAreaID:(NSString *)areaID isFastBuy:(NSString *)isFastBuy isSelfAuto:(BOOL)isSelfAuto;
/**获取配送方式 结果--字典(shippingArr:[除门店自提外的快递],WMBranchGetSelf:门店自提的模型)
 */
+ (NSArray *)returnShippingMethodResultWithData:(NSData *)data;

/**返回当前时间的后七天自提时间数组
 */
+ (NSArray *)returnBranchTimeArr;

@end

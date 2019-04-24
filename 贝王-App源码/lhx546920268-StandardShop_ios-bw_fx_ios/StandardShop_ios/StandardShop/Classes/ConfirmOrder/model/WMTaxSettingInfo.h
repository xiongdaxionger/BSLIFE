//
//  WMTaxSettingInfo.h
//  StandardShop
//
//  Created by mac on 16/6/26.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

/**确认订单发票配置模型
 */
@interface WMTaxSettingInfo : NSObject
/**发票类型数组,元素是NSDictionary
 */
@property (strong,nonatomic) NSArray *taxTypesArr;
/**发票内容数组，元素是NSString
 */
@property (strong,nonatomic) NSArray *taxContentsArr;
/**初始化
 */
+ (instancetype)returnTaxSettingInfoWithDict:(NSDictionary *)dict;
@end

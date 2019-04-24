//
//  WMGoodListOrderByInfo.h
//  StandardShop
//
//  Created by 罗海雄 on 16/6/27.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

///商品列表排序信息
@interface WMGoodListOrderByInfo : NSObject

///排序名称
@property(nonatomic,copy) NSString *name;

///排序字段
@property(nonatomic,copy) NSString *key;

/**通过字典获取排序信息
 *@param dic 包含排序信息的字典
 *@return 数组元素是 WMGoodListOrderByInfo
 */
+ (NSArray*)infosFromDictionary:(NSDictionary*) dic;

@end

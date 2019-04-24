//
//  WMCategoryOperation.h
//  WuMei
//
//  Created by 罗海雄 on 15/7/18.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import <Foundation/Foundation.h>

///网络标识

#define WMGoodCategoryIdentifier @"WMGoodCategoryIdentifier" ///商品分类

@interface WMCategoryOperation : NSObject

/**获取商品分类 参数
 */
+ (NSDictionary*)goodCategoryParam;

/**从返回的数据获取商品分类
 *@return 数组元素是 WMCategoryInfo
 */
+ (NSMutableArray*)goodCategoryFromData:(NSData*) data;

@end

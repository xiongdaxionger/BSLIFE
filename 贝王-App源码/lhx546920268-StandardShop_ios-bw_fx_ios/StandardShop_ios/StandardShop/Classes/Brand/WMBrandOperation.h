//
//  WMBrandOperation.h
//  WanShoes
//
//  Created by 罗海雄 on 16/4/1.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

///网络请求标识
#define WMBrandListIdentifier @"WMBrandListIdentifier" ///品牌列表

///品牌列表每页数量
#define WMBrandPageSize 3 * 8

///品牌向网络操作
@interface WMBrandOperation : NSObject

/**获取所有品牌列表 参数
 *@param pageIndex 页码
 */
+ (NSDictionary*)brandListParamsWithPageIndex:(int) pageIndex;

/**获取所有品牌列表 结果
 *@param totalSize 列表总数
 *@return 数组元素是 WMBrandInfo
 */
+ (NSArray*)brandListFromData:(NSData*) data totalSize:(long long *) totalSize;

@end

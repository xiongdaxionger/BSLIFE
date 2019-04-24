//
//  WMCollegeOperation.h
//  WestMailDutyFee
//
//  Created by YUYE on 15/8/31.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WMCollegeCategoryIdentifier @"WMCollegeCategoryIdentifier" ///学院分类
#define WMCollegeListIdentifier @"WMCollegeListIdentifier" ///学院列表

///学院每页数量
#define WMCollegePageSize 20

@class WMCollegeInfo,WMCollegeDetailInfo;

@interface WMCollegeOperation : NSObject

/**获取学院文章分类列表 参数
 */
+ (NSDictionary*)collegeCategoryListParams;

/**获取学院文章分类列表 结果
 *@return 数组元素是 WMCollegeCategoryInfo
 */
+ (NSMutableArray *)collegeCategoryListFromData:(NSData*) data;

/**通过分类id获取 学院列表信息 参数
 *@param categoryId 分类id
 *@param keyword 搜索关键字
 *@param pageIndex 页码
 *@param pageSize 每页数量
 */
+ (NSDictionary*)collegeListParamsWithCategoryId:(NSString*) categoryId keyword:(NSString*) keyword pageIndex:(int) pageIndex pageSize:(int) pageSize;

/**获取学院列表信息 
 *@return 数组元素是 WMCollegeInfo
 */
+ (NSMutableArray*)collegeListFromData:(NSData*) data;

/**通过学院信息Id获取学院详情
 *@param info 要获取详情的学院信息
 */
+ (NSDictionary*)collegeDetailParamWithInfo:(WMCollegeInfo*) info;

/**获取学院详情
 */
+ (WMCollegeDetailInfo*)collegeDetailFromData:(NSData*) data;

@end

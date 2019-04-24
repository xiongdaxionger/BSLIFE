//
//  WMHomeOperation.h
//  WestMailDutyFee
//
//  Created by 罗海雄 on 15/8/26.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

//http请求标识
#define WMHomeAdIdentifier @"WMHomeAdIdentifier" ///首页广告
#define WMHomeInfosIdentifier @"WMHomeInfosIdentifier" ///首页信息
#define WMServerTimeIdentifer @"WMServerTimeIdentifer"///系统时间
#define WMHomeDialogAdIdentifier @"WMHomeDialogAdIdentifier" ///首页弹窗广告


@class WMHomeAdInfo,WMSeasonForHeaderInfo,WMArticleInfo,WMHomeInfo,WMHomeSecondKillInfo,WMHomeDialogAdInfo;

/**首页网络操作及 功能按钮排序保存
 */
@interface WMHomeOperation : NSObject

/**获取首页信息 参数
 */
+ (NSDictionary*)homeInfosParams;

/**从返回的数据获取首页信息
 *@return 数组元素是 WMHomeInfo
 */
+ (NSMutableArray*)homeInfosFromData:(NSData*) data;

/**获取文章 参数
 */
+ (NSDictionary*)articleInfoParamWithArticleId:(NSString*) articleId;

/**获取文章
 *@return 文章
 */
+ (WMArticleInfo*)articleInfoResultFromData:(NSData*) data;

/**获取热门搜索 参数
 */
+ (NSDictionary*)hotSearchParams;

/**获取热门搜索 结果
 *@return  数组元素是 NSString
 */
+ (NSArray*)hotSearchFromData:(NSData*) data;

/**搜索联想 参数
 *@param searchKey 要联想的字符
 */
+ (NSDictionary*)searchAssociateWithKey:(NSString*) searchKey;

/**搜索联想 结果
 *@return 联想结果，数组元素是 NSString， 返回nil则表示已关闭联想
 */
+ (NSArray*)searchAssociateResultFromData:(NSData*) data;

/**获取系统服务器时间 参数
 */
+ (NSDictionary*)serverTimeParams;

/**获取系统服务器时间 结果
 *@return 系统服务器时间
 */
+ (NSTimeInterval)serverTimeFromData:(NSData*) data;

/**获取首页弹窗广告 参数
 *@param time 上次显示广告的时间戳，第一次时传0
 */
+ (NSDictionary *)homeAdDialogParam:(NSTimeInterval)time;

/**获取首页弹窗广告 数据
 */
+ (WMHomeDialogAdInfo *)parseAdDialogInfoWithData:(NSData *)data;

@end

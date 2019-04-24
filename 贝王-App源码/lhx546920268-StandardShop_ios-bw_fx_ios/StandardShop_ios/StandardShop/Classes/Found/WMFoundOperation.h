//
//  WMFoundOperation.h
//  WanShoes
//
//  Created by 罗海雄 on 16/3/22.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WMFoundCategoryInfo,WMFoundListInfo;

///网络请求标识
#define WMFoundHomeInfoIdentifier @"WMFoundHomeInfoIdentifier" ///发现首页
#define WMFoundListIdentifier @"WMFoundListIdentifier" ///发现列表
#define WMFoundPraiseIdentifier @"WMFoundPraiseIdentifier" ///发现点赞
#define WMFoundCommentIdentifier @"WMFoundCommentIdentifier" ///发现评论
#define WMFoundCommentListIdentifier @"WMFoundCommentListIdentifier" ///发现评论列表
#define WMFoundDetailIdentifier @"WMFoundDetailIdentifier" ///发现内容
#define WMFoundAdIdentifier @"WMFoundAdIdentifier" ///发现广告

///添加评论通知
#define WMFoundCommentDidAddNotification @"WMFoundCommentDidAddNotification"

///点赞
#define WMFoundDidPraiseNotification @"WMFoundDidPraiseNotification"

///发现信息 id
#define WMFoundListInfoIdKey @"Id"

///点赞状态 bool值
#define WMFoundPraiseStatus @"status"

///评论次数 int
#define WMFoundCommentCount @"commentCount"

///发现网络操作
@interface WMFoundOperation : NSObject

/**获取发现首页 参数
 */
+ (NSDictionary*)foundHomeInfoParams;

/**获取发现首页 结果
 *@return 数组元素是 WMFoundHomeInfo
 */
+ (NSArray*)foundHomeInfoFromData:(NSData*) data;

/**通过分类获取发现内容 参数
 *@param info 分类信息
 *@param pageIndex 页码
 */
+ (NSDictionary*)foundListParamWithCategoryInfo:(WMFoundCategoryInfo*) info pageIndex:(int) pageIndex;

/**通过分类获取发现内容 结果
 *@param totalSize 列表总数
 *@return 数组元素是 WMFoundListInfo
 */
+ (NSArray*)foundListFromData:(NSData*) data totalSize:(long long*) totalSize;

/**点赞发现内容 参数
 *@param info 发现内容
 */
+ (NSDictionary*)foundPraiseParamWithInfo:(WMFoundListInfo*) info;

/**点赞发现内容 结果
 *@return 是否成功
 */
+ (BOOL)foundPraiseResultFromData:(NSData*) data;

/**评论发现内容 参数
 *@param info 发现内容
 *@param content 评论内容
 *@param code 图形验证码
 */
+ (NSDictionary*)foundCommentParamWithInfo:(WMFoundListInfo*) info content:(NSString*) content code:(NSString*) code;

/**评论发现内容 结果
 *@return 是否成功
 */
+ (BOOL)foundCommentResultFromData:(NSData*) data;

/**获取文章评论列表 参数
 *@param articleId 文章id
 *@param pageIndex 页码
 */
+ (NSDictionary*)foundCommentListParamWithArticleId:(NSString*) articleId pageIndex:(int) pageIndex;

/**获取文章评论列表 结果
 *@param totalSize 列表总数
 *@return 数组元素是 WMFoundCommentInfo
 */
+ (NSArray*)foundCommentListFromData:(NSData*) data totalSize:(long long*) totalSize;

/**获取发现详情 参数
 *@param articleId 文章id
 */
+ (NSDictionary*)foundDetailWithArticleId:(NSString*) articleId;

/**获取发现详情 结果
 *@return 文章详情
 */
+ (WMFoundListInfo*)foundDetailFromData:(NSData*) data;

/**获取发现广告 参数
 */
+ (NSDictionary*)foundAdParams;

/**获取发现广告 结果
 *@return 数组元素是 WMHomeAdInfo
 */
+ (NSArray*)foundAdFromData:(NSData*) data;

@end

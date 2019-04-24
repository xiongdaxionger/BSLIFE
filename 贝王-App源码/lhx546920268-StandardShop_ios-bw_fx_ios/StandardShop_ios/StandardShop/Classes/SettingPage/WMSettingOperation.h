//
//  WMSettingOperation.h
//  WanShoes
//
//  Created by mac on 16/3/17.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

//获取意见反馈类型
#define WMGetFeedBackTypeIden @"WMGetFeedBackTypeIden"
//提交意见反馈
#define WMCommitFeedBackIden @"WMCommitFeedBackIden"

@class WMAboutMeInfo,WMHelpCenterInfo;

@interface WMSettingOperation : NSObject

/**返回关于我们 参数
 */
+ (NSDictionary*)returnAboutDictParam;

/**返回关于我们 结果
 */
+ (WMAboutMeInfo*)returnAboutDictResultWithData:(NSData *)data;

/**获取意见返回类型 参数
 */
+ (NSDictionary *)returnFeedBackTypeParam;
/**获取意见返回类型 结果
 */
+ (NSDictionary *)returnFeedBackTypeResult:(NSData *)data;
/**意见反馈 参数
 *type 反馈类型
 *title 标题
 *receive 收件人
 *content 反馈内容
 *contact 反馈人的联系方式
 */
+ (NSDictionary*)returnFeedBackParamWith:(NSString *)type content:(NSString *)content contact:(NSString *)contact title:(NSString *)title receive:(NSString *)receive;
/**意见反馈 结果
 */
+ (BOOL)returnFeedBackResultWithData:(NSData *)data;

/**获取帮助中心信息 参数
 *@param pageIndex 页码
 */
+ (NSDictionary*)helpCenterInfoParamsWithPageIndex:(int) pageIndex;

/**获取帮助中心信息
 *@param totalSize 列表总数
 *@return 数组元素是 WMHelpCenterInfo
 */
+ (NSArray*)helpCenterInfoFromData:(NSData*) data totalSize:(long long*) totalSize;

/**获取帮助中心详情 参数
 */
+ (NSDictionary*)helpCenterDetailParamsWithInfo:(WMHelpCenterInfo*) info;

/**获取帮助中心详情 结果
 *@return 帮助中心html详情
 */
+ (NSString*)helpCenterDetailFromData:(NSData*) data;

@end

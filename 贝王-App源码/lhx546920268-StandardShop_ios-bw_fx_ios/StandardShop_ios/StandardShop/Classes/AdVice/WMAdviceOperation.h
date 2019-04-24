//
//  WMAdviceOperation.h
//  StandardShop
//
//  Created by mac on 16/6/2.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

//获取咨询列表内容网络请求
#define WMGetAdviceContentIdentifier @"WMGetAdviceContentIdentifier"
//发表咨询网络请求
#define WMCommitAdviceIdentifier @"WMCommitAdviceIdentifier"
//获取咨询翻页网络请求
#define WMGetAdviceContentPageIdentifier @"WMGetAdviceContentPageIdentifier"
//回复咨询网络请求
#define WMReplyAdviceIdentifier @"WMReplyAdviceIdentifier"

/**商品详情咨询操作类
 */
@interface WMAdviceOperation : NSObject
/**发布咨询 参数
 *@param 商品ID goodID
 *@param 匿名 isHiddenName
 *@param 咨询内容 content
 *@param 咨询类型ID adviceTypeID
 *@param 验证码 askverifyCode
 */
+ (NSDictionary *)returnCommitAdviceWithGoodID:(NSString *)goodID isHiddenName:(BOOL)isHiddenName content:(NSString *)content adviceTypeID:(NSString *)adviceTypeID askverifyCode:(NSString *)askverifyCode;
/**发布咨询 结果
 *发布成功的时候返回成功提示语
 */
+ (BOOL)returnCommitAdviceResultWithData:(NSData *)data;
/**发布咨询后返回新的咨询类型标题
 */
+ (NSArray *)returnAdviceCommitSuccessTitlesArrWithDict:(NSDictionary *)dict;

/**返回咨询菜单栏的标题
 *@param adviceTypeInfoArr 咨询类型数组，内容是WMAdviceTypeInfo
 */
+ (NSArray *)returnMenuBarTitleArrWithAdviceTypeInfoArr:(NSArray *)adviceTypeInfoArr;

/**返回咨询列表第一页 参数
 *@param 商品ID goodID
 */
+ (NSDictionary *)returnAdviceListFirstPageParamWithGoodID:(NSString *)goodID;
/**返回咨询列表第一页 结果
 *return @"setting"-WMAdviceSettingInfo
 *return @"type"-WMAdviceTypeInfo
 *return @"list"-WMAdviceQuestionInfo
 *return @"total"-NSNumber
 */
+ (NSDictionary *)returnAdviceListResultWithData:(NSData *)data;
/**返回咨询列表翻页 参数
 *@param 商品ID goodID
 *@param 页码 page
 *@param 咨询类型ID typeID
 */
+ (NSDictionary *)returnAdviceListPageParamWithGoodID:(NSString *)goodID page:(NSInteger)page typeID:(NSString *)typeID;
/**返回咨询列表翻页 结果
 *return NSArray-WMAdviceQuestionInfo
 *return NSNumber-数据总量
 */
+ (NSDictionary *)returnAdviceListPageResultWithData:(NSData *)data;

/**回复咨询 参数
 *@param 咨询ID adviceID
 *@param 回复内容 comment
 *@param 验证码 replyverifyCode
 */
+ (NSDictionary *)returnReplyAdviceWithAdviceID:(NSString *)adviceID comment:(NSString *)comment replyverifyCode:(NSString *)replyverifyCode;
/**回复咨询 结果
 *发布成功返回提示语
 */
+ (BOOL)returnReplyAdviceResultWithData:(NSData *)data;
























@end

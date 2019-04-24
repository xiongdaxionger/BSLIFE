//
//  WMCommentOperation.h
//  StandardShop
//
//  Created by 罗海雄 on 16/6/2.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WMGoodCommentOverallInfo,WMGoodCommentInfo,WMGoodCommentRuleInfo,WMImageInfo;

///上传图片文件key
#define WMUploadImageKey @"file"

///图片压缩比例
#define WMCommentImageScale 0.9

///请求标识
#define WMGoodCommentRuleIdentifier @"WMGoodCommentRuleIdentifier" ///商品评价规则
#define WMGoodCommentAddIdentifier @"WMGoodCommentAddIdentifier" ///商品评价添加

///评论网络操作
@interface WMCommentOperation : NSObject

/**获取商品评价列表 参数
 *@param goodId 商品Id
 *@param pageIndex 页码 在第一页的时候会获取 评价总评信息
 *@param filter 筛选字段
 */
+ (NSDictionary*)goodCommentListParamsWithGoodId:(NSString*) goodId pageIndex:(int) pageIndex filter:(NSString*) filter;

/**获取商品评价列表 结果
 *@param overallInfo 商品总评信息，传nil则忽略
 *@param totalSize 列表总长度
 *@return 数组元素是 WMGoodCommentInfo
 */
+ (NSArray*)goodCommentListFromData:(NSData*) data overallInfo:(WMGoodCommentOverallInfo**) overallInfo totalSize:(long long*) totalSize;

/**商品评价回复 参数
 *@param info 评论信息
 *@param content 评论内容
 *@param code 图形验证码，可不传
 */
+ (NSDictionary*)goodCommentReplyParamWithInfo:(WMGoodCommentInfo*) info content:(NSString*) content code:(NSString*) code;

/**商品评价回复结果 结果
 *return 如果需要显示新发布的评论，则返回数组，数组元素是WMGoodCommentInfo，否则返回NSString 提示信息，如果为nil，则回复失败
 */
+ (id)goodCommentReplyResultFromData:(NSData*) data;

/**获取商品评价规则 参数
 */
+ (NSDictionary*)goodCommentRuleParams;

/**获取商品评价规则 结果
 *@return 规则信息
 */
+ (WMGoodCommentRuleInfo*)goodCommentRuleFromData:(NSData*) data;

/**添加商品评论 参数
 *@param goodId 要评论的商品
 *@param productId 要评论的货品
 *@param orderId 商品相关的订单
 *@param content 评论内容
 *@param anonymous 是否匿名
 *@param code 图形验证码
 *@param scores 评分项信息 数组元素是 WMGoodCommentScoreInfo
 *@param images 要晒的图 数组元素是 WMImageUploadInfo
 */
+ (NSDictionary*)goodCommentAddParamsWithGoodId:(NSString*) goodId productId:(NSString*) productId orderId:(NSString*) orderId content:(NSString*) content anonymous:(BOOL) anonymous code:(NSString*) code scores:(NSArray*) scores images:(NSArray*) images;

/**添加商品评论结果
 *@return 是否成功
 */
+ (BOOL)goodCommentAddResultFromData:(NSData*) data;

/**上传图片 参数
 */
+ (NSDictionary*)uploadImageParam;

/**上传图片 结果
 *@return 图片信息
 */
+ (WMImageInfo*)uploadImageResultFromData:(NSData*) data;


@end

//
//  WMCommentOperation.m
//  StandardShop
//
//  Created by 罗海雄 on 16/6/2.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMCommentOperation.h"
#import "WMGoodCommentOverallInfo.h"
#import "WMUserOperation.h"
#import "WMGoodCommentInfo.h"
#import "WMGoodCommentRuleInfo.h"
#import "WMGoodCommentScoreInfo.h"
#import "WMImageInfo.h"
#import "WMImageUploadInfo.h"

@implementation WMCommentOperation

/**获取商品评价列表 参数
 *@param goodId 商品Id
 *@param pageIndex 页码 在第一页的时候会获取 评价总评信息
 *@param filter 筛选字段
 */
+ (NSDictionary*)goodCommentListParamsWithGoodId:(NSString*) goodId pageIndex:(int) pageIndex filter:(NSString*) filter
{
    return [NSDictionary dictionaryWithObjectsAndKeys:(pageIndex == WMHttpPageIndexStartingValue && filter == nil) ? @"b2c.product.goodsDiscuss" : @"b2c.comment.getDiscuss", WMHttpMethod, [NSNumber numberWithInt:pageIndex], WMHttpPageIndex, goodId, @"goods_id", filter, @"type", nil];
}

/**获取商品评价列表 结果
 *@param overallInfo 商品总评信息，传nil则忽略
 *@param totalSize 列表总长度
 *@return 数组元素是 WMGoodCommentInfo
 */
+ (NSArray*)goodCommentListFromData:(NSData*) data overallInfo:(WMGoodCommentOverallInfo**) overallInfo totalSize:(long long*) totalSize
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];

    if([WMUserOperation resultFromDictionary:dic])
    {
        NSDictionary *dataDic = [dic dictionaryForKey:WMHttpData];

        ///评论列表
        NSDictionary *commentDic = [dataDic dictionaryForKey:@"comments"];
        NSArray *comments = [[commentDic dictionaryForKey:@"list"] arrayForKey:@"discuss"];
        NSMutableArray *infos = [NSMutableArray arrayWithCapacity:comments.count];

        for(NSDictionary *dict in comments)
        {
            [infos addObject:[WMGoodCommentInfo infoFromDictionary:dict]];
        }

        ///总评信息
        if(overallInfo != nil)
        {
            *overallInfo = [WMGoodCommentOverallInfo infoFromDictionary:dataDic];
        }

        ///所有评论数量
        if(totalSize)
        {
            *totalSize = [WMUserOperation totalSizeFromDictionary:dataDic];
        }

        return infos;
    }

    return nil;
}

/**商品评价回复 参数
 *@param info 评论信息
 *@param content 评论内容
 *@param code 图形验证码，可不传
 */
+ (NSDictionary*)goodCommentReplyParamWithInfo:(WMGoodCommentInfo*) info content:(NSString*) content code:(NSString*) code
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"b2c.comment.toReply", WMHttpMethod, info.Id, @"id", content, @"comment", code, @"replyverifyCode", nil];
}

/**商品评价回复结果 结果
 *return 如果需要显示新发布的评论，则返回数组，数组元素是WMGoodCommentInfo，否则返回NSString 提示信息，如果为nil，则回复失败
 */
+ (id)goodCommentReplyResultFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];

    if([WMUserOperation resultFromDictionary:dic])
    {
        NSDictionary *dataDic = [dic dictionaryForKey:WMHttpData];
        NSDictionary *comlist = [dataDic dictionaryForKey:@"comlist"];

        NSArray *items = [comlist arrayForKey:@"items"];

        if(items)
        {
            NSMutableArray *infos = [NSMutableArray arrayWithCapacity:items.count];

            for(NSDictionary *dict in items)
            {
                [infos addObject:[WMGoodCommentInfo infoFromDictionary:dict]];
            }

            return infos;
        }
        else
        {
            ///
            return [dic sea_stringForKey:WMHttpMessage];
        }
    }
    else
    {
        NSString *errMsg = [WMUserOperation errorMsgFromDictionary:dic alertErrorMsg:NO];
        [[AppDelegate instance] alertMsg:errMsg];
    }
    
    return nil;
}

/**获取商品评价规则 参数
 */
+ (NSDictionary*)goodCommentRuleParams
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"b2c.member.nodiscuss", WMHttpMethod, nil];
}

/**获取商品评价规则 结果
 *@return 规则信息
 */
+ (WMGoodCommentRuleInfo*)goodCommentRuleFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];

    if([WMUserOperation resultFromDictionary:dic])
    {
        NSDictionary *dataDic = [dic dictionaryForKey:WMHttpData];
        return [WMGoodCommentRuleInfo infoFromDictionary:dataDic];
    }
    
    return nil;
}

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
+ (NSDictionary*)goodCommentAddParamsWithGoodId:(NSString*) goodId productId:(NSString*) productId orderId:(NSString*) orderId content:(NSString*) content anonymous:(BOOL) anonymous code:(NSString*) code scores:(NSArray*) scores images:(NSArray*) images
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"b2c.comment.toDiscuss", WMHttpMethod, goodId, @"goods_id", productId, @"product_id", orderId, @"order_id", content, @"comment", nil];

    [dic setObject:anonymous ? @"YES" : @"NO" forKey:@"hidden_name"];

    if(code)
    {
        [dic setObject:code forKey:@"discussverifyCode"];
    }

    for(WMGoodCommentScoreInfo *info in scores)
    {
        [dic setObject:[NSNumber numberWithInt:info.score] forKey:[NSString stringWithFormat:@"point_type[%@][point]", info.Id]];
    }
    
    for(int i = 0;i < images.count;i ++)
    {
        WMImageUploadInfo *info = [images objectAtIndex:i];
        [dic setObject:info.imageInfo.imageId forKey:[NSString stringWithFormat:@"images[%d]", i]];
    }

    return dic;
}

/**添加商品评论结果
 *@return 是否成功
 */
+ (BOOL)goodCommentAddResultFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];

    if([WMUserOperation resultFromDictionary:dic])
    {
        return YES;
    }
    else
    {
        [WMUserOperation errorMsgFromDictionary:dic alertErrorMsg:YES];
    }

    return NO;
}

/**上传图片 参数
 */
+ (NSDictionary*)uploadImageParam
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"b2c.member.uploadImg", WMHttpMethod, nil];
}

/**上传图片 结果
 *@return 图片信息
 */
+ (WMImageInfo*)uploadImageResultFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
 
    if([WMUserOperation resultFromDictionary:dic])
    {
        NSDictionary *dict = [dic dictionaryForKey:WMHttpData];
        if(dict)
        {
            return [WMImageInfo infoFromDictionary:dict];
        }
    }
    else
    {
        [WMUserOperation errorMsgFromDictionary:dic alertErrorMsg:YES];
    }
    
    return nil;
}


@end

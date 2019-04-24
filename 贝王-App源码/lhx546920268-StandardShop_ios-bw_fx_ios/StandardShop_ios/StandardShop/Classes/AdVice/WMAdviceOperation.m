//
//  WMAdviceOperation.m
//  StandardShop
//
//  Created by mac on 16/6/2.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMAdviceOperation.h"
#import "WMAdviceSettingInfo.h"
#import "WMAdviceQuestionInfo.h"
#import "WMAdviceTypeInfo.h"
#import "WMUserOperation.h"

@implementation WMAdviceOperation

/**发布咨询 参数
 *@param 商品ID goodID
 *@param 匿名 isHiddenName
 *@param 咨询内容 content
 *@param 咨询类型ID adviceTypeID
 */
+ (NSDictionary *)returnCommitAdviceWithGoodID:(NSString *)goodID isHiddenName:(BOOL)isHiddenName content:(NSString *)content adviceTypeID:(NSString *)adviceTypeID askverifyCode:(NSString *)askverifyCode{
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    
    [param setObject:goodID forKey:@"goods_id"];
    
    [param setObject:content forKey:@"comment"];
    
    [param setObject:adviceTypeID forKey:@"gask_type"];
    
    [param setObject:isHiddenName ? @"YES" : @"NO" forKey:@"hidden_name"];
    
    [param setObject:@"b2c.comment.toAsk" forKey:WMHttpMethod];
    
    if (askverifyCode) {
        
        [param setObject:askverifyCode forKey:@"askverifyCode"];
    }
    
    return param;
}
/**发布咨询 结果
 */
+ (BOOL)returnCommitAdviceResultWithData:(NSData *)data{
    
    NSDictionary *dict = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if ([WMUserOperation resultFromDictionary:dict]) {
        
        return YES;
    }
    else{
        
        [WMUserOperation errorMsgFromDictionary:dict alertErrorMsg:YES];
    }
    
    return NO;
}
/**发布咨询后返回新的咨询类型标题
 */
+ (NSArray *)returnAdviceCommitSuccessTitlesArrWithDict:(NSDictionary *)dict{
    
    NSArray *gaskTypesArr = [dict arrayForKey:@"gask_type"];
    
    NSMutableArray *titlesArr = [NSMutableArray new];
    
    NSInteger allNewCount = 0;
    
    for (NSDictionary *typeDict in gaskTypesArr) {
        
        allNewCount += [[typeDict numberForKey:@"total"] integerValue];
        
        [titlesArr addObject:[NSString stringWithFormat:@"%@(%@)",[typeDict sea_stringForKey:@"name"],[typeDict sea_stringForKey:@"total"]]];
    }
    
    [titlesArr insertObject:[NSString stringWithFormat:@"全部咨询(%@)",[NSNumber numberWithInteger:allNewCount]] atIndex:0];
    
    return titlesArr;
}

/**返回咨询菜单栏的标题
 *@param adviceTypeInfoArr 咨询类型数组，内容是WMAdviceTypeInfo
 */
+ (NSArray *)returnMenuBarTitleArrWithAdviceTypeInfoArr:(NSArray *)adviceTypeInfoArr{
    
    NSMutableArray *titleArr = [NSMutableArray new];
    
    for (WMAdviceTypeInfo *typeInfo in adviceTypeInfoArr) {
        
        [titleArr addObject:[NSString stringWithFormat:@"%@(%@)",typeInfo.adviceTypeName,typeInfo.adviceTypeNumber]];
    }
    
    return titleArr;
}

/**返回咨询列表第一页 参数
 *@param 商品ID goodID
 */
+ (NSDictionary *)returnAdviceListFirstPageParamWithGoodID:(NSString *)goodID{
    
    return @{WMHttpMethod:@"b2c.product.goodsConsult",@"goods_id":goodID};
}
/**返回咨询列表第一页 结果
 *return @"setting"-WMAdviceSettingInfo
 *return @"type"-WMAdviceTypeInfo
 *return @"list"-WMAdviceQuestionInfo
 *return @"total"-NSNumber
 */
+ (NSDictionary *)returnAdviceListResultWithData:(NSData *)data{
    
    NSDictionary *dict = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if ([WMUserOperation resultFromDictionary:dict]) {
        
        NSDictionary *dataDict = [dict dictionaryForKey:WMHttpData];
        
        NSDictionary *commentDict = [dataDict dictionaryForKey:@"comments"];
        
        WMAdviceSettingInfo *settingInfo = [WMAdviceSettingInfo returnAdviceSettingInfoWithDict:[commentDict dictionaryForKey:@"setting"]];
        
        NSNumber *total = [NSNumber numberWithInteger:[WMUserOperation totalSizeFromDictionary:dataDict]];
        
        NSArray *typeInfoArr = [WMAdviceTypeInfo returnAdviceTypeInfoArrWithDataArr:[commentDict arrayForKey:@"gask_type"]];
        
        NSDictionary *listDict = [commentDict dictionaryForKey:@"list"];
        
        NSMutableArray *questionInfoArr = [NSMutableArray new];
        
        if (listDict) {
            
            [questionInfoArr addObjectsFromArray:[WMAdviceQuestionInfo returnAdviceContentInfoArrWithDictArr:[listDict arrayForKey:@"ask"]]];
        }
        
        return @{@"setting":settingInfo,@"type":typeInfoArr,@"list":questionInfoArr,@"total":total};
    }
    else{
        
        return nil;
    }
}

/**返回咨询列表翻页 参数
 *@param 商品ID goodID
 *@param 页码 page
 *@param 咨询类型ID typeID
 */
+ (NSDictionary *)returnAdviceListPageParamWithGoodID:(NSString *)goodID page:(NSInteger)page typeID:(NSString *)typeID{
    
    return @{WMHttpMethod:@"b2c.comment.getAsk",@"goods_id":goodID,@"type_id":typeID,@"page":[NSNumber numberWithInteger:page]};
}
/**返回咨询列表翻页 结果
 *return NSArray-WMAdviceQuestionInfo
 *return NSNumber-数据总量
 */
+ (NSDictionary *)returnAdviceListPageResultWithData:(NSData *)data{
    
    NSDictionary *dict = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if ([WMUserOperation resultFromDictionary:dict]) {
        
        NSDictionary *dataDict = [dict dictionaryForKey:WMHttpData];
        
        NSDictionary *listDict = [[dataDict dictionaryForKey:@"comments"] dictionaryForKey:@"list"];
        
        NSMutableArray *arr = [NSMutableArray new];
        
        if (listDict) {
            
            [arr addObjectsFromArray:[WMAdviceQuestionInfo returnAdviceContentInfoArrWithDictArr:[listDict arrayForKey:@"ask"]]];
        }
        
        NSNumber *total = [NSNumber numberWithInteger:[WMUserOperation totalSizeFromDictionary:dataDict]];
        
        return @{@"total":total,@"list":arr};
    }
    else{
        
        return nil;
    }
}

/**回复咨询 参数
 *@param 咨询ID adviceID
 *@param 回复内容 comment
 *@param 验证码 replyverifyCode
 */
+ (NSDictionary *)returnReplyAdviceWithAdviceID:(NSString *)adviceID comment:(NSString *)comment replyverifyCode:(NSString *)replyverifyCode{
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    
    [param setObject:@"b2c.comment.toReply" forKey:WMHttpMethod];
    
    [param setObject:adviceID forKey:@"id"];
    
    [param setObject:comment forKey:@"comment"];
    
    if (replyverifyCode) {
        
        [param setObject:replyverifyCode forKey:@"replyverifyCode"];
    }
    
    return param;
}
/**回复咨询 结果
 */
+ (BOOL)returnReplyAdviceResultWithData:(NSData *)data{
    
    NSDictionary *dict = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if ([WMUserOperation resultFromDictionary:dict]) {
        
        return YES;
    }
    else{
        
        [WMUserOperation errorMsgFromDictionary:dict alertErrorMsg:YES];
    }
    
    return NO;
}














@end

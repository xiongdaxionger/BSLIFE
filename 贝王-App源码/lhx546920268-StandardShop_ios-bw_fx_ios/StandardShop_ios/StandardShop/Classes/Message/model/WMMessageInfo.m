//
//  WMMessageInfo.m
//  StandardShop
//
//  Created by 罗海雄 on 16/7/15.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMMessageInfo.h"

#import "WMAdviceContentInfo.h"
@implementation WMMessageInfo

///通过字典创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic
{
    WMMessageInfo *info = [[[self class] alloc] init];
    info.Id = [dic sea_stringForKey:@"comment_id"];
    info.title = [dic sea_stringForKey:@"title"];
    info.subtitle = [dic sea_stringForKey:@"comment"];
    info.read = [[dic sea_stringForKey:@"mem_read_status"] boolValue];
    info.time = [NSDate formatTimeInterval:[dic sea_stringForKey:@"time"] format:DateFormatYMdHms];
    
    return info;
}

@end


@implementation WMMessageActivityInfo

///通过字典创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic
{
    WMMessageActivityInfo *info = [super infoFromDictionary:dic];
    info.imageURL = [dic sea_stringForKey:@"img"];
    info.activityURL = [dic sea_stringForKey:@"hot_link"];
    
    return info;
}

@end

@implementation WMMessageOrderInfo

///通过字典创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic
{
    WMMessageOrderInfo *info = [super infoFromDictionary:dic];
    info.orderId = [dic sea_stringForKey:@"order_id"];
    
    NSArray *goods = [dic arrayForKey:@"goods"];
    NSDictionary *dict = [goods firstObject];
    info.imageURL = [dict sea_stringForKey:@"image_default_id"];
    
    dict = [dic dictionaryForKey:@"delivery"];
    if([[dict sea_stringForKey:@"status"] boolValue])
    {
        info.delvieryId = [dict sea_stringForKey:@"delivery_id"];
        info.logistics = [dict sea_stringForKey:@"logi_name"];
    }
    
    return info;
}

@end

@implementation WMMessageSystemInfo

- (NSInteger)numberOfRows
{
    NSInteger count = 0;
    switch (self.subtype)
    {
        case WMMessageSystemInfoConsult :
        {
            if (self.adviceQuestionInfo.adviceAnswerInfoArr.count > WMShowMoreInfoMaxCount) {
                
                if (self.adviceQuestionInfo.isShowMoreOpen) {
                    
                    return self.adviceQuestionInfo.adviceAnswerInfoArr.count + 4;
                }
                else{
                    
                    return WMShowMoreInfoMaxCount + 4;
                }
            }
            else{
                
                return self.adviceQuestionInfo.adviceAnswerInfoArr.count + 3;
            }
        }
            break;
        case WMMessageSystemInfoGoodComment :
        {
            count ++;
            if(self.goodInfo)
            {
                count ++;
            }
        }
            break;
        case WMMessageSubtypeSystem :
        {
            count ++;
        }
            break;
        default:
            break;
    }

    return count;
}

///通过字典创建
+ (instancetype)infoFromDictionary:(NSDictionary *)dic type:(WMMessageSubtype) type
{
    WMMessageSystemInfo *info = [super infoFromDictionary:dic];
    
    info.subtype = type;
    
    NSString *productId = [dic sea_stringForKey:@"product_id"];
    if(productId)
    {
        WMGoodInfo *goodInfo = [[WMGoodInfo alloc] init];
        goodInfo.goodName = [dic sea_stringForKey:@"name"];
        goodInfo.productId = productId;
        goodInfo.price = [dic sea_stringForKey:@"price"];
        goodInfo.imageURL = [dic sea_stringForKey:@"image_default_id"];
        info.goodInfo = goodInfo;
    }
    
    switch (type)
    {
        case WMMessageSystemInfoGoodComment :
        {
            info.read = [[dic numberForKey:@"unReadNum"] intValue] == 0;
            WMGoodCommentInfo *commentInfo = [WMGoodCommentInfo infoFromDictionary:dic];
            commentInfo.userInfo = [[WMUserInfo sharedUserInfo] copy];
            info.goodCommentInfo = commentInfo;
        }
            break;
        case WMMessageSubtypeSystem :
        {
            
        }
            break;
        case WMMessageSystemInfoConsult :
        {
            
            info.read = [[dic numberForKey:@"unReadNum"] intValue] == 0;
            WMAdviceQuestionInfo *questionInfo = [WMAdviceQuestionInfo new];
            
            questionInfo.adviceTime = [NSDate formatTimeInterval:[dic sea_stringForKey:@"time"] format:DateFormatYMdHms];
            
            questionInfo.type = AdviceTypeQuestion;
            
            questionInfo.adviceContent = [dic sea_stringForKey:@"comment"];
            
            questionInfo.adviceID = [dic sea_stringForKey:@"type"];
            
            questionInfo.isShowMoreOpen = NO;
            
            questionInfo.adviceAnswerInfoArr = [WMAdviceContentInfo returnAdviceContentInfoArrWithDictArr:[dic arrayForKey:@"items"]];
            
            info.adviceQuestionInfo = questionInfo;
        }
            break;
        default:
            break;
    }
    
    return info;
}

@end

@implementation WMMessageNoticeInfo

///通过字典创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic
{
    WMMessageNoticeInfo *info = [super infoFromDictionary:dic];
    info.imageURL = [dic sea_stringForKey:@"img"];
    info.articleId = [dic sea_stringForKey:@"article_id"];
    info.time = [NSDate formatTimeInterval:[dic sea_stringForKey:@"pubtime"] format:DateFromatYMd];
    
    return info;
}


@end

@implementation WMMessageCouponsInfo

///通过字典创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic
{
    WMMessageCouponsInfo *info = [super infoFromDictionary:dic];
    info.couponsInfo = [[WMCouponsInfo alloc] init];
    info.couponsInfo.name = [dic sea_stringForKey:@"coupon_name"];
    info.subtype = WMMessageSubtypeCoupons;
    
    return info;
}

@end

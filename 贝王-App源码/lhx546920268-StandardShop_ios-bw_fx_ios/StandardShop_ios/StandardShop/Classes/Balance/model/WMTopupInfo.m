//
//  WMTopupInfo.m
//  StandardShop
//
//  Created by 罗海雄 on 16/7/6.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMTopupInfo.h"
#import "WMPayMethodModel.h"
#import "WMTopupActivityInfo.h"

@implementation WMTopupInfo

///通过字典创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic
{
    ///支付方式
    NSArray *pays = [dic arrayForKey:@"payments"];
    NSMutableArray *infos = [NSMutableArray arrayWithCapacity:pays.count];
    for(NSDictionary *dict in pays)
    {
        [infos addObject:[WMPayMethodModel returnModelWith:dict]];
    }
    
    WMTopupInfo *info = [[WMTopupInfo alloc] init];
    info.payInfos = infos;
    info.amountSymbol = [dic sea_stringForKey:@"def_cur_sign"];
    
    ///充值活动
    NSDictionary *activityDic = [[dic dictionaryForKey:@"active"] dictionaryForKey:@"recharge"];
    if([[activityDic numberForKey:@"status"] boolValue])
    {
        NSArray *activitys = [activityDic arrayForKey:@"filter"];
      
        infos = [NSMutableArray arrayWithCapacity:activitys.count];
        
        for(NSDictionary *dict in activitys)
        {
            WMTopupActivityInfo *activity = [WMTopupActivityInfo infoFromDictionary:dict];
            
            NSString *title1 = [NSString stringWithFormat:@"充值%@%@ 赠\n", info.amountSymbol, activity.amount];
            NSString *title2 = [NSString isEmpty:activity.giving] ? @"" : activity.giving;
            
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", title1, title2]];
            [text addAttribute:NSFontAttributeName value:[UIFont fontWithName:MainFontName size:12.0] range:[text.string rangeOfString:title1]];
            activity.name = text;
            
            [infos addObject:activity];
        }
        info.activitys = infos;
    }
    
    info.editable = info.activitys.count == 0;
    
    
    
    return info;
}

@end

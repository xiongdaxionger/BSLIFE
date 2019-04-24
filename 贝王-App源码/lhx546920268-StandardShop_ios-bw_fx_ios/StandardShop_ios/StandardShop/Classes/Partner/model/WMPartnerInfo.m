//
//  WMPartnerInfo.m
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/2.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMPartnerInfo.h"
#import "WMShippingAddressOperation.h"

@implementation WMPartnerInfo

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.userInfo = [[WMUserInfo alloc] init];
    }
    
    return self;
}

///从字典中创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic
{
    WMPartnerInfo *info = [[WMPartnerInfo alloc] init];
    
    info.userInfo.userId = [dic sea_stringForKey:WMUserInfoId];
    info.userInfo.name = [dic sea_stringForKey:@"name"];
    
    info.userInfo.accountSecurityInfo = [[WMAccountSecurityInfo alloc] init];
    info.userInfo.accountSecurityInfo.phoneNumber = [dic sea_stringForKey:@"mobile"];
    info.userInfo.headImageURL = [dic sea_stringForKey:WMUserInfoHeadImageURL];
    
    NSDictionary *levelDic = [dic dictionaryForKey:@"lv"];
    NSString *name = [levelDic sea_stringForKey:@"name"];
    info.userInfo.level = [NSString isEmpty:name] ? @"" : [NSString stringWithFormat:@"(%@)",name];
    info.userInfo.levelNumber = [levelDic sea_stringForKey:@"member_lv_id"];
    info.orderCount = [[dic numberForKey:@"order_num"] intValue];
    
    info.earnAmount = [dic sea_stringForKey:@"income"];
    info.referral = [[dic numberForKey:@"nums"] intValue];
    
    NSDictionary *addrDic = [dic dictionaryForKey:@"addr"];
    info.area = [addrDic sea_stringForKey:@"area"];

    NSString *time = [dic sea_stringForKey:@"regtime"];
    info.registerTime = [NSDate formatTimeInterval:time format:DateFromatYMd];
    
    return info;
}

- (NSAttributedString*)orderCountAttributedString
{
    if(!_orderCountAttributedString)
    {
        NSString *order = [NSString stringWithFormat:@"%d", self.orderCount];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%@笔订单", order]];
        [text addAttribute:NSForegroundColorAttributeName value:WMPriceColor range:[text.string rangeOfString:order]];
        
        _orderCountAttributedString = [text copy];
    }
    
    return _orderCountAttributedString;
}

- (NSAttributedString*)earnAmountAttributedString
{
    if(!_earnAmountAttributedString)
    {
        NSString *amount = [NSString stringWithFormat:@"%@", [NSString isEmpty:self.earnAmount] ? @"0" : self.earnAmount];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"累计带来收入%@元", amount]];
        [text addAttribute:NSForegroundColorAttributeName value:WMPriceColor range:[text.string rangeOfString:amount]];
        
        _earnAmountAttributedString = [text copy];
    }
    
    return _earnAmountAttributedString;
}

@end

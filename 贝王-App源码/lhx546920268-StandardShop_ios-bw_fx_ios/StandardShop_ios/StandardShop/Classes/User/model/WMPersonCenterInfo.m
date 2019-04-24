//
//  WMPersonCenterInfo.m
//  StandardShop
//
//  Created by 罗海雄 on 16/6/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMPersonCenterInfo.h"

@implementation WMPersonCenterInfo

///从字典中创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic
{
    WMPersonCenterInfo *info = [[WMPersonCenterInfo alloc] init];

    NSDictionary *memberDic = [dic dictionaryForKey:@"member"];

    info.integral = [memberDic sea_stringForKey:@"usage_point"];
    info.balance = [memberDic sea_stringForKey:@"advance"];
    info.orderWaitePayCount = [[memberDic numberForKey:@"un_pay_orders"] intValue];
    info.orderWaiteDeliveryCount = [[memberDic numberForKey:@"un_ship_orders"] intValue];
    info.orderWaiteGoodsCount = [[memberDic numberForKey:@"un_received_orders"] intValue];
    info.orderWaiteCommentCount = [[memberDic numberForKey:@"un_discuss_orders"] intValue];
    info.orderRefundCount = [[memberDic numberForKey:@"aftersales_orders"] intValue];

    info.couponCount = [[memberDic numberForKey:@"coupon_num"] intValue];
    info.unreadMessageCount = [[memberDic numberForKey:@"un_readMsg"] intValue];

    info.goodCollectCount = [[memberDic numberForKey:@"favorite_num"] intValue];
    info.goodAccessCount = [[memberDic numberForKey:@"access_num"] intValue];
    info.openFenxiao = [[dic sea_stringForKey:@"distribution_status"] boolValue];
    info.openPresell = [[dic sea_stringForKey:@"prepare_status"] boolValue];
    info.addPartnerURL = [dic sea_stringForKey:@"referrals_url"];

    return info;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        self.integral = [aDecoder decodeObjectForKey:@"integral"];
        self.balance = [aDecoder decodeObjectForKey:@"balance"];
        self.orderWaitePayCount = [aDecoder decodeIntForKey:@"orderWaitePayCount"];
        self.orderWaiteDeliveryCount = [aDecoder decodeIntForKey:@"orderWaiteDeliveryCount"];
        self.orderWaiteGoodsCount = [aDecoder decodeIntForKey:@"orderWaiteGoodsCount"];
        self.orderWaiteCommentCount = [aDecoder decodeIntForKey:@"orderWaiteCommentCount"];
        self.orderRefundCount = [aDecoder decodeIntForKey:@"orderRefundCount"];

        self.couponCount = [aDecoder decodeIntForKey:@"couponCount"];
        self.unreadMessageCount = [aDecoder decodeIntForKey:@"unreadMessageCount"];
        self.goodCollectCount = [aDecoder decodeIntForKey:@"goodCollectCount"];
        self.addPartnerURL = [aDecoder decodeObjectForKey:@"addPartnerURL"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.integral forKey:@"integral"];
    [aCoder encodeObject:self.balance forKey:@"balance"];

    [aCoder encodeInt:self.orderWaitePayCount forKey:@"orderWaitePayCount"];
    [aCoder encodeInt:self.orderWaiteDeliveryCount forKey:@"orderWaiteDeliveryCount"];
    [aCoder encodeInt:self.orderWaiteGoodsCount forKey:@"orderWaiteGoodsCount"];
    [aCoder encodeInt:self.orderWaiteCommentCount forKey:@"orderWaiteCommentCount"];
    [aCoder encodeInt:self.orderRefundCount forKey:@"orderRefundCount"];

    [aCoder encodeInt:self.couponCount forKey:@"couponCount"];
    [aCoder encodeInt:self.unreadMessageCount forKey:@"unreadMessageCount"];
    [aCoder encodeInt:self.goodCollectCount forKey:@"goodCollectCount"];
    [aCoder encodeObject:self.addPartnerURL forKey:@"addPartnerURL"];
}

- (NSString*)balance
{
    if([NSString isEmpty:_balance])
        return @"0";

    
    return _balance;
}

- (NSString*)integral
{
    if([NSString isEmpty:_integral])
        return @"0";

    return _integral;
}

@end

//
//  WMBalanceInfo.m
//  StandardShop
//
//  Created by 罗海雄 on 16/7/5.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMBalanceInfo.h"

@implementation WMBalanceInfo

- (NSString*)balance
{
    if(!_balance)
        return @"0.00";
    return _balance;
}

- (NSString*)commission
{
    if(!_commission)
        return @"0.00";

    return _commission;
}

- (NSString*)cumulativeCommission
{
    if(!_cumulativeCommission)
        return @"0.00";
    return _cumulativeCommission;
}

- (NSString*)freezeCommission
{
    if(!_freezeCommission)
        return @"0.00";
    return _freezeCommission;
}

- (NSString*)withdrawing
{
    if(!_withdrawing)
        return @"0.00";
    return _withdrawing;
}

- (NSString*)cumulativeWithdraw
{
    if(!_cumulativeWithdraw)
        return @"0.00";
    return _cumulativeWithdraw;
}

///通过字典创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic
{
    WMBalanceInfo *info = [[WMBalanceInfo alloc] init];
    
    NSDictionary *advance = [dic dictionaryForKey:@"advance"];
    info.balance = [advance sea_stringForKey:@"total"];
    NSDictionary *commisionDict = [dic dictionaryForKey:@"commision"];
    info.commission = [commisionDict sea_stringForKey:@"total"];
    info.freezeCommission = [commisionDict sea_stringForKey:@"freeze"];
    info.cumulativeCommission = [commisionDict sea_stringForKey:@"sum"];
    info.withdrawing = [dic sea_stringForKey:@"txing"];
    info.cumulativeWithdraw = [dic sea_stringForKey:@"tixian"];
    info.moneySymbol = [dic sea_stringForKey:@"cur"];
    info.enableWithdraw = [[dic sea_stringForKey:@"withdrawal_status"] boolValue];
    info.showCommission = [[dic sea_stringForKey:@"commision_status"] boolValue];
    info.withdrawingInstruction = [dic sea_stringForKey:@"txing_notice"];
    info.cumulativeWithdrawInstruction = [dic sea_stringForKey:@"tixian_notice"];
    
    return info;
}

/**获取余额列表信息
 *@return 数组元素是 WMBalanceListInfo
 */
- (NSArray*)balanceList
{
    NSMutableArray *infos = [NSMutableArray arrayWithCapacity:self.showCommission ? 4 : 2];

    WMBalanceListInfo *info = nil;

    if(self.showCommission)
    {
        info = [[WMBalanceListInfo alloc] init];
        info.title = @"累计佣金";
        info.amount = self.cumulativeCommission;
        info.msg = @"累计佣金";
        [infos addObject:info];

        info = [[WMBalanceListInfo alloc] init];
        info.title = @"冻结佣金";
        info.amount = self.freezeCommission;
        info.msg = @"冻结佣金";
        [infos addObject:info];
    }

    if (self.enableWithdraw) {
        
        info = [[WMBalanceListInfo alloc] init];
        info.title = @"正在提现";
        info.amount = self.withdrawing;
        info.msg = self.withdrawingInstruction;
        [infos addObject:info];
        
        info = [[WMBalanceListInfo alloc] init];
        info.title = @"累计提现";
        info.amount = self.cumulativeWithdraw;
        info.msg = self.cumulativeWithdrawInstruction;
        [infos addObject:info];
    }

    return infos;
}

@end

@implementation WMBalanceListInfo


@end

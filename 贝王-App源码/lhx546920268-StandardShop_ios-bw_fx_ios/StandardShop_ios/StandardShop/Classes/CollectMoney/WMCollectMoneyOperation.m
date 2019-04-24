//
//  WMCollectMoneyOperation.m
//  StandardFenXiao
//
//  Created by 罗海雄 on 16/3/8.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMCollectMoneyOperation.h"
#import "WMUserOperation.h"
#import "WMCollectMoneyInfo.h"

@implementation WMCollectMoneyOperation

/**生成收钱信息 参数
 *@param amount 收钱金额
 *@param title 收钱标题
 */
+ (NSDictionary*)collectMoneyParamWithAmount:(NSString*) amount title:(NSString*) title
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"b2c.wallet.collect", WMHttpMethod, amount, @"money", title, @"collect_desc",nil];
}

/**生成收钱信息 结果
 *@return 收钱信息，或nil，生成收钱信息失败
 */
+ (WMCollectMoneyInfo*)collectMoneyResultFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    
    NSLog(@"%@", dic);
    
    if([WMUserOperation resultFromDictionary:dic])
    {
        NSDictionary *dataDic = [dic dictionaryForKey:WMHttpData];
        
        WMCollectMoneyInfo *info = [[WMCollectMoneyInfo alloc] init];
        info.QRCodeURL = [dataDic sea_stringForKey:@"qrcode"];
        info.shareURL = [dataDic sea_stringForKey:@"link"];
        
        return info;
    }
    else
    {
        [WMUserOperation errorMsgFromDictionary:dic alertErrorMsg:YES];
    }
    
    return nil;
}

@end

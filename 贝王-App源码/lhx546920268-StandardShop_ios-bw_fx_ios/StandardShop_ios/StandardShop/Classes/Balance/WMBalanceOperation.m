//
//  WMBalanceOperation.m
//  StandardShop
//
//  Created by 罗海雄 on 16/7/6.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMBalanceOperation.h"
#import "WMUserOperation.h"
#import "WMPayMethodModel.h"
#import "WMTopupInfo.h"
#import "WMBalanceInfo.h"
#import "WMUserInfo.h"
#import "WMWithDrawInfo.h"
#import "WMWithDrawAccountInfo.h"
#import "SeaTextFieldCell.h"
#import "WMBalanceInfo.h"

@implementation WMBalanceOperation

/**余额信息 参数
 */
+ (NSDictionary*)balanceInfoParams
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"b2c.wallet.index", WMHttpMethod, nil];
}

/**余额信息 结果
 *@return 余额信息
 */
+ (WMBalanceInfo*)balanceInfoFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if([WMUserOperation resultFromDictionary:dic])
    {
        NSDictionary *dataDic = [dic dictionaryForKey:WMHttpData];
        return [WMBalanceInfo infoFromDictionary:dataDic];
    }
    
    return nil;
}

/**获取充值信息 参数
 */
+ (NSDictionary*)topupInfoParams
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"b2c.member.deposit", WMHttpMethod, nil];
}

/**获取充值信息 结果
 *@return WMTopupInfo 充值信息
 */
+ (WMTopupInfo*)topupInfoFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];

    if([WMUserOperation resultFromDictionary:dic])
    {
        NSDictionary *dataDic = [dic dictionaryForKey:WMHttpData];
        return [WMTopupInfo infoFromDictionary:dataDic];
    }
    else
    {
        [WMUserOperation errorMsgFromDictionary:dic alertErrorMsg:NO];
    }

    return nil;
}

/**充值 参数
 *@param amount 充值金额
 *@param paymentId 支付方式id
 */
+ (NSDictionary*)topupParamsWithAmount:(NSString*) amount paymentId:(NSString*) paymentId
{
    return @{WMHttpMethod:@"b2c.member.dopayment_recharge",@"payment[money]":amount,@"payment[pay_app_id]":paymentId};
}

/**获取充值支付结果
 *@return 支付参数字典
 */
+ (NSDictionary*)topupResultFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];

    if([WMUserOperation resultFromDictionary:dic])
    {
        return [dic dictionaryForKey:WMHttpData];
    }
    else
    {
        [WMUserOperation errorMsgFromDictionary:dic alertErrorMsg:YES];
    }

    return nil;
}

/**底部视图
 */
- (UIView *)returnFooterView{

    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width_, 70)];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];

    btn.titleLabel.font = WMLongButtonTitleFont;

    [btn setTitleColor:WMButtonTitleColor forState:UIControlStateNormal];

    [btn setTitle:@"确认" forState:UIControlStateNormal];

    [btn addTarget:self action:@selector(commitGetMoney:) forControlEvents:UIControlEventTouchUpInside];

    [btn setBackgroundColor:WMButtonBackgroundColor];

    btn.layer.cornerRadius = 3.0;

    btn.layer.masksToBounds = YES;

    btn.frame = CGRectMake(15.0, footer.height - 45.0, _width_ - 15.0 * 2, 45.0);

    [footer addSubview:btn];

    return footer;
}

- (void)commitGetMoney:(UIButton *)button{

    !self.commitButtonAction ?: self.commitButtonAction();
}

/**顶部视图
 */
- (UIView *)returnSegementControlView{

    UISegmentedControl *segement = [[UISegmentedControl alloc] initWithItems:@[@"银行卡",@"支付宝"]];

    segement.frame = CGRectMake(15.0, 10.0, _width_ - 30.0, 30.0);

    segement.selectedSegmentIndex = 0;

    segement.tintColor = WMButtonBackgroundColor;

    [segement setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:WMButtonTitleColor, NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    [segement setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];

    [segement addTarget:self action:@selector(segementValueChange:) forControlEvents:UIControlEventValueChanged];

    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width_, 40.0)];

    [backView addSubview:segement];

    return backView;
}

- (void)segementValueChange:(UISegmentedControl *)segement{

    !self.segementAction ?: self.segementAction(segement);
}

/**提现的说明数据 参数
 */
+ (NSDictionary *)returnWithDrawInfoParam{

    return @{WMHttpMethod:@"b2c.wallet.withdrawalNotice"};
}
/**提现的说明数据 结果
 */
+ (WMWithDrawInfo *)returnWithDrawInfoWithData:(NSData *)data{

    NSDictionary *dict = [NSJSONSerialization JSONDictionaryWithData:data];

    if ([WMUserOperation resultFromDictionary:dict]) {

        return [WMWithDrawInfo returnWithDrawInfoWithArr:[dict arrayForKey:WMHttpData]];
    }
    else{

        [WMUserOperation errorMsgFromDictionary:dict alertErrorMsg:NO];
    }

    return nil;
}

/**提交提现 参数
 */
+ (NSDictionary *)returnCommitWithDrawParamWithMoney:(NSString *)moneyStr accountNumber:(NSString *)account payPassWord:(NSString *)payPassWord{

    return @{WMHttpMethod:@"b2c.wallet.withdrawal",@"money":moneyStr,@"member_bank_id":account,@"pay_password":payPassWord};
}
/**提交提现 结果
 */
+ (BOOL)returnCommitWithDrawResultWithData:(NSData *)data{

    NSDictionary *dict = [NSJSONSerialization JSONDictionaryWithData:data];

    if ([WMUserOperation resultFromDictionary:dict]) {

        return YES;
    }
    else{

        [WMUserOperation errorMsgFromDictionary:dict alertErrorMsg:YES];
    }

    return NO;
}

/**获取提现账户列表 参数
 */
+ (NSDictionary *)returnAccountInfosListParam{

    return @{WMHttpMethod:@"b2c.wallet.get_banklists"};
}
/**获取提现账户列表 结果
 @return 字典 key为info--数组 元素是WMWithDrawAccountInfo key为code--图形验证码
 */
+ (NSDictionary *)returnAccountInfosListResultWithData:(NSData *)data{

    NSDictionary *dict = [NSJSONSerialization JSONDictionaryWithData:data];

    if ([WMUserOperation resultFromDictionary:dict]) {
        
        NSDictionary *dataDict = [dict dictionaryForKey:WMHttpData];
        
        NSArray *infos = [WMWithDrawAccountInfo returnInfoArrWith:[dataDict arrayForKey:@"banklists"]];

        NSString *code = [dataDict sea_stringForKey:@"code_url"];
        
        return @{@"info":infos,@"code":[NSString isEmpty:code] ? @"" : code};
    }
    else{

        [WMUserOperation errorMsgFromDictionary:dict alertErrorMsg:NO];
    }

    return nil;
}

/**删除提现账号 参数
 *@param 账号ID member_bank_id
 */
+ (NSDictionary *)returnDeleteAccountParamWithAccountID:(NSString *)accountID{

    return @{WMHttpMethod:@"b2c.wallet.delete_bankcard",@"member_bank_id":accountID};
}
/**删除提现账号 结果
 */
+ (BOOL)returnDeleteAccountResultWithData:(NSData *)data{

    NSDictionary *dict = [NSJSONSerialization JSONDictionaryWithData:data];

    if ([WMUserOperation resultFromDictionary:dict]) {

        return YES;
    }
    else{

        [WMUserOperation errorMsgFromDictionary:dict alertErrorMsg:YES];
    }

    return NO;
}

/**获取银行信息 参数
 */
+ (NSDictionary*)blankListParams
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"b2c.wallet.banklist", WMHttpMethod, nil];
}

/**从返回的数据获取银行信息
 *@return 数组元素是 NSString
 */
+ (NSArray*)blankListFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];

    if([WMUserOperation resultFromDictionary:dic])
    {
        return [[dic dictionaryForKey:WMHttpData] allKeys];
    }
    else
    {
        [WMUserOperation errorMsgFromDictionary:dic alertErrorMsg:NO];
    }

    return nil;
}

/**添加提现账号 参数
 *@param 账号类型 NSInteger
 *@param 单元配置数组
 */
+ (NSDictionary *)returnAddAccountParamWith:(NSMutableArray *)infoCellsArr accountType:(NSInteger)type phoneCode:(NSString *)phoneCode{

    NSString *accountType;

    SeaTextFieldInfo *info;

    NSString *account;

    NSString *accountPersonName;

    NSString *accountName;

    if (type == 0) {

        info = [infoCellsArr objectAtIndex:0];

        account = info.cell.textField.text;

        info = [infoCellsArr objectAtIndex:1];

        accountPersonName = info.cell.textField.text;

        info = [infoCellsArr objectAtIndex:2];

        accountName = info.cell.textField.text;

        accountType = @"1";
    }
    else{

        info = [infoCellsArr objectAtIndex:0];

        account = info.cell.textField.text;

        info = [infoCellsArr objectAtIndex:1];

        accountPersonName = info.cell.textField.text;

        accountName = @"支付宝";

        accountType = @"2";
    }

    NSString *phoneNumber = [WMUserInfo sharedUserInfo].accountSecurityInfo.phoneNumber;
    return @{WMHttpMethod:@"b2c.wallet.addbankcard",@"vcode":phoneCode,@"bank_num":account,@"bank_name":accountName,@"real_name":accountPersonName,@"bank_type":accountType,@"mobile":phoneNumber};
}
/**添加提现账号 结果
 */
+ (BOOL)returnAddAccountResultWithData:(NSData *)data{

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

//
//  WMTopupViewController.m
//  WestMailDutyFee
//
//  Created by 罗海雄 on 15/8/31.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMTopupViewController.h"
#import "WMTopupTableHeader.h"
#import "WMTopupThirdPayCell.h"
#import "WMBalanceOperation.h"
#import "WMPayMethodModel.h"
#import "WMDoPaymemtClient.h"
#import "WMTopupInfo.h"
#import "WMTopupFooter.h"
#import "WMTopupActivityCell.h"
#import "WXApi.h"

@interface WMTopupViewController ()<SeaHttpRequestDelegate>

///底部菜单
@property(nonatomic,strong) WMTopupFooter *footer;

/*网络请求
 */
@property(nonatomic,strong) SeaHttpRequest *httpRequest;

/**表头
 */
@property(nonatomic,strong) WMTopupTableHeader *header;

/**选中的支付方式
 */
@property(nonatomic,strong) NSIndexPath *selectedIndexPath;

/**支付
 */
@property(nonatomic,strong) WMDoPaymemtClient *doPayMentClient;

@end

@implementation WMTopupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.topupInfo.amount.floatValue > 0 ? @"充值确认" : @"充值";
    self.backItem = YES;
    
    self.httpRequest = [[SeaHttpRequest alloc] initWithDelegate:self];
    
    self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:self.topupInfo.selectedActivityInfo == nil ? 0 : 1];

    [self initialization];
}

- (void)initialization
{
    self.style = UITableViewStyleGrouped;
    [super initialization];

    [self.tableView registerNib:[UINib nibWithNibName:@"WMTopupThirdPayCell" bundle:nil] forCellReuseIdentifier:@"WMTopupThirdPayCell"];
    [self.tableView registerClass:[WMTopupActivityNoTopupBtnCell class] forCellReuseIdentifier:@"WMTopupActivityNoTopupBtnCell"];
    
    self.tableView.backgroundColor = _SeaViewControllerBackgroundColor_;
    
    self.header = [[WMTopupTableHeader alloc] init];
    [self.header.account_textField setDefaultInputAccessoryViewWithTarget:self action:@selector(reconverKeyBord)];
    self.tableView.tableHeaderView = self.header;

    self.tableView.height -= WMTopupFooterHeight;

    self.footer = [[WMTopupFooter alloc] init];
    self.footer.top = self.tableView.bottom;
    [self.footer.topupButton addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.footer];

    if(self.topupInfo.amount.floatValue != 0)
    {
        self.header.account_textField.text = self.topupInfo.amount;
        self.header.account_textField.enabled = self.topupInfo.editable;
    }

    [self.header.account_textField addTarget:self action:@selector(amountDidChange:) forControlEvents:UIControlEventEditingChanged];
    /**添加第三方支付结果监听
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(thirdPayDidFinish:) name:OrderDoPayCallBackResultNotification object:nil];

    [self amountDidChange:self.header.account_textField];
    
    ///添加滑动返回手势
    if([self.navigationController.sea_transitioningDelegate isKindOfClass:[SeaPresentTransitionDelegate class]] && self.navigationController.viewControllers.count == 1)
    {
        SeaPresentTransitionDelegate *delegate = self.navigationController.sea_transitioningDelegate;
        [delegate addInteractiveTransitionToViewController:self];
    }
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark- 通知

/**支付结果
 */
- (void)thirdPayDidFinish:(NSNotification*) notification
{
    DoPayCallBackType type = [[notification.userInfo objectForKey:OrderDoPayStatusKey] integerValue];
    
    switch (type)
    {
        case DoPayCallBackTypeSuccess :
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:WMDidTopupNotification object:nil];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"充值成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
            break;
        case DoPayCallBackTypeFail :
        case DoPayCallBackTypeUnkonw :
        {
            [self alertMsg:@"充值失败"];
        }
            break;
        case DoPayCallBackTypeCancel :
        {
            [self alertMsg:@"充值取消"];
        }
            break;
    }
}

#pragma mark- UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self back];
}

#pragma mark- touch action

//回收键盘
- (void)reconverKeyBord
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

///充值金额变更
- (void)amountDidChange:(UITextField*) textField
{
    self.footer.amountLabel.text = [NSString stringWithFormat:@"%@%.2f", self.topupInfo.amountSymbol, textField.text.floatValue];
}

//确认充值
- (void)confirm:(id) sender
{
    
    if([NSString isEmpty:_header.account_textField.text])
    {
        [self alertMsg:@"请输入充值金额"];
        return;
    }

    NSString *amount = [self.header.account_textField.text stringByReplacingOccurrencesOfString:self.topupInfo.amountSymbol withString:@""];
    float value = [amount floatValue];

    if(value < WMTopupInputLimitMin || [_header.account_textField.text sea_lastCharacter] == '.')
    {
        [self alertMsg:[NSString stringWithFormat:@"充值金额不得少于%.2f元", WMTopupInputLimitMin]];
        
        return;
    }
    
    [self reconverKeyBord];
    
    
    
    WMPayMethodModel *info = [self.topupInfo.payInfos objectAtIndex:self.selectedIndexPath.row];

    if ([info.payInfoID isEqualToString:WMWxPayID]) {
        
        if (![WXApi isWXAppInstalled]) {
            
            [[AppDelegate instance] alertMsg:@"没有安装微信客户端，请切换支付方式"];
            
            return;
        }
    }
    
    self.requesting = YES;
    self.showNetworkActivity = YES;
    self.httpRequest.identifier = WMTopupIdentifier;
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMBalanceOperation topupParamsWithAmount:amount paymentId:info.payInfoID]];
}

#pragma mark- http

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
    if([request.identifier isEqualToString:WMTopupIdentifier])
    {
        self.requesting = NO;
        self.showNetworkActivity = NO;
        [self alerBadNetworkMsg:@"充值失败"];
        return;
    }
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{
    if([request.identifier isEqualToString:WMTopupIdentifier])
    {
        NSDictionary *dic = [WMBalanceOperation topupResultFromData:data];

        if(dic != nil)
        {
            WMPayMethodModel *info = [self.topupInfo.payInfos objectAtIndex:self.selectedIndexPath.row];
        
            NSMutableDictionary *mutabDic = [[NSMutableDictionary alloc] initWithDictionary:dic];

            [mutabDic setObject:_header.account_textField.text forKey:@"total_amount"];

            [mutabDic setObject:[NSString stringWithFormat:@"%@预存款充值",appName()] forKey:@"body"];

            self.doPayMentClient = [[WMDoPaymemtClient alloc] initWithPaymemtDict:mutabDic payAppID:info.payInfoID];

            [self.doPayMentClient callClientToPay];
        }

        self.requesting = dic == nil;
    }
}

#pragma mark- UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.topupInfo.selectedActivityInfo != nil ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0 && self.topupInfo.selectedActivityInfo != nil)
        return 1;

    return self.topupInfo.payInfos.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.section == 0 && self.topupInfo.selectedActivityInfo != nil) ? WMTopupActivityCellHeight : WMTopupThirdPayCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return WMTopupSectionHeaderHeight;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *headerIdentifier = @"header";

    WMTopupSectionHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentifier];
    if(!header)
    {
        header = [[WMTopupSectionHeader alloc] initWithReuseIdentifier:headerIdentifier];
    }

    header.titleLabel.text = (section == 0 && self.topupInfo.selectedActivityInfo != nil) ? @"您将获得以下赠品" : @"支付方式";

    return header;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 && self.topupInfo.selectedActivityInfo != nil)
    {
        WMTopupActivityNoTopupBtnCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WMTopupActivityNoTopupBtnCell" forIndexPath:indexPath];

        cell.info = self.topupInfo.selectedActivityInfo;

        return cell;
    }
    else
    {
        WMPayMethodModel *info = [self.topupInfo.payInfos objectAtIndex:indexPath.row];

        static NSString *cellIdentifier = @"WMTopupThirdPayCell";
        WMTopupThirdPayCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

        cell.title_label.text = info.payInfoName;
        cell.subtitle_label.text = info.payInfoDesc;
        [cell.icon_imageView sea_setImageWithURL:info.payInfoIcon];

        cell.tick_imageView.highlighted = indexPath.row == self.selectedIndexPath.row;
        
        return cell;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self reconverKeyBord];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self reconverKeyBord];

    if(indexPath.section != 0 || self.topupInfo.selectedActivityInfo == nil)
    {
        if(![indexPath isEqual:self.selectedIndexPath])
        {
            if(self.selectedIndexPath)
            {
                WMTopupThirdPayCell *cell = (WMTopupThirdPayCell*)[tableView cellForRowAtIndexPath:self.selectedIndexPath];
                cell.tick_imageView.highlighted = NO;
            }

            self.selectedIndexPath = indexPath;
            WMTopupThirdPayCell *cell = (WMTopupThirdPayCell*)[tableView cellForRowAtIndexPath:self.selectedIndexPath];
            cell.tick_imageView.highlighted = YES;
        }
    }
}

@end

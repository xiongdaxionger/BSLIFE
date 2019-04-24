//
//  WMTopupActivityViewController.m
//  StandardShop
//
//  Created by 罗海雄 on 16/7/6.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMTopupActivityViewController.h"
#import "WMTopupInfo.h"
#import "WMTopupActivityCell.h"
#import "WMTopupAcvitityHeader.h"
#import "WMTopupActivityTableFooter.h"
#import "WMTopupViewController.h"
#import "WMTopupActivityInfo.h"

@interface WMTopupActivityViewController ()<WMTopupActivityCellDelegate>

///头部
@property(nonatomic,strong) WMTopupAcvitityHeader *header;

@end

@implementation WMTopupActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"充值有礼";
    
    self.backItem = YES;

    [self initialization];
}

- (void)initialization
{
    self.style = UITableViewStyleGrouped;

    self.header = [[WMTopupAcvitityHeader alloc] init];
    [self.header.textField setDefaultInputAccessoryViewWithTarget:self action:@selector(reconverKeyBord)];
    [self.header.topupButton addTarget:self action:@selector(topupAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.header];

    [super initialization];

    [self.tableView registerNib:[UINib nibWithNibName:@"WMTopupActivityCell" bundle:nil] forCellReuseIdentifier:@"WMTopupActivityCell"];
    self.tableView.backgroundColor = _SeaViewControllerBackgroundColor_;
    self.tableView.rowHeight = WMTopupActivityCellHeight;

    CGRect frame = self.tableView.frame;
    frame.size.height -= self.header.height;
    frame.origin.y = self.header.bottom;
    if (isIPhoneX) {
        
        frame.size.height -= 35.0;
    }
    self.tableView.frame = frame;

    if(![NSString isEmpty:self.topupInfo.rule])
    {
        WMTopupActivityTableFooter *footer = [[WMTopupActivityTableFooter alloc] initWithRule:self.topupInfo.rule];
        self.tableView.tableFooterView = footer;
    }
    
    ///添加滑动返回手势
    if([self.navigationController.sea_transitioningDelegate isKindOfClass:[SeaPresentTransitionDelegate class]] && self.navigationController.viewControllers.count == 1)
    {
        SeaPresentTransitionDelegate *delegate = self.navigationController.sea_transitioningDelegate;
        [delegate addInteractiveTransitionToViewController:self];
    }
}

///充值
- (void)topupAction:(id) sender
{
    if([NSString isEmpty:self.header.textField.text])
    {
        [self alertMsg:@"请输入充值金额"];
        return;
    }

    NSString *amount = [self.header.textField.text stringByReplacingOccurrencesOfString:self.topupInfo.amountSymbol withString:@""];
    float value = [amount floatValue];

    if(value < WMTopupInputLimitMin || [self.header.textField.text sea_lastCharacter] == '.')
    {
        [self alertMsg:[NSString stringWithFormat:@"充值金额不得少于%.2f元", WMTopupInputLimitMin]];
        return;
    }

    ///获取对应的赠品
    if(self.topupInfo.activitys.count > 0)
    {
        WMTopupActivityInfo *selectedInfo = nil;
        for(WMTopupActivityInfo *info in self.topupInfo.activitys)
        {
            if(info.amount.floatValue <= value && info.amount.floatValue > selectedInfo.amount.floatValue)
            {
                selectedInfo = info;
            }
        }
        
        self.topupInfo.selectedActivityInfo = selectedInfo;
    }
    
    [self reconverKeyBord];

    self.topupInfo.amount = amount;
    [self confirmWithAmount:amount];
}

///回收键盘
- (void)reconverKeyBord
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

#pragma mark- UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.topupInfo.activitys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return WMTopupActivityCellInterval;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return section == self.topupInfo.activitys.count - 1 ? WMTopupActivityCellInterval : CGFLOAT_MIN;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMTopupActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WMTopupActivityCell" forIndexPath:indexPath];
    cell.info = [self.topupInfo.activitys objectAtIndex:indexPath.section];
    cell.delegate = self;

    return cell;
}

#pragma mark- WMTopupActivityCell delegate

- (void)topupActivityCellDidTopup:(WMTopupActivityCell *)cell
{
    self.topupInfo.selectedActivityInfo = cell.info;
    [self confirmWithAmount:cell.info.amount];
}

///确认充值
- (void)confirmWithAmount:(NSString*) amount
{
    self.topupInfo.amount = amount;
    self.topupInfo.editable = NO;

    WMTopupViewController *topup = [[WMTopupViewController alloc] init];
    topup.topupInfo = self.topupInfo;
    [self.navigationController pushViewController:topup animated:YES];
}

@end

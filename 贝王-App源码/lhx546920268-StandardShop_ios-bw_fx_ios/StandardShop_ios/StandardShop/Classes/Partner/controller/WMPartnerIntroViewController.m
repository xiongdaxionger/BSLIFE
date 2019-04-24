//
//  WMPartnerDetailIntroViewController.m
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/3.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMPartnerIntroViewController.h"
#import "WMPartnerIntroCell.h"
#import "WMPartnerIntroInfo.h"
#import "WMPartnerLevelView.h"

@interface WMPartnerIntroViewController ()<SeaHttpRequestDelegate>

@end

@implementation WMPartnerIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
//    [self.infos addObject:[WMPartnerIntroInfo infoWithTitle:@"会员等级：" content:@""]];
    [self.infos addObject:[WMPartnerIntroInfo infoWithTitle:@"累计下单：" content:[NSString stringWithFormat:@"%d", self.info.orderCount]]];
    [self.infos addObject:[WMPartnerIntroInfo infoWithTitle:@"带来收益：" content:self.info.earnAmount]];
    [self.infos addObject:[WMPartnerIntroInfo infoWithTitle:@"联系电话：" content:self.info.userInfo.accountSecurityInfo.phoneNumber]];
    [self.infos addObject:[WMPartnerIntroInfo infoWithTitle:@"收货地区：" content:self.info.area]];
    [self.infos addObject:[WMPartnerIntroInfo infoWithTitle:@"注册时间：" content:self.info.registerTime]];
    
    [self initialization];
    [self.tableView registerClass:[WMPartnerIntroLevelCell class] forCellReuseIdentifier:@"WMPartnerIntroLevelCell"];
    [self.tableView registerClass:[WMPartnerIntroCell class] forCellReuseIdentifier:@"WMPartnerIntroCell"];
    self.tableView.rowHeight = WMPartnerIntroCellHeight;
}

#pragma mark- http

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
    
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{
    
}

#pragma mark- UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMPartnerIntroInfo *info = [self.infos objectAtIndex:indexPath.row];
    
    UIFont *font = WMPartnerIntroCellFont;
    CGFloat y = (WMPartnerIntroCellHeight - font.lineHeight) / 2.0;
    
    return info.contentHeight + y * 2;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(indexPath.row == 0)
//    {
//        WMPartnerIntroInfo *info = [self.infos objectAtIndex:indexPath.row];
//        WMPartnerIntroLevelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WMPartnerIntroLevelCell" forIndexPath:indexPath];
//        cell.titleWidth = info.titleWidth;
//        cell.titleLabel.text = info.title;
//        cell.levelView.info = self.info;
//        
//        return cell;
//    }
//    else
//    {
        WMPartnerIntroCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WMPartnerIntroCell" forIndexPath:indexPath];
        cell.info = [self.infos objectAtIndex:indexPath.row];
        
        return cell;
//    }
}

@end

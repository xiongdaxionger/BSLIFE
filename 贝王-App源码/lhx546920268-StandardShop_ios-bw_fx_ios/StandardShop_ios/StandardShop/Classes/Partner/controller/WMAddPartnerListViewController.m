//
//  WMAddCustomerViewController.m
//  WestMailDutyFee
//
//  Created by mac on 15/9/17.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMAddPartnerListViewController.h"
#import "WMAddPartnerViewCell.h"
#import "WMPartnerInviteQRCodeViewController.h"
#import "WMShareActionSheet.h"
#import "WMAddPartnerViewController.h"
#import "WMUserInfo.h"

@interface WMAddPartnerListViewController ()

///列表信息，数组原始是NSDictionary
@property(nonatomic, strong) NSArray *infos;

///网络请求
@property(nonatomic,strong) SeaHttpRequest *httpRequest;

@end

@implementation WMAddPartnerListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.backItem = YES;
    
    self.title = @"新增会员";
    
    self.infos = @[@{@"imagename":@"partner_invite_icon",@"invite":@"直接邀请",@"content":@"分享到微信/QQ等渠道，好友点击注册并下载登陆即可成为会员。"},
                  @{@"imagename":@"partner_qrcode_icon",@"invite":@"二维码邀请",@"content":@"分享到微信等渠道，好友扫一扫或长按识别二维码后注册并登陆即可成为会员。"},
                  @{@"imagename":@"partner_add_icon",@"invite":@"添加会员",@"content":@"会员提供资料，代会员注册即可成为会员。"},
                 ];

    
    self.separatorEdgeInsets = UIEdgeInsetsZero;
    [self initialization];
}


 - (void)initialization
{
    [super initialization];
    UINib * nib = [UINib nibWithNibName:@"WMAddPartnerViewCell" bundle:nil];
    
    [self.tableView registerNib:nib forCellReuseIdentifier:@"WMAddPartnerViewCell"];
    
    CGRect frame = CGRectMake(0, 0, _width_, self.contentHeight);
    self.tableView.frame = frame;
    [self.tableView setExtraCellLineHidden];
}


#pragma mark- UITableView delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.infos.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150.0;
//    NSDictionary * dic = self.infos[indexPath.row];
//    NSString *content = [dic stringForKey:@"content"];
//    return MAX(100.0, [content stringSizeWithFont:[UIFont fontWithName:MainFontName size:14.0] contraintWith:_width_ - 36.0 - 98.0].height + 25.0 + 20.0);
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMAddPartnerViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"WMAddPartnerViewCell" forIndexPath:indexPath];
    
    cell.dic = self.infos[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0 :
        {
            WMShareActionSheet * share = [[WMShareActionSheet alloc]init];
            share.shareContentView.shareType = WMShareTypeAddPartner;
            share.shareContentView.navigationController = self.navigationController;
            [share show];
        }
            break;
        case 1 :
        {
            WMPartnerInviteQRCodeViewController *qrcode = [[WMPartnerInviteQRCodeViewController alloc]init];
            [self.navigationController pushViewController:qrcode animated:YES];
        }
            break;
        case 2 :
        {
            WMAddPartnerViewController *add = [[WMAddPartnerViewController alloc] init];
            [self.navigationController pushViewController:add animated:YES];
        }
            break;
        default:
            break;
    }
}
@end

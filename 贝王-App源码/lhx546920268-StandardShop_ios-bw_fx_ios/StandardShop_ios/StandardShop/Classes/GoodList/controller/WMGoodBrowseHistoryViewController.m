//
//  WMGoodBrowseHistoryViewController.m
//  StandardShop
//
//  Created by 罗海雄 on 16/6/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodBrowseHistoryViewController.h"
#import "WMBrowseHistoryDataBase.h"
#import "WMGoodBrowseHistoryCell.h"
#import "WMGoodInfo.h"
#import "WMGoodDetailContainViewController.h"

@interface WMGoodBrowseHistoryViewController ()<UIActionSheetDelegate>

///商品信息 数组元素是 WMGoodInfo
@property(nonatomic,strong) NSMutableArray *infos;

@end

@implementation WMGoodBrowseHistoryViewController

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backItem = YES;
    self.title = @"我的足迹";
    
    self.infos = [WMBrowseHistoryDataBase browseHistoryList];
    [self initialization];
}

- (void)initialization
{
    self.style = UITableViewStyleGrouped;
    
    [self setBarItemsWithTitle:@"清空" icon:nil action:@selector(clear) position:SeaNavigationItemPositionRight];
    
    self.rightBarButtonItem.enabled = self.infos.count > 0;
    
    [super initialization];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WMGoodBrowseHistoryCell" bundle:nil] forCellReuseIdentifier:@"WMGoodBrowseHistoryCell"];
    self.tableView.rowHeight = WMGoodBrowseHistoryCellHeight;
    
    self.tableView.height -= (isIPhoneX ? 35.0 : 0.0);
    
    self.tableView.backgroundColor = _SeaViewControllerBackgroundColor_;
    self.tableView.sea_shouldShowEmptyView = YES;
}

///删除所有浏览记录
- (void)clear
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"确定清空我的足迹？此操作不可逆" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"清空" otherButtonTitles:nil, nil];
    [actionSheet showInView:self.view];
}

#pragma mark- UIActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"清空"])
    {
        [self.infos removeAllObjects];
        [self.tableView reloadData];
        
        [WMBrowseHistoryDataBase deleteAllBrowseHistory];
        
        self.rightBarButtonItem.enabled = NO;
    }
}

#pragma mark- SeaEmptyView delgate

- (void)emptyViewWillAppear:(SeaEmptyView *)view
{
    view.textLabel.text = @"暂无浏览记录";
}

#pragma mark- UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.infos.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.infos.count > 0 ? 1 : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return self.infos.count > 0 ? 10.0 : CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMGoodBrowseHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WMGoodBrowseHistoryCell" forIndexPath:indexPath];
    
    cell.info = [self.infos objectAtIndex:indexPath.section];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WMGoodInfo *info = [self.infos objectAtIndex:indexPath.section];
    WMGoodDetailContainViewController *detail = [[WMGoodDetailContainViewController alloc] init];
    detail.productID = info.productId;
    detail.goodID = info.goodId;
    [self.navigationController pushViewController:detail animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ///删除浏览记录
    WMGoodInfo *info = [self.infos objectAtIndex:indexPath.section];
    [self.infos removeObjectAtIndex:indexPath.section];
    
    [self.tableView beginUpdates];
    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    
    [WMBrowseHistoryDataBase deleteBrowseHistoryWithProductId:info.productId];
}

@end

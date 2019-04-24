//
//  WMShippingAddressListViewController.m
//  WuMei
//
//  Created by 罗海雄 on 15/7/22.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "WMShippingAddressListViewController.h"
#import "WMShippingAddressInfo.h"
#import "WMShipingAddressListViewCell.h"
#import "WMShippingAddressEditViewController.h"
#import "WMUserInfo.h"

@interface WMShippingAddressListViewController ()<SeaHttpRequestDelegate,WMShipingAddressListViewCellDelegate>

/**网络请求
 */
@property(nonatomic,strong) SeaHttpRequest *httpRequest;

/**选中的cell ,即要编辑的 收货地址
 */
@property(nonatomic,strong) NSIndexPath *selectedIndexPath;

@end

@implementation WMShippingAddressListViewController

- (id)init
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
    
    self.view.backgroundColor = [UIColor whiteColor];
    if(self.wantSelectInfo)
    {
        self.title = @"选择收货地址";
    }
    else{
        self.title = @"收货地址";
    }
    
    self.backItem = YES;
    if(self.shippingInfos.count > 0)
    {
        [self initialization];
    }
    else
    {
        
        if(!self.shippingInfos)
        {
            self.shippingInfos = [NSMutableArray array];
        }
        
        self.httpRequest = [[SeaHttpRequest alloc] initWithDelegate:self];
        [self reloadDataFromNetwork];
    }
    
    //添加收货地址操作通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addressDidOperation:) name:WMShippingAddressOperaionDidFinishNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WMShippingAddressOperaionDidFinishNotification object:nil];
}

- (void)initialization
{
    self.style = UITableViewStyleGrouped;
    [super initialization];
    
    
    for(NSInteger i =0; i < _shippingInfos.count;i ++)
    {
        WMShippingAddressInfo *info = [_shippingInfos objectAtIndex:i];
        if(self.selectedAddrInfo.Id == info.Id)
        {
            self.selectedAddrInfo = info;
            break;
        }
    }
    
    UINib *nib = [UINib nibWithNibName:@"WMShipingAddressListViewCell" bundle:nil];
    
    [self.tableView registerNib:nib forCellReuseIdentifier:@"WMShipingAddressListViewCell"];
    
    self.tableView.rowHeight = WMShipingAddressListViewCellHeight;
    
    self.tableView.backgroundColor = _SeaViewControllerBackgroundColor_;
    self.tableView.sea_shouldShowEmptyView = YES;
    
    CGFloat margin = 15.0;
    CGFloat buttonHeight = 40.0;
    //新增收货地址按钮
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width_, buttonHeight + margin)];
    footer.backgroundColor = [UIColor clearColor];
    
//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width_, _separatorLineWidth_)];
//    line.backgroundColor = _separatorLineColor_;
//    [footer addSubview:line];
    
   
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:WMButtonTitleColor forState:UIControlStateNormal];
    [btn setTitle:@"新增地址" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:MainFontName size:18];
    [btn setBackgroundColor:WMButtonBackgroundColor];
    [btn setFrame:CGRectMake(margin, 0, _width_ - margin * 2, buttonHeight)];
    btn.layer.cornerRadius = 3.0;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(addShippingAddress) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:btn];
    
    self.tableView.height -= footer.height;
    if (isIPhoneX) {
        self.tableView.height -= 35.0;
    }
    footer.top = self.tableView.bottom;
    
    [self.view addSubview:footer];
}

//添加收货地址
- (void)addShippingAddress
{
    [self editShippingAddressWithInfo:nil];
}

- (void)editShippingAddressWithInfo:(WMShippingAddressInfo*) info
{
    WMShippingAddressEditViewController *edit = [[WMShippingAddressEditViewController alloc] initWithInfo:info];
    edit.canDeleteAddress = !self.wantSelectInfo;
    edit.selectMemberID = self.memberID;
    [self.navigationController pushViewController:edit animated:YES];
}

#pragma mark- SeaEmptyView delegate

- (void)emptyViewWillAppear:(SeaEmptyView *)view
{
    view.textLabel.text = @"暂无收货地址信息";
}

#pragma mark- http

//加载地址信息
- (void)reloadDataFromNetwork
{
    self.loading = YES;
    
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:@{WMHttpMethod:@"mobileapi.member.receiver",WMUserInfoId:self.memberID}];
}

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
    [self failToLoadData];
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{
    NSArray *infos = [WMShippingAddressOperation shippingAddressFromData:data];
    
    if(infos)
    {
        
        [self.shippingInfos addObjectsFromArray:infos];
        [self initialization];
    }
    else
    {
        
        [self failToLoadData];
    }
}

#pragma mark- 通知

//收货地址操作
- (void)addressDidOperation:(NSNotification*) notification
{
    WMShippingAddressOperationStyle operation = [[notification.userInfo objectForKey:WMShippingAddressOperationType] integerValue];
    WMShippingAddressInfo *info = [notification.userInfo objectForKeyedSubscript:WMShippingAddressOperaionInfo];
    
    if(info == nil)
        return;
    
    switch (operation)
    {
        case WMShippingAddressOperationAdded :
        {
            ///如果新增的是默认的收货地址，要把旧的默认地址改成非默认
            if(info.isDefaultAdr)
            {
                for(WMShippingAddressInfo *tInfo in self.shippingInfos)
                {
                    if(tInfo.isDefaultAdr)
                    {
                        tInfo.isDefaultAdr = NO;
                        break;
                    }
                }
            }
            
            [self.shippingInfos addObject:info];
            [self.tableView reloadData];
            
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.shippingInfos.count - 1] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
            break;
        case WMShippingAddressOperationDeleted :
        {
            if(self.selectedAddrInfo.Id == info.Id)
            {
                ///删除已选的收货地址
                [[NSNotificationCenter defaultCenter] postNotificationName:
                 WMShippingAddressOperaionDidFinishNotification object:self userInfo:
                 [NSDictionary dictionaryWithObjectsAndKeys:
                  [NSNumber numberWithInteger:WMShippingAddressOperationDeleted], WMShippingAddressOperationType, nil]];
                
                self.selectedAddrInfo = nil;
            }

            for(int i = 0;i < _shippingInfos.count;i ++)
            {
                WMShippingAddressInfo *tmp = [_shippingInfos objectAtIndex:i];
                if(tmp.Id == info.Id)
                {
                    [_shippingInfos removeObject:tmp];
                    break;
                }
            }
            [self.tableView reloadData];
        }
            break;
        case WMShippingAddressOperationModified :
        {
            ///如果修改的收货地址是 确认订单已选择的收货地址，要
            if(self.selectedAddrInfo.Id == info.Id)
            {
                self.selectedAddrInfo = info;

                ///修改已选的收货地址
                [[NSNotificationCenter defaultCenter] postNotificationName:
                 WMShippingAddressOperaionDidFinishNotification object:self userInfo:
                 [NSDictionary dictionaryWithObjectsAndKeys:
                  [NSNumber numberWithInteger:WMShippingAddressOperationSelected], WMShippingAddressOperationType, self.selectedAddrInfo, WMShippingAddressOperaionInfo, nil]];
            }
            
            ///如果修改的是默认的收货地址，要把旧的默认地址改成非默认
            if(info.isDefaultAdr)
            {
                for(WMShippingAddressInfo *tInfo in self.shippingInfos)
                {
                    if(tInfo.isDefaultAdr)
                    {
                        if(tInfo.Id != info.Id)
                        {
                            tInfo.isDefaultAdr = NO;
                            if(self.selectedAddrInfo.Id == tInfo.Id)
                            {
                                self.selectedAddrInfo.isDefaultAdr = NO;
                            }
                        }
                        break;
                    }
                }
            }
            
            [self.shippingInfos replaceObjectAtIndex:self.selectedIndexPath.section withObject:info];
            
            [self.tableView reloadData];
        }
            break;
        default:
            break;
    }
}

#pragma mark- UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _shippingInfos.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMShipingAddressListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WMShipingAddressListViewCell"];
    
    cell.info = [_shippingInfos objectAtIndex:indexPath.section];
    
    cell.delegate = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return section == self.shippingInfos.count - 1 ? 10.0 : CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(self.wantSelectInfo)
    {        
        WMShippingAddressInfo *info = [_shippingInfos objectAtIndex:indexPath.section];
        
        if(info.Id != self.selectedAddrInfo.Id)
        {
            ///选择的收货地址不一样
            [[NSNotificationCenter defaultCenter] postNotificationName:
             WMShippingAddressOperaionDidFinishNotification object:self userInfo:
             [NSDictionary dictionaryWithObjectsAndKeys:
              info, WMShippingAddressOperaionInfo,
              [NSNumber numberWithInteger:WMShippingAddressOperationSelected], WMShippingAddressOperationType, nil]];
        }
        [self back];
    }
}

#pragma mark- WMShippingAddressListCell delegate

- (void)shippingAddressListCellDidEdit:(WMShipingAddressListViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    self.selectedIndexPath = indexPath;
//    self.selectedAddrInfo = [self.shippingInfos objectAtIndex:indexPath.section];
    [self editShippingAddressWithInfo:[_shippingInfos objectAtIndex:indexPath.section]];
}

@end

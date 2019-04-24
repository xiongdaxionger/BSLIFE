//
//  WMShippMethodViewController.m
//  WanShoes
//
//  Created by mac on 16/3/15.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMShippMethodViewController.h"

#import "WMShippingMethodInfo.h"
#import "WMShippingOpeartion.h"
#import "WMConfirmOrderOperation.h"

#import "WMShippingTipViewCell.h"
#import "WMAreaInfo.h"

@interface WMShippMethodViewController ()<WMShippingTipViewCellDelegate,SeaHttpRequestDelegate,UIAlertViewDelegate>
/**选中的配送方式
 */
@property (strong,nonatomic) WMShippingMethodInfo *selectModel;
/**网络请求
 */
@property (strong,nonatomic) SeaHttpRequest *request;
@end

@implementation WMShippMethodViewController

#pragma mark - 控制器生命周期
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"配送方式";
    
    [self setupNavigationBarWithBackgroundColor:[UIColor whiteColor] titleColor:[UIColor blackColor] titleFont:nil];
    
    self.request = [[SeaHttpRequest alloc] initWithDelegate:self];
    
    [self configureUI];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - 初始化
- (void)initialization{
    
    self.style = UITableViewStyleGrouped;
    
    [super initialization];
    
    [self.tableView setBackgroundColor:_SeaViewControllerBackgroundColor_];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.frame = CGRectMake(0, 0, _width_, _height_ - 200);
        
    UINib *tipNib = [UINib nibWithNibName:@"WMShippingTipViewCell" bundle:nil];
    
    [self.tableView registerNib:tipNib forCellReuseIdentifier:WMShippingTipViewCellIden];
}

#pragma mark - 表格视图协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        
    return _shippingMethodArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return WMShippingTipViewCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        
    WMShippingMethodInfo *model = [self.shippingMethodArr objectAtIndex:indexPath.row];
    
    WMShippingTipViewCell *tipCell = [tableView dequeueReusableCellWithIdentifier:WMShippingTipViewCellIden forIndexPath:indexPath];
        
    [tipCell configureWithString:model];
    
    tipCell.delegate = self;
        
    return tipCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        
    _selectModel = [self.shippingMethodArr objectAtIndex:indexPath.row];
    
    if (_selectModel.isExpressProtect) {
        
        if (_selectModel.isExpressSelect) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您使用了该配送方式的物流保价，您需要取消使用物流保价吗？" message:[NSString stringWithFormat:@"%@",_selectModel.methodExpressMessage] delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消使用",@"继续使用",nil];
            
            [alertView show];
        }
        else{
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"该配送方式开启了物流保价，您需要使用物流保价吗？" message:[NSString stringWithFormat:@"%@",_selectModel.methodExpressMessage] delegate:self cancelButtonTitle:nil otherButtonTitles:@"需要",@"不需要",nil];
            
            [alertView show];
        }
    }
    else{
        
        [self selectShippingMethodRequestJsonString:self.selectModel.methodJsonValue];
    }
}

- (void)dismissSelf{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)configureUI{
    
    [self setBarItemsWithTitle:@"取消" icon:nil action:@selector(dismissSelf) position:SeaNavigationItemPositionRight];
    
    if (!self.tableView) {
        
        [self initialization];
    }
    
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (_selectModel.isExpressSelect) {
        
        if (buttonIndex == 0) {
            
            _selectModel.isExpressSelect = NO;
        }
    }
    else{
        
        for (WMShippingMethodInfo *info in self.shippingMethodArr) {
            
            if (![info.methodID isEqualToString:_selectModel.methodID]) {
                
                info.isExpressSelect = NO;
            }
        }
        
        if (buttonIndex == 0) {
            
            _selectModel.isExpressSelect = YES;
        }
    }
    
    [self selectShippingMethodRequestJsonString:self.selectModel.methodJsonValue];

}

#pragma mark - 协议
- (void)selectExpressProtectSelectCell:(UITableViewCell *)cell{
    
    NSIndexPath *selectIndex = [self.tableView indexPathForCell:cell];
    
    for (WMShippingMethodInfo *info in self.shippingMethodArr) {
        
        NSInteger index = [self.shippingMethodArr indexOfObject:info];
        
        info.isExpressSelect = index == selectIndex.row;
    }
    
    [self.tableView reloadData];
}

- (void)unSelectExpressProtectCell:(UITableViewCell *)cell{
    
    NSIndexPath *unSelectIndex = [self.tableView indexPathForCell:cell];
    
    WMShippingMethodInfo *info = [self.shippingMethodArr objectAtIndex:unSelectIndex.row];
    
    info.isExpressSelect = NO;
    
    [self.tableView reloadRowsAtIndexPaths:@[unSelectIndex] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - 选中配送方式
- (void)selectShippingMethodRequestJsonString:(NSString *)jsonString{
    
    self.request.identifier = WMSelectShippingMethodIdentifier;
    
    self.requesting = YES;
    
    [AppDelegate instance].showNetworkActivity = YES;
    
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMConfirmOrderOperation returnSelectShippingMethodWithShippingJsonValue:jsonString]];
}

#pragma mark - 网络请求协议
- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error{
    
    self.requesting = NO;
    
    [AppDelegate instance].showNetworkActivity = NO;
    
    [self alertMsg:@"网络错误，请重试"];
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data{
    
    self.requesting = NO;
    
    [AppDelegate instance].showNetworkActivity = NO;
    
    NSDictionary *selectShippingDataDict = [WMConfirmOrderOperation returnSelectShippingMethodResultWithData:data];
    
    if (selectShippingDataDict) {
        
        if (self.selectShippingCallBack) {
            
            self.selectShippingCallBack(_selectModel,[selectShippingDataDict sea_stringForKey:@"currency"],[selectShippingDataDict objectForKey:@"pay"]);
        }
        
        [self performSelector:@selector(dismissSelf) withObject:@(YES) afterDelay:0.3];
    }
}









@end

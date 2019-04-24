//
//  WMRefundMoneyDetailViewController.m
//  WanShoes
//
//  Created by mac on 16/4/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMRefundMoneyDetailViewController.h"

#import "XTableCellConfigEx.h"
#import "WMRefundDetailMoneyViewCell.h"
#import "WMFeedBackContactCell.h"
#import "WMFeedBackContentCell.h"
#import "WMRefundGoodViewCell.h"
#import "WMFeedBackBottomView.h"

#import "WMRefundOperation.h"
#import "WMRefundGoodModel.h"
#import "WMRefundOrderDetailModel.h"

@interface WMRefundMoneyDetailViewController ()<SeaHttpRequestDelegate>
/**订单详情模型
 */
@property (strong,nonatomic) WMRefundOrderDetailModel *orderDetailModel;
@end

@implementation WMRefundMoneyDetailViewController

#pragma mark - 控制器生命周期
- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        
        self.backItem = YES;
        
        self.title = @"申请退款";
        
        self.request = [[SeaHttpRequest alloc] initWithDelegate:self];
        
        self.showView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width_, self.contentHeight)];
        
        self.showView.backgroundColor = [UIColor clearColor];
        
        [self.showView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapShowView)]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadRefundTotalMoney) name:@"didChangeRefundMoney" object:nil];
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.loading = YES;
    
    [self getRefundMoneyOrderDetail];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 初始化
- (void)initialization{
    
    self.style = UITableViewStyleGrouped;
    
    [super initialization];
    
    [self.tableView setBackgroundColor:_SeaViewControllerBackgroundColor_];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [self.tableView setBackgroundView:nil];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.frame = CGRectMake(0, 0, _width_, self.contentHeight - self.tabBarHeight);
}

- (void)configureCellArr{
    
    XTableCellConfigEx *orderGood = [XTableCellConfigEx cellConfigWithClassName:[WMRefundGoodViewCell class] heightOfCell:WMRefundGoodViewCellHeight tableView:self.tableView isNib:YES];
    
    XTableCellConfigEx *orderInfo = [XTableCellConfigEx cellConfigWithClassName:[WMRefundDetailMoneyViewCell class] heightOfCell:WMRefundDetailMoneyViewCellHeight tableView:self.tableView isNib:YES];
    
    XTableCellConfigEx *orderReason = [XTableCellConfigEx cellConfigWithClassName:[WMFeedBackContactCell class] heightOfCell:kFeedBackContactViewHeight tableView:self.tableView isNib:YES];
    
    XTableCellConfigEx *orderDetail = [XTableCellConfigEx cellConfigWithClassName:[WMFeedBackContentCell class] heightOfCell:kFeedBackContentViewCellHeight tableView:self.tableView isNib:YES];
    
    _configArr = @[orderGood,orderInfo,orderReason,orderDetail];
}

- (void)configureBottomView{
    
    WeakSelf(self);
    
    WMFeedBackBottomView *bottomView = [[WMFeedBackBottomView alloc] initWithFrame:CGRectMake(0, self.tableView.bottom, _width_, self.tabBarHeight)];
    
    [bottomView setActionCallBack:^{
        
        BOOL canCommit = NO;
        
        for (WMRefundGoodModel *goodModel in weakSelf.orderDetailModel.orderGoodsArr) {
            
            if (goodModel.isSelect) {
                
                canCommit = YES;
                
                break;
            }
        }
        
        if (!canCommit) {
            
            [weakSelf alertMsg:@"请选择需要退款的商品"];
            
            return ;
        }
        
        if ([NSString isEmpty:weakSelf.reason]) {
            
            [weakSelf alertMsg:@"请输入退款理由"];
            
            return ;
        }
        
        weakSelf.requesting = YES;
        
        weakSelf.showNetworkActivity = YES;
        
        weakSelf.request.identifier = WMCommitRefundMoneyOrderIdentifier;
        
        [weakSelf.request downloadWithURL:SeaNetworkRequestURL dic:[WMRefundOperation returnCommitRefundOrderWith:weakSelf.reason detailReason:weakSelf.detailReason orderModel:weakSelf.orderDetailModel type:@"refund" imagesArr:nil]];
    }];
    
    [self.view addSubview:bottomView];
}
#pragma mark - 键盘

- (void)keyboardWillHide:(NSNotification *)notification
{
    [super keyboardWillHide:notification];
    
    [_showView removeFromSuperview];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    [super keyboardWillShow:notification];
    
    [self.view addSubview:_showView];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [self removeKeyboardNotification];
}

- (void)tapShowView{
        
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenShowView" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self addKeyboardNotification];
}

#pragma mark - 网络请求
- (void)getRefundMoneyOrderDetail{
    
    self.request.identifier = WMRefundMoneyDetailIdentifier;
    
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMRefundOperation returnRefundOrderDetailWithOrderID:self.orderID type:@"refund"]];
}

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error{
    
    self.requesting = NO;
    
    self.loading = NO;
    
    self.showNetworkActivity = NO;
    
    if ([request.identifier isEqualToString:WMRefundMoneyDetailIdentifier]) {
        
        [self failToLoadData];
    }
    else if ([request.identifier isEqualToString:WMCommitRefundMoneyOrderIdentifier]){
        
        [self alertMsg:@"网络错误，请重试"];
    }
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data{
    
    self.requesting = NO;
    
    self.loading = NO;
    
    self.showNetworkActivity = NO;
    
    if ([request.identifier isEqualToString:WMRefundMoneyDetailIdentifier]) {
        
        WMRefundOrderDetailModel *model = [WMRefundOperation returnRefundOrderDetailModelWithData:data];
        
        if (model) {
            
            _orderDetailModel = model;
            
            if (!self.tableView) {
                
                [self initialization];
                
                [self configureCellArr];
                
                [self configureBottomView];
            }
        }
        else{
            
            [self failToLoadData];
        }
    }
    else if ([request.identifier isEqualToString:WMCommitRefundMoneyOrderIdentifier]){
        
        if ([WMRefundOperation returnCommitRefundOrderResultWithData:data]) {
            
            if (self.actionCallBack) {
                
                self.actionCallBack();
            }
            
            [self alertMsg:@"申请成功"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"commitMoneyRefundSuccess" object:nil];
            
            [self performSelector:@selector(back) withObject:nil afterDelay:0.8];
        }
    }
}

- (void)reloadDataFromNetwork{
    
    self.requesting = YES;
    
    [self getRefundMoneyOrderDetail];
}

#pragma mark - 协议
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section) {
        
        return 3;
    }
    else{
        
        return _orderDetailModel.orderGoodsArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XTableCellConfigEx *config = [self findConfigWithIndexPath:indexPath];
    
    id model = [self findModelWithIndexPath:indexPath];
    
    id<XTableCellConfigExDelegate> cell = [config cellOfCellConfigWithTableView:tableView indexPath:indexPath];
    
    [cell configureCellWithModel:model];
    
    return (UITableViewCell *)cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XTableCellConfigEx *config = [self findConfigWithIndexPath:indexPath];
    
    if (indexPath.section) {
        
        if (indexPath.row == 1) {
            
            return kFeedBackContactViewHeight;
        }
    }
    
    return config.heightOfCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
}

- (XTableCellConfigEx *)findConfigWithIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section) {
        
        if (indexPath.row == 0) {
            
            return [_configArr objectAtIndex:1];
        }
        else if (indexPath.row == 1){
            
            return [_configArr objectAtIndex:2];
        }
        else{
            
            return [_configArr lastObject];
        }
    }
    else{
        
        return [_configArr firstObject];
    }
}

- (id)findModelWithIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section) {
        
        if (indexPath.row) {
            
            return self;
        }
        else{
            
            double total = 0.0;
            
            for (WMRefundGoodModel *goodModel in self.orderDetailModel.orderGoodsArr) {
                
                total += goodModel.isSelect ? (goodModel.salePrice.doubleValue * goodModel.refundFinalCount.doubleValue) : 0.0;
            }
            
            return @{@"title":@"预计退款总计",@"content":[NSString stringWithFormat:@"%.2f",total]};
        }
    }
    else{
        
        return [_orderDetailModel.orderGoodsArr objectAtIndex:indexPath.row];
    }
}

- (void)reloadRefundTotalMoney{
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
}








@end

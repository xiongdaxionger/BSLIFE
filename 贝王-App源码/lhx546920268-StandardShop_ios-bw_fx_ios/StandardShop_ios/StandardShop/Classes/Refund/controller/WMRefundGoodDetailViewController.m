//
//  WMRefundGoodDetailViewController.m
//  WanShoes
//
//  Created by mac on 16/4/8.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMRefundGoodDetailViewController.h"
#import "WMRefundReadViewController.h"

#import "XTableCellConfigEx.h"
#import "WMFeedBackContactCell.h"
#import "WMFeedBackContentCell.h"
#import "WMRefundGoodViewCell.h"
#import "WMFeedBackBottomView.h"
#import "WMRefundGoodTypeViewCell.h"
#import "WMCommitRefundGoodBottomView.h"
#import "WMGoodCommentImageUploadCell.h"

#import "WMRefundOperation.h"
#import "WMRefundOrderDetailModel.h"
#import "WMRefundGoodModel.h"
#import "WMImageUploadInfo.h"

@interface WMRefundGoodDetailViewController ()<SeaHttpRequestDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,WMGoodCommentImageUploadCellDelegate>
/**订单详情模型
 */
@property (strong,nonatomic) WMRefundOrderDetailModel *orderDetailModel;
/**选中的类型方式
 */
@property (assign,nonatomic) NSInteger selectIndex;
/**底部视图
 */
@property (strong,nonatomic) WMCommitRefundGoodBottomView *bottomView;
/**图片数组
 */
@property (strong,nonatomic) NSMutableArray *imagesFile;
/**图片上传单元格
 */
@property (strong,nonatomic) WMGoodCommentImageUploadCell *imageUpLoadCell;
@end

@implementation WMRefundGoodDetailViewController

#pragma mark - 控制器生命周期
- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        
        self.backItem = YES;
        
        self.title = @"申请售后";
        
        self.selectIndex = 0;
        
        self.imagesFile = [NSMutableArray new];
        
        self.request = [[SeaHttpRequest alloc] initWithDelegate:self];
        
        self.showView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width_, self.contentHeight)];
        
        self.showView.backgroundColor = [UIColor clearColor];
        
        [self.showView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapShowView)]];
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.loading = YES;
    
    [self getRefundGoodOrderDetail];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
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

#pragma mark - 初始化
- (void)initialization{
    
    self.style = UITableViewStyleGrouped;
    
    self.imageUpLoadCell = [[WMGoodCommentImageUploadCell alloc] initWithMaxCount:3];
    
    self.imageUpLoadCell.contentView.backgroundColor = [UIColor whiteColor];
        
    self.imageUpLoadCell.viewController = self;
    
    self.imageUpLoadCell.delegate = self;
    
    [super initialization];
    
    [self.tableView setBackgroundColor:_SeaViewControllerBackgroundColor_];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [self.tableView setBackgroundView:nil];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.frame = CGRectMake(0, 0, _width_, self.contentHeight - self.tabBarHeight);
}

- (void)configureCellArr{
    
    XTableCellConfigEx *orderGood = [XTableCellConfigEx cellConfigWithClassName:[WMRefundGoodViewCell class] heightOfCell:WMRefundGoodViewCellHeight tableView:self.tableView isNib:YES];
    
    XTableCellConfigEx *orderReason = [XTableCellConfigEx cellConfigWithClassName:[WMFeedBackContactCell class] heightOfCell:kFeedBackContactViewHeight tableView:self.tableView isNib:YES];
    
    XTableCellConfigEx *orderDetail = [XTableCellConfigEx cellConfigWithClassName:[WMFeedBackContentCell class] heightOfCell:kFeedBackContentViewCellHeight tableView:self.tableView isNib:YES];
    
    XTableCellConfigEx *refundType = [XTableCellConfigEx cellConfigWithClassName:[WMRefundGoodTypeViewCell class] heightOfCell:WMRefundGoodTypeViewCellHeight tableView:self.tableView isNib:YES];
    
    _configArr = @[orderGood,refundType,orderReason,orderDetail];
}

- (void)configureBottomView{
    
    WeakSelf(self);
    
    WMFeedBackBottomView *bottomView = [[WMFeedBackBottomView alloc] initWithFrame:CGRectMake(0, self.tableView.bottom, _width_, self.tabBarHeight)];
    
    [bottomView setActionCallBack:^{
        
        if (!weakSelf.bottomView.isAgree) {
            
            [weakSelf alertMsg:@"请同意售后服务"];
            
            return ;
        }
        
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
        
        NSArray *images = self.imageUpLoadCell.infos;
        
        for (WMImageUploadInfo *info in images) {
            
            [self.imagesFile addObject:info.imageInfo.imageId];
        }
        
        weakSelf.requesting = YES;
        
        weakSelf.showNetworkActivity = YES;
        
        weakSelf.request.identifier = WMCommitRefundGoodOrderIdentifier;
        
        [weakSelf.request downloadWithURL:SeaNetworkRequestURL dic:[WMRefundOperation returnCommitRefundOrderWith:weakSelf.reason detailReason:weakSelf.detailReason orderModel:weakSelf.orderDetailModel type:@"reship" imagesArr:self.imagesFile]];

    }];
    
    [self.view addSubview:bottomView];
}

#pragma mark - 网络请求
- (void)getRefundGoodOrderDetail{
    
    self.request.identifier = WMRefundGoodDetailIdentifier;
    
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMRefundOperation returnRefundOrderDetailWithOrderID:self.orderID type:@"reship"]];
}

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error{
    
    self.requesting = NO;
    
    self.loading = NO;
    
    self.showNetworkActivity = NO;
    
    if ([request.identifier isEqualToString:WMRefundGoodDetailIdentifier]) {
        
        [self failToLoadData];
    }
    else if ([request.identifier isEqualToString:WMCommitRefundGoodOrderIdentifier]){
        
        [self alertMsg:@"网络错误，请重试"];
    }
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data{
    
    self.requesting = NO;
    
    self.loading = NO;
    
    self.showNetworkActivity = NO;
    
    if ([request.identifier isEqualToString:WMRefundGoodDetailIdentifier]) {
        
        WMRefundOrderDetailModel *model = [WMRefundOperation returnRefundOrderDetailModelWithData:data];
        
        if (model) {
            
            _orderDetailModel = model;
            
            if (!self.tableView) {
                
                [self initialization];
                
                [self configureCellArr];
                
                [self configureTableViewBottomView];
                
                [self configureBottomView];
            }
        }
        else{
            
            [self failToLoadData];
        }
    }
    else if ([request.identifier isEqualToString:WMCommitRefundGoodOrderIdentifier]){
        
        if ([WMRefundOperation returnCommitRefundOrderResultWithData:data]) {
            
            if (self.actionCallBack) {
                
                self.actionCallBack();
            }
            
            [self alertMsg:@"申请成功"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"commitGoodRefundSuccess" object:nil];
            
            [self performSelector:@selector(back) withObject:nil afterDelay:0.8];
        }
    }
}

- (void)reloadDataFromNetwork{
    
    self.requesting = YES;
    
    [self getRefundGoodOrderDetail];
}

- (void)configureTableViewBottomView{
    
    WeakSelf(self);
    
    _bottomView = [[WMCommitRefundGoodBottomView alloc] init];
    
    [_bottomView setActionCallBack:^{
        
        WMRefundReadViewController *refundRead = [[WMRefundReadViewController alloc] init];
        
        [weakSelf.navigationController pushViewController:refundRead animated:YES];
    }];
    
    self.tableView.tableFooterView = _bottomView;
}

#pragma mark - 协议
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return _orderDetailModel.orderGoodsArr.count;
    }
    else if(section == 1){
        
        return _orderDetailModel.refundGoodType.count;
    }
    else if(section == 2){
        
        return 2;
    }
    else{
        
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 3) {
        
        return self.imageUpLoadCell;
    }
    else{
    
        XTableCellConfigEx *config = [self findConfigWithIndexPath:indexPath];
        
        id model = [self findModelWithIndexPath:indexPath];
        
        id<XTableCellConfigExDelegate> cell = [config cellOfCellConfigWithTableView:tableView indexPath:indexPath];
        
        [cell configureCellWithModel:model];
        
        return (UITableViewCell *)cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XTableCellConfigEx *config = [self findConfigWithIndexPath:indexPath];
    
    if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            
            return kFeedBackContactViewHeight;
        }
    }
    else if (indexPath.section == 3){
        
        return self.imageUpLoadCell.rowHeight;
    }
    
    return config.heightOfCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 3) {
        
        return CGFLOAT_MIN;
    }
    
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        
        [self selectTypeMethod:indexPath tableView:tableView];
    }
}

#pragma mark - 切换退换方式
- (void)selectTypeMethod:(NSIndexPath *)indexPath tableView:(UITableView *)tableView{
    
    if (self.selectIndex == indexPath.row) {
        
        return;
    }
    else{
        
        [self selectTypeMethod:tableView indexPath:indexPath image:[WMImageInitialization tickingIcon] isSelect:YES didSelect:YES];
        
        [self selectTypeMethod:tableView indexPath:[NSIndexPath indexPathForRow:self.selectIndex inSection:indexPath.section] image:[WMImageInitialization untickIcon] isSelect:NO didSelect:NO];
        
        self.selectIndex = indexPath.row;
    }
}

- (void)selectTypeMethod:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath image:(UIImage *)image isSelect:(BOOL)isSelect didSelect:(BOOL)didSelect{
    
    NSMutableDictionary *dict = _orderDetailModel.refundGoodType[indexPath.row];
    
    WMRefundGoodTypeViewCell *cell = (WMRefundGoodTypeViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    [cell.selectButton setImage:image forState:UIControlStateDisabled];
    
    [dict setObject:@(isSelect) forKey:@"isSelect"];
}

- (XTableCellConfigEx *)findConfigWithIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        
        return [_configArr objectAtIndex:1];
    }
    else if (indexPath.section == 2){
        
        if (indexPath.row == 0) {
            
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
    
    if (indexPath.section == 0) {
        
        return [_orderDetailModel.orderGoodsArr objectAtIndex:indexPath.row];
    }
    else if (indexPath.section == 1){
        
        return [_orderDetailModel.refundGoodType objectAtIndex:indexPath.row];
    }
    else{
        
        return self;
    }
}

- (void)goodCommentImageUploadCellHeightDidChange:(WMGoodCommentImageUploadCell *)cell{
    
    //UITableViewRowAnimationAutomatic动画效果的刷新会导致cell重用,不在重用队列里的WMGoodCommentImageUploadCell会无法显示
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
}












@end

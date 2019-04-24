//
//  WMShopCarViewController.m
//  StandardShop
//
//  Created by mac on 16/6/21.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMShopCarViewController.h"
#import "WMShopCarForOrderViewController.h"
#import "ConfirmOrderPageController.h"
#import "WMGoodDetailContainViewController.h"
#import "WMTabBarController.h"

#import "WMShopCartEmptyView.h"
#import "ShopCarContentViewCell.h"
#import "WMShopCarBottomView.h"
#import "WMShopCarGoodPromotionViewCell.h"
#import "WMShopCarUnusePromotionViewCell.h"
#import "XTableCellConfigEx.h"
#import "SeaEmptyView.h"

#import "WMShopCarOperation.h"
#import "WMUserInfo.h"
#import "WMGoodListOperation.h"
#import "WMShopCarInfo.h"
#import "WMShopCarGoodInfo.h"
#import "WMShopCarPromotionRuleInfo.h"
#import "WMConfirmOrderOperation.h"
#import "WMConfirmOrderInfo.h"

@interface WMShopCarViewController ()<SeaHttpRequestDelegate,UIAlertViewDelegate>
/**配置数组
 */
@property (strong,nonatomic) NSArray *configsArr;
/**导航栏右侧按钮
 */
@property (strong,nonatomic) UIButton *rightButton;
/**底部视图
 */
@property (strong,nonatomic) WMShopCarBottomView *bottomView;
@end

@implementation WMShopCarViewController

#pragma mark - 控制器生命周期
- (instancetype)initWithStyle:(UITableViewStyle)style{
    
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    if (self) {
        
        self.request = [[SeaHttpRequest alloc] initWithDelegate:self];
        
        self.showView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width_, self.contentHeight)];
        
        self.view.backgroundColor = _SeaViewControllerBackgroundColor_;
        
        self.showView.backgroundColor = [UIColor clearColor];
                
        [self.showView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapShowView)]];
        
        self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40.0, 40.0)];
        
        [self.rightButton.titleLabel setFont:[UIFont fontWithName:MainFontName size:15.0]];
        
        [self.rightButton setTitle:@"编辑" forState:UIControlStateNormal];
        
        [self.rightButton setTitleColor:WMTintColor forState:UIControlStateNormal];
                
        self.title = @"购物车";
        
        [self.rightButton addTarget:self action:@selector(editButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginDropDownRefresh) name:WMUserDidLogoutNotification object:nil];
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    self.showNetworkActivity = YES;
    
    [self reloadDataFromNetwork];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self addKeyboardNotification];
}

- (void)tapShowView{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tapShowView" object:nil];
}

#pragma mark - 初始化
- (void)initialization{
    
    [super initialization];
    
    [self cellConfigure];
    
    [self.tableView setBackgroundColor:_SeaViewControllerBackgroundColor_];
    
    CGFloat minusValue = 0.0;
    
    if (isIPhoneX && self.navigationController.viewControllers.count > 1) {
        
        minusValue = 35.0;
    }
    
    self.tableView.frame = CGRectMake(0, 0, _width_, self.contentHeight - 49.0 - minusValue);
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.separatorEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        
    self.enableDropDown = YES;
    
    self.tableView.sea_shouldShowEmptyView = YES;
}

- (void)emptyViewWillAppear:(SeaEmptyView *)view
{
    WMShopCartEmptyView *emptyView = [[WMShopCartEmptyView alloc] init];
    
    emptyView.height = self.tableView.height;
    
    [emptyView.shopping_btn addTarget:self action:@selector(goShopping:) forControlEvents:UIControlEventTouchUpInside];
    
    view.customView = emptyView;
}

- (void)configureBottomView{
    
    WeakSelf(self);
    
    self.bottomView = [[WMShopCarBottomView alloc] initWithFrame:CGRectMake(0, self.tableView.bottom, _width_, 49.0) shopCarModel:self.shopCarInfo];
    
    [self.bottomView setDeleteButtonClick:^(UIButton *button) {
        
        NSArray *selectsArr = [weakSelf.shopCarInfo returnCurrentShopCarSelectGoodsIdent:YES];
        
        if (!selectsArr.count) {
            
            [weakSelf alertMsg:@"请选择需要删除的商品"];
            
            return ;
        }
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定要删除商品吗?" delegate:weakSelf cancelButtonTitle:nil otherButtonTitles:@"取消",@"确定",nil];
        
        alertView.tag = 1001;
        
        [alertView show];
    }];
    
    [self.bottomView setPayButtonClick:^(UIButton *button) {
        
        NSArray *selectsArr = [weakSelf.shopCarInfo returnCurrentShopCarSelectGoodsIdent:NO];
        
        if (!selectsArr.count) {
            
            [weakSelf alertMsg:@"请选择需要结算的商品"];
            
            return ;
        }
        
        weakSelf.requesting = YES;
        
        weakSelf.showNetworkActivity = YES;
        
        weakSelf.request.identifier = WMCheckOutConfirmOrderIdentifier;
        
        [weakSelf.request downloadWithURL:SeaNetworkRequestURL dic:[WMConfirmOrderOperation returnConfirmOrderParamWithIsFastBuy:nil selectGoodsArr:selectsArr]];
    }];
    
    [self.bottomView setSelectAllClick:^(BOOL isSelectAll) {
        
        if (weakSelf.isEdit) {
            
            [weakSelf.shopCarInfo changeEditStatusSelect:isSelectAll];
            
            [weakSelf.tableView reloadData];
        }
        else{
            
            [weakSelf.shopCarInfo selectAllGoodIsSelect:isSelectAll];
            
            [weakSelf selectShopCarGoodRequest];
        }
    }];
    
    [self.view addSubview:self.bottomView];
}

#pragma mark - 下拉刷新
- (void)beginDropDownRefresh{
    
    [self reloadDataFromNetwork];
}

#pragma mark - 去购物
- (void)goShopping:(id)sender{
    
    if([AppDelegate tabBarController].selectedIndex == 0)
    {
        [self backToRootViewControllerWithAnimated:YES];
    }
    else
    {
        [[AppDelegate tabBarController] setSelectedIndex:0];
        
        [self backToRootViewControllerWithAnimated:NO];
    }
}
#pragma mark - 配置单元格
- (void)cellConfigure{
    
    XTableCellConfigEx *goodContentCell = [XTableCellConfigEx cellConfigWithClassName:[ShopCarContentViewCell class] heightOfCell:WMShopCarContentViewCellHeight tableView:self.tableView isNib:YES];
    
    XTableCellConfigEx *goodPromotionCell = [XTableCellConfigEx cellConfigWithClassName:[WMShopCarGoodPromotionViewCell class] heightOfCell:WMShopCarGoodPromotionViewCellHeight tableView:self.tableView isNib:YES];
    
    XTableCellConfigEx *unusePromotionCell = [XTableCellConfigEx cellConfigWithClassName:[WMShopCarUnusePromotionViewCell class] heightOfCell:WMShopCarUnusePromotionViewCellHeight tableView:self.tableView isNib:YES];
    
    _configsArr = @[goodContentCell,goodPromotionCell,unusePromotionCell];
}

#pragma mark - 网络请求
- (void)reloadDataFromNetwork{
    
    self.request.identifier = WMShopCarPageIdentifier;
    
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMShopCarOperation returnShopCarPageParam]];
}

- (void)addGoodFavRequestWithGoodID:(NSString *)goodID{
    
    self.requesting = YES;
    
    self.showNetworkActivity = YES;
    
    self.request.identifier = WMGoodCollectIdentifier;
    
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMGoodListOperation goodCollectParamWithType:0 goodId:goodID]];
}

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error{
    
    self.requesting = NO;
    
    self.showNetworkActivity = NO;
    
    if ([request.identifier isEqualToString:WMShopCarPageIdentifier]) {
        
        [self failToLoadData];
    }
    else if ([request.identifier isEqualToString:WMGoodCollectIdentifier] || [request.identifier isEqualToString:WMCheckOutConfirmOrderIdentifier]){
        
        [self alertMsg:@"网络错误，请重试"];
    }
    else if ([request.identifier isEqualToString:WMSelectShopCarGoodIdentifier] || [request.identifier isEqualToString:WMDeleteShopCarGoodIdentifier] || [request.identifier isEqualToString:WMShopCarChangeQuantityIdentifier]){
        
        [self reloadDataFromNetwork];
    }
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data{
    
    if ([request.identifier isEqualToString:WMShopCarPageIdentifier]) {
        
        self.requesting = NO;
        
        self.showNetworkActivity = NO;
        
        self.loading = NO;
        
        [self endDropDownRefreshWithMsg:nil];
        
        id info = [WMShopCarOperation returnShopCarPageResultWithData:data];
        
        if (!self.tableView) {
            
            [self initialization];
        }
        
        [self setBarItemWithCustomView:nil position:SeaNavigationItemPositionRight];
        
        if ([info isKindOfClass:[NSNumber class]]) {
            
            [WMShopCarOperation updateShopCarNumberQuantity:0 needChange:YES];
            
            self.isEdit = NO;
            
            [self.bottomView setIsEdit:NO];
            
            self.shopCarInfo = nil;
                        
            self.bottomView.hidden = YES;
            
            [self.tableView reloadData];
        }
        else if ([info isKindOfClass:[WMShopCarInfo class]]){
            
            self.shopCarInfo = info;
            
            if (!self.bottomView && self.shopCarInfo.shopCarGoodsArr.count) {
                
                [self configureBottomView];
            }
            else{
                
                self.bottomView.hidden = NO;
                
                [self.bottomView changeBuyInfoWithShopCarInfo:self.shopCarInfo];
            }
            
            [WMShopCarOperation updateShopCarNumberQuantity:[self.shopCarInfo returnCurrentUnSelectShopCarQuantity] needChange:YES];
            
            [self setHasNoMsgViewHidden:YES msg:nil];
            
            [self.rightButton setTitle:self.isEdit ? @"完成" : @"编辑" forState:UIControlStateNormal];
            
            if (self.isEdit) {
                
                [self.bottomView.selectAllImageButton setSelected:NO];
            }
            else{
                
                [self.bottomView.selectAllImageButton setSelected:[self.shopCarInfo returnCurrentShopCarSelectStatus]];
            }
            
            [self setBarItemWithCustomView:self.rightButton position:SeaNavigationItemPositionRight];
            
            [self.tableView reloadData];
        }
        else{
            
            [WMShopCarOperation updateShopCarNumberQuantity:0 needChange:YES];
            
            [self failToLoadData];
        }
    }
    else if ([request.identifier isEqualToString:WMGoodCollectIdentifier]){
        
        self.requesting = NO;
        
        self.showNetworkActivity = NO;
        
        if ([WMGoodListOperation goodCollectResultFromData:data]) {
            
            [self alertMsg:@"收藏商品成功"];
            
            WMShopCarGoodGroupInfo *groupInfo = [self.shopCarInfo.shopCarGoodsArr objectAtIndex:self.selectIndexPath.section];
            
            [groupInfo changeGoodFavStatusWithIndexPath:self.selectIndexPath];
            
            [self.tableView reloadRowsAtIndexPaths:@[self.selectIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    else if ([request.identifier isEqualToString:WMShopCarChangeQuantityIdentifier]){
        
//        [WMShopCarOperation returnModifyShopCarQuantityResultWithData:data];
        
        [self reloadDataFromNetwork];
    }
    else if ([request.identifier isEqualToString:WMSelectShopCarGoodIdentifier]){
        
        [self reloadDataFromNetwork];
    }
    else if ([request.identifier isEqualToString:WMDeleteShopCarGoodIdentifier]){
        
        if (self.isEdit) {
            
            [self reloadDataFromNetwork];
            
            return;
        }
        
        WMShopCarGoodGroupInfo *groupGoodInfo = [self.shopCarInfo.shopCarGoodsArr objectAtIndex:self.selectIndexPath.section];
        
        switch (groupGoodInfo.type) {
            case ShopCarGoodGroupTypeExchangeGroup:
            {
                [groupGoodInfo.goodInfosArr removeObjectAtIndex:self.selectIndexPath.row];
                
                [self.tableView beginUpdates];
                
                [self.tableView deleteRowsAtIndexPaths:@[self.selectIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                
                [self.tableView endUpdates];
            }
                break;
            case ShopCarGoodGroupTypeNormalGroup:
            {
                WMShopCarGoodInfo *normalGoodInfo = [groupGoodInfo.goodInfosArr firstObject];
                
                if (self.selectIndexPath.row) {
                    
                    [normalGoodInfo.goodGiftAdjunctsArr removeObjectAtIndex:self.selectIndexPath.row - 1];
                    
                    [self.tableView beginUpdates];
                    
                    [self.tableView deleteRowsAtIndexPaths:@[self.selectIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    
                    [self.tableView endUpdates];
                }
                else{
                    
                    [self.shopCarInfo.shopCarGoodsArr removeObjectAtIndex:self.selectIndexPath.section];
                    
                    [self.tableView beginUpdates];
                    
                    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:self.selectIndexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
                    
                    [self.tableView endUpdates];
                }
            }
            default:
                break;
        }
        
        [self reloadDataFromNetwork];
    }
    else if ([request.identifier isEqualToString:WMCheckOutConfirmOrderIdentifier]){
        
        self.requesting = NO;
        
        self.showNetworkActivity = NO;
        
        WMConfirmOrderInfo *info = [WMConfirmOrderOperation returnConfirmOrderResultWithData:data];
        
        if (info) {
            
            ConfirmOrderPageController *confirmOrder = [ConfirmOrderPageController new];
            
            confirmOrder.orderInfo = info;
            
            confirmOrder.isFastBuy = @"false";
            
            [self.navigationController pushViewController:confirmOrder animated:YES];
        }
    }
}

#pragma mark - 表格视图协议
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (!self.shopCarInfo) {
        
        return 0;
    }
    
    return [self.shopCarInfo returnSectionNumbers];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.shopCarInfo returnRowNumberOfSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XTableCellConfigEx *config = [self findConfig:indexPath];
    
    id model = [self findModel:indexPath];
    
    id<XTableCellConfigExDelegate> cell = [config cellOfCellConfigWithTableView:tableView indexPath:indexPath];
    
    [cell configureCellWithModel:model];
    
    return (UITableViewCell *)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XTableCellConfigEx *cellConfig = [self findConfig:indexPath];
    
    NSString *classNameString = NSStringFromClass(cellConfig.className);

    if ([classNameString isEqualToString:@"ShopCarContentViewCell"]) {
        
        return WMShopCarContentViewCellHeight;
    }
    else if ([classNameString isEqualToString:@"WMShopCarGoodPromotionViewCell"]){
        
        NSAttributedString *attrString = [self findModel:indexPath];
        
        return MAX(WMShopCarGoodPromotionViewCellHeight, [attrString boundsWithConstraintWidth:_width_ - WMShopCarGoodPromotionViewCellExtraFloat].height + 14.0);
    }
    else{
        
        WMShopCarPromotionRuleInfo *ruleInfo = [self findModel:indexPath];
        
        UIFont *font = [UIFont fontWithName:MainFontName size:15.0];
        
        CGFloat tagWidth = [ruleInfo.ruleTag stringSizeWithFont:font contraintWith:100].width + 20.0;
        
        return MAX(WMShopCarUnusePromotionViewCellHeight, [ruleInfo.ruleName stringSizeWithFont:font contraintWith:_width_ - tagWidth - WMShopCarUnusePromotionViewCellHeight].height + 18.0);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section >= 0 && section < self.shopCarInfo.shopCarGoodsArr.count) {
        
        WMShopCarGoodGroupInfo *groupInfo = [self.shopCarInfo.shopCarGoodsArr objectAtIndex:section];
        
        switch (groupInfo.type) {
            case ShopCarGoodGroupTypeNormalGroup:
                return 5.0;
                break;
            case ShopCarGoodGroupTypeExchangeGroup:
            case ShopCarGoodGroupTypeOrderGiftGroup:
                return 30.0;
                break;
            default:
                break;
        }
    }
    else{
        
        return 30.0;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XTableCellConfigEx *config = [self findConfig:indexPath];
    
    NSString *classNameString = NSStringFromClass(config.className);
    
    if ([classNameString isEqualToString:@"WMShopCarGoodPromotionViewCell"] || [classNameString isEqualToString:@"WMShopCarUnusePromotionViewCell"]) {
        
        return NO;
    }
    else{
        
        WMShopCarGoodGroupInfo *groupInfo = [self.shopCarInfo.shopCarGoodsArr objectAtIndex:indexPath.section];

        return [groupInfo returnCanEditWithIndexPath:indexPath];
    }
}

- (nullable NSArray*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WeakSelf(self);
    
    WMShopCarGoodGroupInfo *groupInfo = [self.shopCarInfo.shopCarGoodsArr objectAtIndex:indexPath.section];
    
    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        weakSelf.selectIndexPath = indexPath;
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定要删除商品吗?" delegate:weakSelf cancelButtonTitle:nil otherButtonTitles:@"取消",@"确定",nil];
        
        alertView.tag = 1002;
        
        [alertView show];
    }];
    
    UITableViewRowAction *favourite = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"收藏" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        weakSelf.selectIndexPath = indexPath;
        
        [weakSelf addGoodFavRequestWithGoodID:[groupInfo returnGoodIDWithIndexPath:indexPath]];
    }];
    
    
    switch (groupInfo.type) {
        case ShopCarGoodGroupTypeExchangeGroup:
        {
            WMShopCarExchangeGoodInfo *exchangeGoodInfo = [groupInfo.goodInfosArr objectAtIndex:indexPath.row];
            
            return exchangeGoodInfo.isFav ? @[delete] : @[delete,favourite];
        }
            break;
        case ShopCarGoodGroupTypeNormalGroup:
        {
            WMShopCarGoodInfo *normalGoodInfo = [groupInfo.goodInfosArr firstObject];
            
            if (indexPath.row == 0) {
                
                return normalGoodInfo.isFav ? @[delete] : @[delete,favourite];
            }
            else{
                
                id otherGoodInfo = [normalGoodInfo.goodGiftAdjunctsArr objectAtIndex:indexPath.row - 1];
                
                if ([otherGoodInfo isKindOfClass:[WMShopCarAdjunctGoodInfo class]]) {
                    
                    WMShopCarAdjunctGoodInfo *adjunctGoodInfo = (WMShopCarAdjunctGoodInfo *)otherGoodInfo;
                    
                    return adjunctGoodInfo.isFav ? @[delete] : @[delete,favourite];
                }
                else{
                    
                    return nil;
                }
                
            }
        }
            break;
        case ShopCarGoodGroupTypeOrderGiftGroup:
        {
            return nil;
        }
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _width_, 35.0)];
    
    contentLabel.font = [UIFont fontWithName:MainFontName size:14.0];
    
    contentLabel.textColor = MainTextColor;
    
    contentLabel.backgroundColor = _SeaViewControllerBackgroundColor_;
    
    if (section >= 0 && section < self.shopCarInfo.shopCarGoodsArr.count) {
        
        WMShopCarGoodGroupInfo *groupInfo = [self.shopCarInfo.shopCarGoodsArr objectAtIndex:section];
        
        switch (groupInfo.type) {
            case ShopCarGoodGroupTypeExchangeGroup:
            {
                contentLabel.text = @"  积分兑换赠品";
                
                return contentLabel;
            }
                break;
            case ShopCarGoodGroupTypeOrderGiftGroup:
            {
                contentLabel.text = @"  订单赠送赠品";
                
                return contentLabel;
            }
                break;
            default:
                return nil;
                break;
        }
    }
    else{
        
        if (self.shopCarInfo.unuseRuleInfosArr.count && self.shopCarInfo.useRuleInfosArr.count) {
            
            if (self.shopCarInfo.showUnusePromotion) {
                
                if (section == self.shopCarInfo.shopCarGoodsArr.count) {
                    
                    contentLabel.text = @"  已享受的优惠";
                    
                    return contentLabel;
                }
                else{
                    
                    contentLabel.text = @"  享受更多优惠";
                    
                    return contentLabel;
                }
            }
            else{
                
                contentLabel.text = @"  已享受的优惠";
                
                return contentLabel;
            }
        }
        else if (self.shopCarInfo.unuseRuleInfosArr.count || self.shopCarInfo.useRuleInfosArr.count){
            
            if (self.shopCarInfo.unuseRuleInfosArr.count) {
                
                contentLabel.text = @"  享受更多优惠";
                
                return contentLabel;
            }
            else{
                
                contentLabel.text = @"  已享受的优惠";
                
                return contentLabel;
            }
        }
        else{
            
            return nil;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XTableCellConfigEx *cellConfig = [self findConfig:indexPath];
    
    NSString *classNameString = NSStringFromClass(cellConfig.className);
    
    if ([classNameString isEqualToString:@"ShopCarContentViewCell"]) {
        
        WMShopCarGoodGroupInfo *goodGroupInfo = [self.shopCarInfo.shopCarGoodsArr objectAtIndex:indexPath.section];
        
        WMGoodDetailContainViewController *goodDetailController = [WMGoodDetailContainViewController new];
        
        goodDetailController.goodID = [goodGroupInfo returnGoodIDWithIndexPath:indexPath];
        
        goodDetailController.productID = [goodGroupInfo returnProductIDWithIndexPath:indexPath];
        
        [self.navigationController pushViewController:goodDetailController animated:YES];
    }
    else if ([classNameString isEqualToString:@"WMShopCarUnusePromotionViewCell"]){
        
        if (self.shopCarInfo.unuseRuleInfosArr.count && self.shopCarInfo.useRuleInfosArr.count) {
            
            if (self.shopCarInfo.showUnusePromotion) {
                
                if (indexPath.section == self.shopCarInfo.shopCarGoodsArr.count) {
                    
                    return;
                }
                else{
                    
                    WMShopCarPromotionRuleInfo *ruleInfo = [self.shopCarInfo.unuseRuleInfosArr objectAtIndex:indexPath.row];
                    
                    if (ruleInfo.canAction) {
                        
                        WMShopCarForOrderViewController *forOrderController = [WMShopCarForOrderViewController new];
                        
                        [self.navigationController pushViewController:forOrderController animated:YES];
                    }
                }
            }
            else{
                
                return;
            }
        }
        else if (self.shopCarInfo.unuseRuleInfosArr.count || self.shopCarInfo.useRuleInfosArr.count){
            
            if (self.shopCarInfo.unuseRuleInfosArr.count) {
                
                WMShopCarPromotionRuleInfo *ruleInfo = [self.shopCarInfo.unuseRuleInfosArr objectAtIndex:indexPath.row];
                
                if (ruleInfo.canAction) {
                    
                    WMShopCarForOrderViewController *forOrderController = [WMShopCarForOrderViewController new];
                    
                    [self.navigationController pushViewController:forOrderController animated:YES];
                }
            }
            else{
                return;
            }
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

#pragma mark - 返回单元格的配置和数据模型
- (id)findModel:(NSIndexPath *)indexPath{
    
    if (indexPath.section >= 0 && indexPath.section < self.shopCarInfo.shopCarGoodsArr.count) {
        
        WMShopCarGoodGroupInfo *goodGroupInfo = [self.shopCarInfo.shopCarGoodsArr objectAtIndex:indexPath.section];
        
        switch (goodGroupInfo.type) {
            case ShopCarGoodGroupTypeExchangeGroup:
            case ShopCarGoodGroupTypeOrderGiftGroup:
            {
                WMShopCarGoodInfo *goodInfo = [goodGroupInfo.goodInfosArr objectAtIndex:indexPath.row];
                
                return @{@"model":goodInfo,@"controller":self,@"type":@(goodInfo.type),@"isEdit":@(self.isEdit)};
            }
                break;
            case ShopCarGoodGroupTypeNormalGroup:
            {
                WMShopCarGoodInfo *goodInfo = [goodGroupInfo.goodInfosArr firstObject];
                
                if (indexPath.row == 0) {
                    
                    return @{@"model":goodInfo,@"controller":self,@"type":@(goodInfo.type),@"isEdit":@(self.isEdit)};
                }
                else if (indexPath.row == goodInfo.goodGiftAdjunctsArr.count + 1) {
                    
                    return goodInfo.goodPromotionAttrString;
                }
                else {
                    
                    id otherGoodInfo = [goodInfo.goodGiftAdjunctsArr objectAtIndex:indexPath.row - 1];
                    
                    if ([otherGoodInfo isKindOfClass:[WMShopCarAdjunctGoodInfo class]]) {
                        
                        return @{@"model":otherGoodInfo,@"controller":self,@"type":@(ShopCarGoodTypeAdjunctGood),@"isEdit":@(self.isEdit)};
                    }
                    else if ([otherGoodInfo isKindOfClass:[WMShopCarOrderGiftGoodInfo class]]){
                        
                        return @{@"model":otherGoodInfo,@"controller":self,@"type":@(ShopCarGoodTypeGiftGood),@"isEdit":@(self.isEdit)};
                    }
                    else{
                        
                        return nil;
                    }
                }
            }
                break;
            default:
                return nil;
                break;
        }
    }
    else{
        
        return [self.shopCarInfo returnInfoWithIndexPath:indexPath];
    }
}

- (XTableCellConfigEx *)findConfig:(NSIndexPath *)indexPath{
    
    if (indexPath.section >= 0 && indexPath.section < self.shopCarInfo.shopCarGoodsArr.count) {
        
        WMShopCarGoodGroupInfo *goodGroupInfo = [self.shopCarInfo.shopCarGoodsArr objectAtIndex:indexPath.section];
        
        switch (goodGroupInfo.type) {
            case ShopCarGoodGroupTypeExchangeGroup:
            case ShopCarGoodGroupTypeOrderGiftGroup:
            {
                return [_configsArr firstObject];
            }
                break;
            case ShopCarGoodGroupTypeNormalGroup:
            {
                WMShopCarGoodInfo *goodInfo = [goodGroupInfo.goodInfosArr firstObject];
                
                if (indexPath.row == goodInfo.goodGiftAdjunctsArr.count + 1) {
                    
                    return [_configsArr objectAtIndex:1];
                }
                else{
                    
                    return [_configsArr firstObject];
                }
            }
                break;
            default:
                return nil;
                break;
        }
    }
    else{
        
        return [_configsArr lastObject];
    }
}

#pragma mark - 编辑按钮点击
- (void)editButtonAction{
    
    self.isEdit = !self.isEdit;
    
    if (!self.isEdit) {
        
        [self.shopCarInfo changeEditStatusSelect:NO];
        
        [self.bottomView.selectAllImageButton setSelected:[self.shopCarInfo returnCurrentShopCarSelectStatus]];
    }
    else{
        
        [self.bottomView.selectAllImageButton setSelected:[self.shopCarInfo returnCurrentShopCarEditSelectStatus]];
    }
    
    [self.bottomView setIsEdit:self.isEdit];
    
    [self.rightButton setTitle:self.isEdit ? @"完成" : @"编辑" forState:UIControlStateNormal];
    
    [self.tableView reloadData];
}

#pragma mark - 选中购物车商品
- (void)selectShopCarGoodWithCell:(UITableViewCell *)cell isSelect:(BOOL)isSelect{
    
    self.selectIndexPath = [self.tableView indexPathForCell:cell];
    
    WMShopCarGoodGroupInfo *groupInfo = [self.shopCarInfo.shopCarGoodsArr objectAtIndex:self.selectIndexPath.section];
    
    switch (groupInfo.type) {
        case ShopCarGoodGroupTypeNormalGroup:
        {
            WMShopCarGoodInfo *normalGoodInfo = [groupInfo.goodInfosArr objectAtIndex:self.selectIndexPath.row];
            
            if (self.isEdit) {
                
                normalGoodInfo.isEditSelect = isSelect;
            }
            else{
                
                normalGoodInfo.isSelect = isSelect;
            }
        }
            break;
        case ShopCarGoodGroupTypeExchangeGroup:
        {
            WMShopCarExchangeGoodInfo *exchangeGoodInfo = [groupInfo.goodInfosArr objectAtIndex:self.selectIndexPath.row];
            
            if (self.isEdit) {
                
                exchangeGoodInfo.isEditSelect = isSelect;
            }
            else{
                
                exchangeGoodInfo.isSelect = isSelect;
            }
        }
            break;
        default:
            break;
    }
    
    if (!self.isEdit) {
        
        [self selectShopCarGoodRequest];
    }
    else{
        
        [self.bottomView.selectAllImageButton setSelected:[self.shopCarInfo returnCurrentShopCarEditSelectStatus]];
    }
}

- (void)selectShopCarGoodRequest{
    
    self.requesting = YES;
    
    self.showNetworkActivity = YES;
    
    self.request.identifier = WMSelectShopCarGoodIdentifier;
    
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMShopCarOperation returnSelectShopCarGoodParamWithGoodIdentsArr:[self.shopCarInfo returnCurrentShopCarSelectGoodsIdent:NO]]];
}

#pragma mark - 修改购物车商品数量
- (void)changeShopCarGoodQuantityWithCell:(UITableViewCell *)cell quantity:(NSInteger)quantity isMinus:(BOOL)isMinus{
    
    self.selectIndexPath = [self.tableView indexPathForCell:cell];
    
    self.requesting = YES;
    
    self.showNetworkActivity = YES;
    
    self.request.identifier = WMShopCarChangeQuantityIdentifier;
    
    WMShopCarGoodGroupInfo *groupInfo = [self.shopCarInfo.shopCarGoodsArr objectAtIndex:self.selectIndexPath.section];
    
    if (isMinus) {
        
        quantity = -quantity;
    }
    
    NSInteger newQuantity;
    
    switch (groupInfo.type) {
        case ShopCarGoodGroupTypeExchangeGroup:
        {
            WMShopCarExchangeGoodInfo *exchangeGoodInfo = [groupInfo.goodInfosArr objectAtIndex:self.selectIndexPath.row];
                
            newQuantity = exchangeGoodInfo.quantity.integerValue + quantity;
            
            exchangeGoodInfo.isSelect = YES;
            
            [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMShopCarOperation returnModifyShopCarQuantityWithGoodType:@"gift" goodIdent:[NSString stringWithFormat:@"gift_%@_%@",exchangeGoodInfo.goodID,exchangeGoodInfo.productID] goodID:exchangeGoodInfo.goodID modifyGoodQuantity:newQuantity modifyAdjunctGoodQuantity:0 adjunctGroupID:nil adjunctGoodProductID:nil selectObjIdentsArr:[self.shopCarInfo returnCurrentShopCarSelectGoodsIdent:NO]]];
        }
            break;
        case ShopCarGoodGroupTypeNormalGroup:
        {
            WMShopCarGoodInfo *normalGoodInfo = [groupInfo.goodInfosArr firstObject];
            
            if (self.selectIndexPath.row) {
                
                WMShopCarAdjunctGoodInfo *adjunctGoodInfo = [normalGoodInfo.goodGiftAdjunctsArr objectAtIndex:self.selectIndexPath.row - 1];
                    
                newQuantity = adjunctGoodInfo.quantity.integerValue + quantity;
                
                [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMShopCarOperation returnModifyShopCarQuantityWithGoodType:@"goods" goodIdent:[NSString stringWithFormat:@"goods_%@_%@",normalGoodInfo.goodID,normalGoodInfo.productID] goodID:nil modifyGoodQuantity:0 modifyAdjunctGoodQuantity:newQuantity adjunctGroupID:adjunctGoodInfo.adjunctGroupID adjunctGoodProductID:adjunctGoodInfo.productID selectObjIdentsArr:[self.shopCarInfo returnCurrentShopCarSelectGoodsIdent:NO]]];
            }
            else{
                    
                newQuantity = normalGoodInfo.quantity.integerValue + quantity;
                
                normalGoodInfo.isSelect = YES;
                
                [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMShopCarOperation returnModifyShopCarQuantityWithGoodType:@"goods" goodIdent:[NSString stringWithFormat:@"goods_%@_%@",normalGoodInfo.goodID,normalGoodInfo.productID] goodID:normalGoodInfo.goodID modifyGoodQuantity:newQuantity modifyAdjunctGoodQuantity:0 adjunctGroupID:nil adjunctGoodProductID:nil selectObjIdentsArr:[self.shopCarInfo returnCurrentShopCarSelectGoodsIdent:NO]]];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex) {
        
        if (alertView.tag == 1001) {
            
            self.requesting = YES;
            
            self.showNetworkActivity = YES;
            
            self.request.identifier = WMDeleteShopCarGoodIdentifier;
            
            [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMShopCarOperation returnBatchDeleteShopCarGoodWithInfosArr:self.shopCarInfo.shopCarGoodsArr]];
        }
        else{
            
            WMShopCarGoodGroupInfo *groupInfo = [self.shopCarInfo.shopCarGoodsArr objectAtIndex:self.selectIndexPath.section];
            
            self.requesting  = YES;
            
            self.showNetworkActivity = YES;
            
            self.request.identifier = WMDeleteShopCarGoodIdentifier;
            
            switch (groupInfo.type) {
                case ShopCarGoodGroupTypeExchangeGroup:
                {
                    WMShopCarExchangeGoodInfo *exchangeGoodInfo = [groupInfo.goodInfosArr objectAtIndex:self.selectIndexPath.row];
                    
                    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMShopCarOperation returnDeleteShopCarGoodWithGoodType:@"gift" goodIdent:[NSString stringWithFormat:@"gift_%@_%@",exchangeGoodInfo.goodID,exchangeGoodInfo.productID] goodID:exchangeGoodInfo.goodID modifyGoodQuantity:exchangeGoodInfo.quantity.integerValue modifyAdjunctGoodQuantity:0 adjunctGroupID:nil adjunctGoodProductID:nil selectObjIdentsArr:[self.shopCarInfo returnCurrentShopCarSelectGoodsIdent:NO]]];
                }
                    break;
                case ShopCarGoodGroupTypeNormalGroup:
                {
                    WMShopCarGoodInfo *normalGoodInfo = [groupInfo.goodInfosArr firstObject];
                    
                    if (self.selectIndexPath.row) {
                        
                        WMShopCarAdjunctGoodInfo *adjunctGoodInfo = [normalGoodInfo.goodGiftAdjunctsArr objectAtIndex:self.selectIndexPath.row - 1];
                        
                        [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMShopCarOperation returnDeleteShopCarGoodWithGoodType:nil goodIdent:[NSString stringWithFormat:@"goods_%@_%@",normalGoodInfo.goodID,normalGoodInfo.productID] goodID:nil modifyGoodQuantity:0 modifyAdjunctGoodQuantity:adjunctGoodInfo.quantity.integerValue adjunctGroupID:adjunctGoodInfo.adjunctGroupID adjunctGoodProductID:adjunctGoodInfo.productID selectObjIdentsArr:[self.shopCarInfo returnCurrentShopCarSelectGoodsIdent:NO]]];
                    }
                    else{
                        
                        [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMShopCarOperation returnDeleteShopCarGoodWithGoodType:@"goods" goodIdent:[NSString stringWithFormat:@"goods_%@_%@",normalGoodInfo.goodID,normalGoodInfo.productID] goodID:normalGoodInfo.goodID modifyGoodQuantity:normalGoodInfo.quantity.integerValue modifyAdjunctGoodQuantity:0 adjunctGroupID:nil adjunctGoodProductID:nil selectObjIdentsArr:[self.shopCarInfo returnCurrentShopCarSelectGoodsIdent:NO]]];
                    }
                }
                    break;
                default:
                    break;
            }
        }
    }
    
}






@end

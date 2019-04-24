//
//  WMGoodDetailInfoViewController.m
//  StandardShop
//
//  Created by mac on 16/6/6.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodDetailInfoViewController.h"
#import "WMGoodDetailContainViewController.h"
#import "WMGoodDetailInfoExtraInfoViewController.h"
#import "WMGoodSpecValueSelectViewController.h"
#import "WMGoodDetailAdviceViewController.h"
#import "WMGoodCommentViewController.h"
#import "WMGoodListViewController.h"

#import "WMGoodDetailInfo.h"
#import "WMGoodDetailPromotionInfo.h"
#import "WMGoodDetailSettingInfo.h"
#import "WMGoodDetailOperation.h"
#import "WMShopCarOperation.h"
#import "WMBrandInfo.h"

#import "XTableCellConfigEx.h"
#import "XTableCellConfigExDelegate.h"
#import "WMGoodDetailInfoHeaderView.h"

#import "SeaMenuBar.h"
#import "WMGoodDetailBottomView.h"

@interface WMGoodDetailInfoViewController ()<SeaMenuBarDelegate,SeaHttpRequestDelegate>
/**秒杀商品、普通商品、积分兑换商品配置类数组
 */
@property (strong,nonatomic) NSArray *configsArr;
/**预售商品配置数组
 */
@property (strong,nonatomic) NSArray *prepareConfigsArr;
/**配件和相关商品菜单栏
 */
@property (strong,nonatomic) SeaMenuBar *menuBar;
/**商品价格、名称和图片信息
 */
@property (strong,nonatomic) WMGoodDetailInfoHeaderView *headerView;
/**扩展参数控制器
 */
@property (strong,nonatomic) WMGoodDetailInfoExtraInfoViewController *extraInfoController;
/**规格选择控制器
 */
@property (strong,nonatomic) WMGoodSpecValueSelectViewController *specSelectController;
/**网络请求
 */
@property (strong,nonatomic) SeaHttpRequest *request;
@end

@implementation WMGoodDetailInfoViewController

#pragma mark - 生命周器
- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        
        self.hidesBottomBarWhenPushed = YES;
        
        self.request = [[SeaHttpRequest alloc] initWithDelegate:self];
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAdviceCount) name:WMCommitAdviceSuccessNotification object:nil];
    
    [self initialization];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateAdviceCount{
    
    self.goodDetailInfo.adviceCount = [NSString stringWithFormat:@"%ld",(long)(self.goodDetailInfo.adviceCount.integerValue + 1)];
    
    if (self.goodDetailInfo.type == GoodPromotionTypePrepare) {
        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:PrepareGoodSectionTypeAdvice] withRowAnimation:UITableViewRowAnimationNone];
    }
    else{
        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:GoodSectionTypeAdvice] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - 配置表格视图
- (void)initialization{
    
    self.style = UITableViewStyleGrouped;
    
    [super initialization];
    
    [self configureCellConfig];
        
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.frame = CGRectMake(0, 0, _width_, _height_ - self.navigationBarHeight - self.statusBarHeight - WMGoodDetailBottomViewHeight - (isIPhoneX ? 35.0 : 0.0));
    
    _headerView = [[WMGoodDetailInfoHeaderView alloc] initWithGoodInfo:self.goodDetailInfo];
        
    self.tableView.tableHeaderView = _headerView;
}

#pragma mark - 初始化配置类
- (void)configureCellConfig{
    
    switch (self.goodDetailInfo.type) {
        case GoodPromotionTypeNothing:
        case GoodPromotionTypeSecondKill:
        case GoodPromotionTypeGift:
        {
            if (self.configsArr == nil) {
                
                _configsArr = [WMGoodDetailOperation returnSecondKillCommonGoodTableConfigWithTableView:self.tableView];
            }
        }
            break;
        case GoodPromotionTypePrepare:
        {
            if (self.prepareConfigsArr == nil) {
                
                _prepareConfigsArr = [WMGoodDetailOperation returnPrepareGoodTableConfigWithTableView:self.tableView];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - UITableView协议
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    switch (self.goodDetailInfo.type) {
        case GoodPromotionTypeGift:
        case GoodPromotionTypeNothing:
        case GoodPromotionTypeSecondKill:
        {
            return self.configsArr.count;
        }
            break;
        default:
        {
            return self.prepareConfigsArr.count;
        }
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_goodDetailInfo returnGoodDetailInfoSectionRowCountWithSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [_goodDetailInfo returnGoodDetailInfoRowHeightWithIndexPath:indexPath menuBarSelectIndex:self.menuBar.selectedIndex];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (self.goodDetailInfo.type == GoodPromotionTypeNothing || self.goodDetailInfo.type == GoodPromotionTypeSecondKill || self.goodDetailInfo.type == GoodPromotionTypeGift) {
        
        if (section == GoodSectionTypeLinkAdjGood) {
            
            CGFloat menuBarViewHeight = 0.0;
            
            NSArray *titlesArr;
            
            if (self.goodDetailInfo.goodSimilarGoodsArr.count && self.goodDetailInfo.goodAdjGroupsArr.count) {
                
                menuBarViewHeight = 70.0;
                
                titlesArr = @[@"配件推荐",@"猜你喜欢"];
            }
            else if (self.goodDetailInfo.goodSimilarGoodsArr.count || self.goodDetailInfo.goodAdjGroupsArr.count){
                
                menuBarViewHeight = 70.0;
                
                titlesArr = self.goodDetailInfo.goodSimilarGoodsArr.count ? @[@"猜你喜欢"] : @[@"配件推荐"];
            }
            else{
                
                menuBarViewHeight = CGFLOAT_MIN;
                
                titlesArr = @[@"猜你喜欢",@"配件推荐"];
                
                return nil;
            }
            
            UIView *menuBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width_, menuBarViewHeight)];
            
            menuBarView.backgroundColor = _SeaViewControllerBackgroundColor_;
            
            if (!_menuBar) {
                
                _menuBar = [[SeaMenuBar alloc] initWithFrame:CGRectMake(0, 10.0, _width_, 55.0) titles:titlesArr style:SeaMenuBarStyleItemWithRelateTitleInFullScreen];
                
                _menuBar.titleFont = [UIFont fontWithName:MainFontName size:17.0];
                
                _menuBar.delegate = self;
            }
            
            [menuBarView addSubview:_menuBar];
            
            return menuBarView;
        }
    }
    
    UIView *sectionGrayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width_, 0.0)];
    
    sectionGrayView.backgroundColor = _SeaViewControllerBackgroundColor_;
    
    return sectionGrayView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return [self.goodDetailInfo returnGoodDetailInfoHeaderViewHeightWithSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width_, _separatorLineWidth_)];
    
    lineView.backgroundColor = _SeaViewControllerBackgroundColor_;
    
    return lineView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return [self.goodDetailInfo returnGoodDetailInfoFooterViewHeightWithSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XTableCellConfigEx *config = [self findConfigWithIndexPath:indexPath];
    
    id model = [self findModelWithIndexPath:indexPath];
    
    id<XTableCellConfigExDelegate> cell = [config cellOfCellConfigWithTableView:tableView indexPath:indexPath];
    
    if ([cell isKindOfClass:[WMGoodLinkTableViewCell class]]) {
        
        WeakSelf(self);
        
        WMGoodLinkTableViewCell *linkCell = (WMGoodLinkTableViewCell *)cell;
        
        [linkCell setSelectCallBack:^(NSString *productID) {
            
            WMGoodDetailContainViewController *contain = [WMGoodDetailContainViewController new];
            
            contain.productID = productID;
            
            [weakSelf.navigation pushViewController:contain animated:YES];
        }];
        
        [linkCell configureCellWithModel:model];
        
        return linkCell;
    }
    else if ([cell isKindOfClass:[WMPromotionContentTableViewCell class]]){
        
        WeakSelf(self);
        
        WMPromotionContentTableViewCell *contentCell = (WMPromotionContentTableViewCell *)cell;
        
        [contentCell setSelectCallBack:^(NSString *productName) {
           
            if (weakSelf.goodDetailInfo.promotionInfo.giftPromotionInfo) {
                
                for (WMPromotionGoodInfo *promotionGoodInfo in weakSelf.goodDetailInfo.promotionInfo.giftPromotionInfo.promotionContentArr) {
                    
                    if ([promotionGoodInfo.goodName isEqualToString:productName]) {
                        
                        WMGoodDetailContainViewController *goodDetailController = [[WMGoodDetailContainViewController alloc] init];
                        
                        goodDetailController.productID = promotionGoodInfo.productID;
                        
                        goodDetailController.goodID = promotionGoodInfo.goodID;
                        
                        [weakSelf.navigation pushViewController:goodDetailController animated:YES];
                        
                        break;
                    }
                }
            }
        }];
        
        [contentCell configureCellWithModel:model];
        
        return contentCell;
    }
    
    [cell configureCellWithModel:model];
    
    return (UITableViewCell *)cell;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (scrollView.contentSize.height - scrollView.contentOffset.y < UpLoadOffestMaxValue) {
        
        self.upLoadCallBack();
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XTableCellConfigEx *cellConfig = [self findConfigWithIndexPath:indexPath];
    
    NSString *classNameString = NSStringFromClass(cellConfig.className);
    
    if ([classNameString isEqualToString:@"WMPromotionDropTableViewCell"] || [classNameString isEqualToString:@"WMPromotionUpTableViewCell"]) {
        
        self.goodDetailInfo.promotionInfo.isDropDownShow = !self.goodDetailInfo.promotionInfo.isDropDownShow;
        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else if ([classNameString isEqualToString:@"WMGoodShowInfoTableViewCell"]){
        
        if (!self.extraInfoController) {
            
            self.extraInfoController = [[WMGoodDetailInfoExtraInfoViewController alloc] init];
            
            self.extraInfoController.extraInfosArr = self.goodDetailInfo.goodPropsArr;
            
            self.extraInfoController.p_delegate = [SeaPartialPresentTransitionDelegate new];
            
            self.extraInfoController.view.frame = CGRectMake(0, 0, _width_, _height_ - 200.0);
        }
        
        self.extraInfoController.transitioningDelegate = self.extraInfoController.p_delegate;
        
        [self.navigation presentViewController:self.extraInfoController animated:YES completion:nil];
    }
    else if ([classNameString isEqualToString:@"WMSelectSpecInfoTableViewCell"]){
        
        NSDictionary *dict = [self.goodDetailInfo.buttonPageList firstObject];
        
        [self configureSpecInfoControllerIsGift:self.isGift fastBuy:NO notify:[[dict numberForKey:@"show_notify"] boolValue] canBuy:[[dict numberForKey:@"buy"] boolValue] value:[dict sea_stringForKey:@"value"]];
    }
    else if ([classNameString isEqualToString:@"WMGoodAdviceTableViewCell"]){
        
        WMGoodDetailAdviceViewController *goodAdviceController = [[WMGoodDetailAdviceViewController alloc] init];
        
        goodAdviceController.goodID = self.goodDetailInfo.goodID;
        
        [self.navigation pushViewController:goodAdviceController animated:YES];
    }
    else if ([classNameString isEqualToString:@"WMGoodCommentTableViewCell"]){
        
        WMGoodCommentViewController *comment = [[WMGoodCommentViewController alloc] initWithGoodId:self.goodDetailInfo.goodID];
        
        [self.navigation pushViewController:comment animated:YES];
    }
    else if ([classNameString isEqualToString:@"WMGoodBrandTableViewCell"]){
        
        WMGoodListViewController *goodList = [[WMGoodListViewController alloc] initWithBrandInfo:self.goodDetailInfo.goodBrandInfo];
        
        [self.navigation pushViewController:goodList animated:YES];
    }
    else if ([classNameString isEqualToString:@"WMPromotionContentTableViewCell"]){
        
        WMPromotionContentInfo *content = [self.goodDetailInfo.promotionInfo.promotionContentInfosArr objectAtIndex:indexPath.row - 1];
        
        if ([NSString isEmpty:content.tagID]) {
            
            return;
        }
        
        WMGoodListViewController *goodListController = [[WMGoodListViewController alloc] init];
        
        goodListController.promotionTagId = content.tagID;
        
        goodListController.titleName = content.contentTag;
        
        [self.navigation pushViewController:goodListController animated:YES];
    }
}

- (void)configureSpecInfoControllerIsGift:(BOOL)isGift fastBuy:(BOOL)fastBuy notify:(BOOL)notify canBuy:(BOOL)canBuy value:(NSString *)value{
    
    if (!self.specSelectController) {
        
        WeakSelf(self);
        
        self.specSelectController = [WMGoodSpecValueSelectViewController new];
        
        self.specSelectController.isGiftProduct = isGift;
        
        self.specSelectController.navigation = self.navigation;
        
        self.specSelectController.p_delegate = [[SeaPartialPresentTransitionDelegate alloc] init];
        
        [self.specSelectController setSelectSpecInfo:^{
            
            [weakSelf.headerView updateUI];
            
            [weakSelf configureCellConfig];
            
            weakSelf.tableView.tableHeaderView = nil;
            
            weakSelf.tableView.tableHeaderView = weakSelf.headerView;
            
            [weakSelf.tableView reloadData];
            
            if (weakSelf.upLoadButtonCollection) {
                
                weakSelf.upLoadButtonCollection();
            }
//            if (weakSelf.goodDetailInfo.type == GoodPromotionTypeSecondKill || weakSelf.goodDetailInfo.type == GoodPromotionTypeNothing || weakSelf.goodDetailInfo.type == GoodPromotionTypeGift) {
//                
//                [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:GoodSectionTypeSaleStore] withRowAnimation:UITableViewRowAnimationNone];
//            }
        }];
        
        [self.specSelectController setDismissCallBack:^{
            
            weakSelf.goodDetailInfo.specInfoAttrString = [WMGoodDetailInfo changeGoodBuyQuantityWithNewQuantity:weakSelf.goodDetailInfo.goodBuyQuantity specInfosArr:weakSelf.goodDetailInfo.goodSpecInfosArr goodUnit:weakSelf.goodDetailInfo.goodUnit];
            
            if (weakSelf.goodDetailInfo.type == GoodPromotionTypeNothing || weakSelf.goodDetailInfo.type == GoodPromotionTypeSecondKill || weakSelf.goodDetailInfo.type == GoodPromotionTypeGift) {
                
                [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:GoodSectionTypeSpecInfo] withRowAnimation:UITableViewRowAnimationNone];
            }
            else if (weakSelf.goodDetailInfo.type == GoodPromotionTypePrepare){
                
                [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:PrepareGoodSectionTypeSpecInfo] withRowAnimation:UITableViewRowAnimationNone];
            }
        }];
        
        self.specSelectController.p_delegate.dismissCallBack = self.specSelectController.dismissCallBack;
        
        self.specSelectController.goodInfo = self.goodDetailInfo;
        
        self.specSelectController.view.frame = CGRectMake(0, 0, _width_, [self.specSelectController returnGoodDetailInfoSpecValueHeight]);
        
        [self.specSelectController initialization];
    }
    
    self.specSelectController.isFastBuy = fastBuy;
    
    self.specSelectController.canBuy = canBuy;
    
    self.specSelectController.notify = notify;
    
    self.specSelectController.value = value;
    
    [self.specSelectController updateFooterView];
    
    self.specSelectController.transitioningDelegate = self.specSelectController.p_delegate;
    
    [self.navigation presentViewController:self.specSelectController animated:YES completion:nil];
}

#pragma mark - 返回配置累类和模型
- (XTableCellConfigEx *)findConfigWithIndexPath:(NSIndexPath *)indexPath{
    
    switch (self.goodDetailInfo.type) {
        case GoodPromotionTypeNothing:
        case GoodPromotionTypeSecondKill:
        case GoodPromotionTypeGift:
        {
            NSArray *configArr = [_configsArr objectAtIndex:indexPath.section];
            
            switch (indexPath.section) {
                case GoodSectionTypePromotion:
                {
                    if (_goodDetailInfo.promotionInfo.isDropDownShow) {
                                                
                        return indexPath.row ? [configArr lastObject] : [configArr objectAtIndex:1];
                    }
                    else{
                        
                        return [configArr firstObject];
                    }
                }
                    break;
                case GoodSectionTypeSpecInfo:
                {
                    if (_goodDetailInfo.goodPropsArr.count) {
                        
                        return indexPath.row ? [configArr lastObject] : [configArr firstObject];
                    }
                    else{
                        
                        return [configArr lastObject];
                    }
                }
                    break;
                case GoodSectionTypeLinkAdjGood:
                {
                    
                    if (self.goodDetailInfo.goodSimilarGoodsArr.count && self.goodDetailInfo.goodAdjGroupsArr.count) {
                        
                        return self.menuBar.selectedIndex ? [configArr firstObject] : [configArr lastObject];
                    }
                    else if (self.goodDetailInfo.goodSimilarGoodsArr.count || self.goodDetailInfo.goodAdjGroupsArr.count){
                        
                        return self.goodDetailInfo.goodSimilarGoodsArr.count ? [configArr firstObject] : [configArr lastObject];
                    }
                    else{
                        
                        return nil;
                    }
                }
                    break;
                case GoodSectionTypeSecondKillLimit:
                case GoodSectionTypeSale:
                case GoodSectionTypeStore:
                case GoodSectionTypeComment:
                case GoodSectionTypeAdvice:
                case GoodSectionTypeBrief:
                case GoodSectionTypeTag:
                case GoodSectionTypeBrand:
                case GoodSectionTypeLoadMore:
                {
                    return [configArr objectAtIndex:indexPath.row];
                }
                    break;
                default:
                {
                    return nil;
                }
                    break;
            }
        }
            break;
        case GoodPromotionTypePrepare:
        {
            
            NSArray *configArr = [_prepareConfigsArr objectAtIndex:indexPath.section];

            switch (indexPath.section) {
                case PrepareGoodSectionTypeSpecInfo:
                {
                    if (_goodDetailInfo.goodPropsArr.count) {
                       
                        return indexPath.row ? [configArr lastObject] : [configArr firstObject];
                    }
                    else{
                        
                        return [configArr lastObject];
                    }
                }
                    break;
                case PrepareGoodSectionTypeStatus:
                case PrepareGoodSectionTypeComment:
                case PrepareGoodSectionTypeAdvice:
                case PrepareGoodSectionTypeBrief:
                case PrepareGoodSectionTypeTag:
                case PrepareGoodSectionTypeBrand:
                case PrepareGoodSectionTypeLinkGood:
                case PrepareGoodSectionTypeLoadMore:
                {
                    return [configArr objectAtIndex:indexPath.row];
                }
                    break;
                default:
                {
                    return nil;
                }
                    break;
            }
        }
            break;
        default:
        {
            return nil;
        }
            break;
    }
}

- (id)findModelWithIndexPath:(NSIndexPath *)indexPath{
    
    XTableCellConfigEx *cellConfig = [self findConfigWithIndexPath:indexPath];
    
    NSString *classNameString = NSStringFromClass(cellConfig.className);
    
    if ([classNameString isEqualToString:@"WMGoodPureTextTableViewCell"]){
        
        if (self.goodDetailInfo.type == GoodPromotionTypePrepare) {
            
            return indexPath.section == PrepareGoodSectionTypeStatus ? _goodDetailInfo.prepareAttrString : _goodDetailInfo.goodBrief;
        }
        else{
            
            return _goodDetailInfo.goodBrief;
        }
    }
    else if ([classNameString isEqualToString:@"WMPromotionContentTableViewCell"]){
        
        WMPromotionContentInfo *contentInfo = [self.goodDetailInfo.promotionInfo.promotionContentInfosArr objectAtIndex:indexPath.row - 1];
        
        return contentInfo;
    }
    else if ([classNameString isEqualToString:@"WMGoodAdjTableViewCell"]){
        
        return @{@"model":_goodDetailInfo,@"controller":self};
    }
    else if ([classNameString isEqualToString:@"WMSaleStoreCountTableViewCell"]){
        
        return @{@"section":@(indexPath.section),@"model":_goodDetailInfo};
    }
    else{
        
        return _goodDetailInfo;
    }
}

#pragma mark - SeameunBar协议
- (void)menuBar:(SeaMenuBar *)menu didSelectItemAtIndex:(NSInteger)index{
    
    if (index) {
        
        WMGoodAdjTableViewCell *adjCell = (WMGoodAdjTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:GoodSectionTypeLinkAdjGood]];
        
        adjCell.contentView.hidden = YES;
    }
    else{
        
        WMGoodLinkTableViewCell *linkCell = (WMGoodLinkTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:GoodSectionTypeLinkAdjGood]];
        
        linkCell.contentView.hidden = YES;
    }
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:GoodSectionTypeLinkAdjGood] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - 网络协议
- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data{
    
    self.requesting = NO;
    
    self.showNetworkActivity = NO;
    
    if ([WMShopCarOperation returnAddShopCarResultWithData:data]) {
        
        [self alertMsg:@"加入购物车成功"];
    }
}

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error{
    
    self.requesting = NO;
    
    self.showNetworkActivity = NO;
    
    [self alertMsg:@"网络错误，请重试"];
}

















@end

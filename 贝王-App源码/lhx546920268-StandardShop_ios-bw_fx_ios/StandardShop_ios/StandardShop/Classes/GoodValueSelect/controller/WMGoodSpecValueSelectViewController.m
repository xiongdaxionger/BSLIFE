//
//  WMGoodSpecValueSelectViewController.m
//  StandardShop
//
//  Created by mac on 16/6/13.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodSpecValueSelectViewController.h"
#import "WMGoodCommitNotifyViewController.h"
#import "ConfirmOrderPageController.h"

#import "GoodValuesImageViewCell.h"
#import "ValuesCommonViewCell.h"
#import "ValuesQuantityViewCell.h"
#import "WMSpecInfoSelectHeaderView.h"

#import "WMGoodDetailInfo.h"
#import "WMGoodDetailAdjGroupInfo.h"
#import "WMUserInfo.h"
#import "WMConfirmOrderInfo.h"
#import "WMGoodDetailSpecInfo.h"
#import "WMGoodDetailOperation.h"
#import "WMShopCarOperation.h"
#import "WMConfirmOrderOperation.h"
#import "WMGoodDetailGiftInfo.h"
#import "WMGoodDetailPrepareInfo.h"

@interface WMGoodSpecValueSelectViewController ()<UITableViewDataSource,UITableViewDelegate,GoodValuesImageViewCellDelegate,ValuesCommonViewCellDelegate,ValuesQuantityViewCellDelegate,SeaHttpRequestDelegate>
/**内容视图
 */
@property (strong,nonatomic) UIView *contentView;
/**属性选择头部视图
 */
@property (strong,nonatomic) WMSpecInfoSelectHeaderView *headerView;
/**表格视图
 */
@property (strong,nonatomic) UITableView *tableView;
/**网络请求
 */
@property (strong,nonatomic) SeaHttpRequest *request;
/**高度
 */
@property (assign,nonatomic) CGFloat contentHeight;

@end

@implementation WMGoodSpecValueSelectViewController

- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        
        self.adjunctBuyQuantity = 0;
        
        self.request = [[SeaHttpRequest alloc] initWithDelegate:self];
        
        [self setupNavigationBarWithBackgroundColor:[UIColor clearColor] titleColor:nil titleFont:nil];
    }
    
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.view.frame = CGRectMake(0, _height_ - (self.contentHeight + (isIPhoneX ? 35.0 : 0.0)), _width_, self.contentHeight + (isIPhoneX ? 35.0 : 0.0));
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    self.contentHeight = [self returnGoodDetailInfoSpecValueHeight];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - 初始化
- (void)initialization{
    
    WeakSelf(self);
        
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width_, self.contentHeight)];
    
    _contentView.backgroundColor = [UIColor clearColor];
    
    _headerView = [[WMSpecInfoSelectHeaderView alloc] initWithFrame:CGRectMake(0, 0, _width_, WMSpecInfoSelectHeaderViewHeight)];
    
    _headerView.type = _goodInfo.type;
    
    _headerView.productName = _goodInfo.goodName;
    
    _headerView.productPrice = _goodInfo.type == GoodPromotionTypeGift ? _goodInfo.giftMessageInfo.consumeScore : _goodInfo.goodShowPrice;
    
    _headerView.productImage = _goodInfo.selectSpecProductImage;
    
    _headerView.specInfoAttrString = [WMGoodDetailInfo changeGoodBuyQuantityWithNewQuantity:self.goodInfo.goodBuyQuantity specInfosArr:self.goodInfo.goodSpecInfosArr goodUnit:self.goodInfo.goodUnit];
    
    _headerView.backgroundColor = [UIColor clearColor];
    
    if (_goodInfo.type == GoodPromotionTypeGift) {
        
        _headerView.productStore = [NSString stringWithFormat:@"限兑:%@",_goodInfo.giftMessageInfo.exchangeMax];
    }
    else{
        
        _headerView.productStore = [NSString isEmpty:_goodInfo.goodStore] ? @"" : [NSString stringWithFormat:@"库存%@",_goodInfo.goodStore];
    }
    
    [_headerView setCloseSpecInfoSelect:^{
        
        [weakSelf dismissSelf];
    }];
    
    [_headerView configureUI];
    
    [_contentView addSubview:_headerView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, WMSpecInfoSelectHeaderViewHeight, _width_,_contentView.height - WMSpecInfoSelectHeaderViewHeight - WMSpecInfoSelectFooterViewHeight) style:UITableViewStyleGrouped];
    
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.dataSource = self;
    
    self.tableView.delegate = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GoodValuesImageViewCell" bundle:nil] forCellReuseIdentifier:GoodValuesImageViewCellIden];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ValuesCommonViewCell" bundle:nil] forCellReuseIdentifier:ValuesCommonViewCellIden];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ValuesQuantityViewCell" bundle:nil] forCellReuseIdentifier:ValuesQuantityViewCellIden];
    
    [_contentView addSubview:self.tableView];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.tableView.bottom, _width_, WMSpecInfoSelectFooterViewHeight)];
    
    footerView.backgroundColor = [UIColor whiteColor];
    
    _footerView = [[UIButton alloc] initWithFrame:CGRectMake(20.0, 6.0, _width_ - 40.0, 38.0)];
    
    [_footerView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _footerView.titleLabel.font = WMLongButtonTitleFont;
    
    [_footerView makeBorderWidth:0.0 Color:nil CornerRadius:6.0];
    
    [_footerView addTarget:self action:@selector(footViewAction:) forControlEvents:UIControlEventTouchUpInside];
        
    [footerView addSubview:_footerView];
    
    [_contentView addSubview:footerView];
    
    if (isIPhoneX) {
        
        UIView *blandView = [[UIView alloc] initWithFrame:CGRectMake(0, _contentView.bottom, _width_, 35.0)];
        
        [blandView setBackgroundColor:[UIColor whiteColor]];
        
        [self.view addSubview:blandView];
    }
    
    [self.view addSubview:_contentView];
}

- (NSDictionary *)changeRequestParamWithParam:(NSMutableDictionary *)param{
        
    for (WMGoodDetailAdjGroupInfo *groupInfo in self.goodInfo.goodAdjGroupsArr) {
        
        for (WMGoodDetailAdjGoodInfo *goodInfo in groupInfo.groupGoodInfoArr) {
            
            NSInteger groupIndex = [self.goodInfo.goodAdjGroupsArr indexOfObject:groupInfo];
            
            if (goodInfo.isSelect) {
                
                self.adjunctBuyQuantity += 1;
                
                [param setObject:@(1) forKey:[NSString stringWithFormat:@"adjunct[%@][%@]",@(groupIndex),goodInfo.productID]];
            }
        }
    }
    
    return param;
}

#pragma mark - 表格视图协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        
    return _goodInfo.goodSpecInfosArr.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == _goodInfo.goodSpecInfosArr.count) {
        
        ValuesQuantityViewCell *quantityCell = [tableView dequeueReusableCellWithIdentifier:ValuesQuantityViewCellIden forIndexPath:indexPath];
        
        [quantityCell configureWithModel:_goodInfo];
        
        quantityCell.delegate = self;
        
        return quantityCell;
    }
    
    WMGoodDetailSpecInfo *specInfo = [_goodInfo.goodSpecInfosArr objectAtIndex:indexPath.row];
    
    if (specInfo.specInfoIsImage) {
        
        GoodValuesImageViewCell *imageCell = [tableView dequeueReusableCellWithIdentifier:GoodValuesImageViewCellIden forIndexPath:indexPath];
        
        [imageCell configureCellWithModel:specInfo];
        
        imageCell.delegate = self;
        
        return imageCell;
    }
    else{
        
        ValuesCommonViewCell *textValueCell = [tableView dequeueReusableCellWithIdentifier:ValuesCommonViewCellIden forIndexPath:indexPath];
        
        [textValueCell configureCellWithModel:specInfo];
        
        textValueCell.delegate = self;
        
        return textValueCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == _goodInfo.goodSpecInfosArr.count) {
        
        return ValuesQuantityViewCellHeight;
    }
    
    WMGoodDetailSpecInfo *specInfo = [_goodInfo.goodSpecInfosArr objectAtIndex:indexPath.row];
    
    if (specInfo.specInfoIsImage) {
        
        return GoodValuesImageViewCellHeight;
    }
    else{
        
        return ValuesCommonViewCellExtraHeight + [WMGoodDetailOperation returnTagContentHeightWithMaxWidth:_width_ titlesArr:specInfo.titlesArr extraWidth:ValuesCommonTagExtraWidth tagCellHeight:28.0];
    }
}

#pragma mark - ValuesQuantityViewCellDelegate协议
- (void)changeBuyQuantityWithNewQuantity:(NSInteger)quantity{
    
    _goodInfo.goodBuyQuantity = quantity;
    
    self.headerView.specInfoAttrString = [WMGoodDetailInfo changeGoodBuyQuantityWithNewQuantity:self.goodInfo.goodBuyQuantity specInfosArr:self.goodInfo.goodSpecInfosArr goodUnit:self.goodInfo.goodUnit];
    
    [self.headerView updateUI];
}

#pragma mark - GoodValuesImageViewCellDelegate协议
- (void)imageSpecValueSelectWithProductID:(NSString *)productID{
    
    self.request.identifier = WMProductDetailRequestIdentifier;
    
    self.requesting = YES;
    
    [AppDelegate instance].showNetworkActivity = YES;
    
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMGoodDetailOperation returnGoodDetailParamWithProductID:productID isGift:self.isGiftProduct]];
}

#pragma mark - ValuesCommonViewCellDelegate协议
- (void)textSpecValueSelectWithProductID:(NSString *)productID{
    
    self.request.identifier = WMProductDetailRequestIdentifier;
    
    self.requesting = YES;
    
    [AppDelegate instance].showNetworkActivity = YES;
    
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMGoodDetailOperation returnGoodDetailParamWithProductID:productID isGift:self.isGiftProduct]];
}

#pragma mark - 私有方法
- (void)dismissSelf{
    
    if (self.dismissCallBack) {
        
        self.dismissCallBack();
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 网络请求
- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error{
    
    self.requesting = NO;
    
    [AppDelegate instance].showNetworkActivity = NO;
    
    [[AppDelegate instance] alertMsg:@"网络连接错误，请重试"];
    
    [self.tableView reloadData];
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data{
    
    self.requesting = NO;
    
    [AppDelegate instance].showNetworkActivity = NO;
    
    if ([request.identifier isEqualToString:WMProductDetailRequestIdentifier]) {
        
        WMGoodDetailInfo *info = [WMGoodDetailOperation returnGoodDetailInfoWithData:data];
        
        if (info) {
            
            [self.goodInfo updataGoodDetailInfoWithDetailInfo:info];
            
            BOOL found = NO;
            
            for (NSDictionary *buttonDict in self.goodInfo.buttonPageList) {
                
                NSString *searchValue = [buttonDict sea_stringForKey:@"value"];
                
                if ([searchValue isEqualToString:self.value]) {
                    
                    self.notify = [[buttonDict numberForKey:@"show_notify"] boolValue];
                    
                    self.canBuy = [[buttonDict numberForKey:@"buy"] boolValue];
                    
                    found = YES;
                    
                    break;
                }
            }
            
            if (!found) {
                
                NSDictionary *dict = [self.goodInfo.buttonPageList firstObject];
                
                self.notify = [[dict numberForKey:@"show_notify"] boolValue];
                
                self.canBuy = [[dict numberForKey:@"buy"] boolValue];
            }
            
            self.headerView.productImage = self.goodInfo.selectSpecProductImage;
            
            self.headerView.type = self.goodInfo.type;
            
            self.headerView.specInfoAttrString = [WMGoodDetailInfo changeGoodBuyQuantityWithNewQuantity:self.goodInfo.goodBuyQuantity specInfosArr:self.goodInfo.goodSpecInfosArr goodUnit:self.goodInfo.goodUnit];
                        
            self.headerView.productPrice = _goodInfo.type == GoodPromotionTypeGift ? _goodInfo.giftMessageInfo.consumeScore : _goodInfo.goodShowPrice;
            
            if (_goodInfo.type == GoodPromotionTypeGift) {
                
                _headerView.productStore = [NSString stringWithFormat:@"限兑:%@",_goodInfo.giftMessageInfo.exchangeMax];
            }
            else{
                
                if (self.goodInfo.marketAble) {
                    
                    _headerView.productStore = [NSString isEmpty:_goodInfo.goodStore] ? @"" : [NSString stringWithFormat:@"库存%@",_goodInfo.goodStore];
                }
                else{
                    
                    _headerView.productStore = @"该规格已下架";
                }
            }
            
            [self updateFooterView];
            
            [self.headerView updateUI];
            
            [self.tableView reloadData];
            
            if (self.selectSpecInfo) {
                
                self.selectSpecInfo();
            }
        }
    }
    else if ([request.identifier isEqualToString:WMShopCarAddIdentifier]){
        
        if ([WMShopCarOperation returnAddShopCarResultWithData:data]) {
            
            [self dismissSelf];
            
            [WMShopCarOperation updateShopCarNumberQuantity:[WMUserInfo sharedUserInfo].shopcartCount + self.goodInfo.goodBuyQuantity + self.adjunctBuyQuantity needChange:YES];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:WMShopCarAddSuccessNotifi object:nil userInfo:nil];
            
            [[AppDelegate instance] alertMsg:@"加入购物车成功"];
            
            self.adjunctBuyQuantity = 0;
        }
    }
    else if ([request.identifier isEqualToString:WMFastShopCarCheckOutIdentifier]){
        
        if ([WMShopCarOperation returnAddShopCarResultWithData:data]) {
            
            self.requesting = YES;
            
            [AppDelegate instance].showNetworkActivity = YES;
            
            self.request.identifier = WMCheckOutConfirmOrderIdentifier;
            
            [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMConfirmOrderOperation returnConfirmOrderParamWithIsFastBuy:@"true" selectGoodsArr:self.goodInfo.type == GoodPromotionTypeGift ? @[[NSString stringWithFormat:@"gift_%@_%@",self.goodInfo.goodID,self.goodInfo.productID]] : @[[NSString stringWithFormat:@"goods_%@_%@",self.goodInfo.goodID,self.goodInfo.productID]]]];
        }
    }
    else if ([request.identifier isEqualToString:WMCheckOutConfirmOrderIdentifier]){
        
        WMConfirmOrderInfo *info = [WMConfirmOrderOperation returnConfirmOrderResultWithData:data];
        
        if (info) {
            
            [self dismissSelf];
            
            if (self.goodInfo.type == GoodPromotionTypeGift) {
                
                info.isPointOrder = YES;
            }
            
            ConfirmOrderPageController *confirmOrderController = [ConfirmOrderPageController new];
            
            confirmOrderController.isFastBuy = @"true";
            
            confirmOrderController.orderInfo = info;
                        
            [self.navigation pushViewController:confirmOrderController animated:YES];
        }
    }
}

- (CGFloat)returnGoodDetailInfoSpecValueHeight{
    
    CGFloat height = 0.0;
    
    if (!self.goodInfo.goodSpecInfosArr.count) {
        
        height = WMSpecInfoSelectFooterViewHeight + WMSpecInfoSelectHeaderViewHeight + ValuesQuantityViewCellHeight * 2;
    }
    else{
        
        height = WMSpecInfoSelectHeaderViewHeight + WMSpecInfoSelectFooterViewHeight + ValuesQuantityViewCellHeight;
        
        for (WMGoodDetailSpecInfo *info in self.goodInfo.goodSpecInfosArr) {
            
            if (info.specInfoIsImage) {
                
                height += GoodValuesImageViewCellHeight;
            }
            else{
                
                height +=  ValuesCommonViewCellExtraHeight + [WMGoodDetailOperation returnTagContentHeightWithMaxWidth:_width_ titlesArr:info.titlesArr extraWidth:ValuesCommonTagExtraWidth tagCellHeight:28.0];
            }
        }
        
        if (height > _height_ - 200.0) {
            
            height = _height_ - 200.0;
        }
    }
    
    return height;
}

- (void)updateFooterView{
    
    if (self.canBuy) {
        
        [self.footerView setTitle:@"确定" forState:UIControlStateNormal];
        
        if (self.notify) {
            
            self.footerView.backgroundColor = WMMarketPriceColor;
        }
        else{
            
            self.footerView.backgroundColor = WMRedColor;
        }
    }
    else{
        
        if (self.notify) {
            
            [self.footerView setTitle:@"到货通知" forState:UIControlStateNormal];
            
            self.footerView.backgroundColor = WMRedColor;
        }
        else{
            
            [self.footerView setTitle:@"确定" forState:UIControlStateNormal];
            
            self.footerView.backgroundColor = WMMarketPriceColor;
        }
    }
    
}

- (void)footViewAction:(UIButton *)button{
    
    if (self.canBuy) {
        
        if (self.notify) {
            
            return;
        }
        else{
            
            if (self.isFastBuy) {
                
                [self fastBuyGood];
            }
            else{
                
                if (self.goodInfo.type == GoodPromotionTypeGift || self.goodInfo.type == GoodPromotionTypePrepare) {
                    
                    [self fastBuyGood];
                }
                else{
                    
                    [self addGoodToShopCar];
                }
            }
        }
    }
    else{
        
        if (self.notify) {
            
            [self dismissSelf];
    
            WMGoodCommitNotifyViewController *goodNotifyController = [WMGoodCommitNotifyViewController new];
    
            goodNotifyController.goodID = self.goodInfo.goodID;
    
            goodNotifyController.productID = self.goodInfo.productID;
    
            [self.navigation pushViewController:goodNotifyController animated:YES];
        }
        else{
            
            return;
        }
    }
}

- (void)addGoodToShopCar{
    
    self.requesting = YES;
    
    [AppDelegate instance].showNetworkActivity = YES;
    
    self.request.identifier = WMShopCarAddIdentifier;
    
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[self changeRequestParamWithParam:[WMShopCarOperation returnAddShopCarParamWithBuyType:nil goodsID:self.goodInfo.goodID productID:self.goodInfo.productID buyQuantity:self.goodInfo.goodBuyQuantity adjunctIndex:0 adjunctGoodID:nil adjunctGoodQuantity:0 goodType:self.goodInfo.type == GoodPromotionTypeGift ? @"gift" : @"goods"]]];
}

- (void)fastBuyGood{
    
    if (![AppDelegate instance].isLogin) {
        
        [[AppDelegate instance] showLoginViewControllerWithAnimate:YES];
        
        return ;
    }
    
    if (self.goodInfo.type == GoodPromotionTypeGift && !self.goodInfo.giftMessageInfo.canExchangeGift) {
        
        [self alertMsg:self.goodInfo.giftMessageInfo.notExchangeReason];
        
        return;
    }
    
    if (self.goodInfo.type == GoodPromotionTypePrepare && self.goodInfo.prepareInfo.type != PrepareSaleTypeBargainBegin) {
        
        [self alertMsg:self.goodInfo.prepareInfo.prepareStatusMessage];
        
        return;
    }
    
    self.requesting = YES;
    
    [AppDelegate instance].showNetworkActivity = YES;
    
    self.request.identifier = WMFastShopCarCheckOutIdentifier;
    
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[self changeRequestParamWithParam:[WMShopCarOperation returnAddShopCarParamWithBuyType:@"is_fastbuy" goodsID:self.goodInfo.goodID productID:self.goodInfo.productID buyQuantity:self.goodInfo.goodBuyQuantity adjunctIndex:0 adjunctGoodID:nil adjunctGoodQuantity:0 goodType:self.goodInfo.type == GoodPromotionTypeGift ? @"gift" : @"goods"]]];
}












@end

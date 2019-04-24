//
//  WMGoodListViewController.m
//  WuMei
//
//  Created by 罗海雄 on 15/7/18.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "WMGoodListViewController.h"
#import "WMGoodFilterViewController.h"
#import "WMGoodDetailContainViewController.h"
#import "WMGoodListOperation.h"
#import "WMGoodInfo.h"
#import "WMCategoryInfo.h"
#import "WMGoodListCell.h"
#import "WMGoodDetailOperation.h"
#import "WMGoodListSuspensionButton.h"
#import "WMShopCarOperation.h"
#import "WMGoodGridCell.h"
#import "SeaDropDownMenu.h"
#import "WMGoodPromotionWayView.h"
#import "WMGoodPromotionWayInfo.h"
#import "WMGoodMarkView.h"
#import "WMGoodTagView.h"
#import "WMGoodListOrderByInfo.h"
#import "WMGoodListSettings.h"
#import "WMBrandInfo.h"
#import "WMBrandDetailInfo.h"
#import "WMBrandIntroHeader.h"
#import "WMGoodFilterModel.h"
#import "WMUserInfo.h"
#import "WMSearchController.h"
#import "WMGoodDetailContainViewController.h"
#import "SeaCollectionViewFlowLayout.h"
#import "WMGoodListMenuHeader.h"
#import "WMConfirmOrderOperation.h"
#import "ConfirmOrderPageController.h"
#import "WMConfirmOrderInfo.h"
#import "WMGoodDetailPrepareInfo.h"
#import "WMShopCartEmptyView.h"

@interface WMGoodListViewController ()<SeaNetworkQueueDelegate,WMGoodListCellDelegate,SeaDropDownMenuDelegate,SeaMenuBarDelegate,UIWebViewDelegate,SeaCollectionViewFlowLayoutDelegate>

//分类菜单
@property(nonatomic,strong) SeaMenuBar *menuBar;

///排序菜单
@property(nonatomic,strong) SeaDropDownMenu *orderMenu;

//网络请求队列
@property(nonatomic,strong) SeaNetworkQueue *queue;

//商品信息 数组元素是 WMGoodInfo
@property(nonatomic,strong) NSMutableArray *goodInfos;

//选中加入购物车/立即购买的商品信息
@property (strong,nonatomic) WMGoodInfo *selectGoodInfo;

//商品分类信息
@property(nonatomic,strong) WMCategoryInfo *categoryInfo;

///商品品牌详情信息
@property(nonatomic,strong) WMBrandDetailInfo *brandDetailInfo;

///品牌简介信息
@property(nonatomic,strong) UIWebView *brandWebView;

///购物车图标
@property(nonatomic,strong) WMGoodListSuspensionButton *shopcartButton;

///是否是加载商品列表
@property(nonatomic,assign) BOOL isLoadGoodList;

///当前价格排序
@property(nonatomic,copy) NSString *currentPriceOrder;

///当前销量排序
@property(nonatomic,copy) NSString *currentBuycountOrder;

///当前使用的排序
@property(nonatomic,copy) NSString *currentOrder;

//筛选控制器
@property(strong,nonatomic) WMGoodFilterViewController *filterController;

///是否是单行列表
@property(nonatomic,assign) BOOL isSingleRow;

///促销方式
@property(nonatomic,strong) WMGoodPromotionWayView *promotionWayView;

///促销方式 数组元素是 WMGoodPromotionWayInfo
@property(nonatomic,strong) NSArray *promotionWayInfos;

///可见的视图，数组元素是 WMGoodMarkCell，建议一个viewController 只有一个，用来复用的
@property(nonatomic,strong) NSMutableSet *markVisibleCells;

///留在复用的视图，数组元素是 WMGoodMarkCell，建议一个viewController 只有一个，用来复用的
@property(nonatomic,strong) NSMutableSet *markReusedCells;

///可见的视图，数组元素是 WMGoodTagCell，建议一个viewController 只有一个，用来复用的
@property(nonatomic,strong) NSMutableDictionary *tagVisibleCells;

///留在复用的视图，数组元素是 WMGoodTagCell，建议一个viewController 只有一个，用来复用的
@property(nonatomic,strong) NSMutableDictionary *tagReusedCells;

///商品列表设置信息
@property(nonatomic,strong) WMGoodListSettings *settings;

///商品列表排序信息 数组元素是 WMGoodListOrderByInfo
@property(nonatomic,strong) NSArray *orderByInfos;

///用来获取筛选信息的分类id，nil表示无法筛选
@property(nonatomic,copy) NSString *filterCategoryId;

///筛选的参数
@property (strong,nonatomic) NSDictionary *filters;

///搜索控制器
@property(nonatomic,strong) WMSearchController *searchController;

///选中的cell
@property(nonatomic,strong) NSIndexPath *selectedIndexPath;

@end

@implementation WMGoodListViewController

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.hidesBottomBarWhenPushed = YES;
    }

    return self;
}

/**以商品分类初始化
 */
- (instancetype)initWithCategoryInfo:(WMCategoryInfo*) info
{
    self = [super init];
    if(self)
    {
        self.hidesBottomBarWhenPushed = YES;
        self.categoryInfo = info;
        self.titleName = self.categoryInfo.categoryName;
    }
    
    return self;
}

/**以商品品牌初始化
 *@param info 商品品牌信息
 *@return 一个实例
 */
- (instancetype)initWithBrandInfo:(WMBrandInfo*) info
{
    self = [super init];
    if(self)
    {
        self.hidesBottomBarWhenPushed = YES;
        self.brandInfo = info;
        self.titleName = self.brandInfo.name;
    }

    return self;
}

#pragma mark- http

- (void)networkQueue:(SeaNetworkQueue *)queue requestDidFailWithError:(NSInteger)error identifier:(NSString *)identifier
{
    if([identifier isEqualToString:WMGoodListIdentifier])
    {
        if(self.loadMore)
        {
            self.curPage --;
            [self endPullUpLoadingWithMoreInfo:YES];
        }
        
        return;
    }
    
    if([identifier isEqualToString:WMShopCarAddIdentifier])
    {
        self.requesting = NO;
        [self alerBadNetworkMsg:@"加入购物车失败"];
        return;
    }
    
    if ([identifier isEqualToString:WMFastShopCarCheckOutIdentifier]) {
        
        self.requesting = NO;
        
        [self alerBadNetworkMsg:@"立即购买失败"];
        
        return;
    }
}

- (void)networkQueue:(SeaNetworkQueue *)queue requestDidFinishWithData:(NSData *)data identifier:(NSString *)identifier
{
    if([identifier isEqualToString:WMGoodListIdentifier])
    {
        long long totalSize = 0;
        NSDictionary *dic = [WMGoodListOperation goodListFromData:data totalSize:&totalSize];

        if(dic)
        {
            NSArray *infos = [dic arrayForKey:@"good"];
            self.totalCount = totalSize;

            if(self.loadMore)
            {
                [self.goodInfos addObjectsFromArray:infos];
            }
            else
            {
                self.curPage = WMHttpPageIndexStartingValue;
                [self.goodInfos removeAllObjects];
                [self.goodInfos addObjectsFromArray:infos];
            }

            if(!self.settings && self.curPage == WMHttpPageIndexStartingValue)
            {
                self.settings = [dic objectForKey:@"setting"];
                self.orderByInfos = [dic objectForKey:@"orderBy"];
                self.brandDetailInfo = [dic objectForKey:@"brand"];
                
                NSString *filterId = [dic objectForKey:@"filter"];
                
                ///获取筛选参数的分类id改变了
                if(self.filterController)
                {
                    if(filterId && ![filterId isEqualToString:self.filterCategoryId])
                    {
                        self.filterController.goodCateID = filterId;
                        [self.filterController reloadDataFromNetwork];
                    }
                    
                    SeaDropDownMenuItem *item = [self.orderMenu.items lastObject];
                    ///判断菜单是否需要改变
                    if((filterId && ![item.title isEqualToString:@"筛选"]) || (!filterId && [item.title isEqualToString:@"筛选"]))
                    {
                        [self reloadMenu];
                    }
                }
                
                
                self.filterCategoryId = filterId;
            }
        }

        return;
    }
    
    if([identifier isEqualToString:WMShopCarAddIdentifier])
    {
        if ([WMShopCarOperation returnAddShopCarResultWithData:data]) {
            
            if (self.selectGoodInfo.isPresell) {
                
                self.requesting = YES;
                
                [self.queue addRequestWithURL:SeaNetworkRequestURL param:[WMConfirmOrderOperation returnConfirmOrderParamWithIsFastBuy:@"true" selectGoodsArr:@[[NSString stringWithFormat:@"goods_%@_%@",self.selectGoodInfo.goodId,self.selectGoodInfo.productId]]] identifier:WMCheckOutConfirmOrderIdentifier];
                
                [self.queue startDownload];
                
            }
            else{
                
                self.requesting = NO;
                
                [WMShopCarOperation updateShopCarNumberQuantity:[WMUserInfo sharedUserInfo].shopcartCount + 1 needChange:YES];
                
                self.shopcartButton.badge.value = [WMUserInfo displayShopcarCount];
                
                [self alertMsg:@"加入购物车成功"];
            }
        }
        else{
            
            self.requesting = NO;
            
            self.showNetworkActivity = NO;
        }
    
        return;
    }
    
    if ([identifier isEqualToString:WMCheckOutConfirmOrderIdentifier]) {
        
        self.requesting = NO;
        
        self.showNetworkActivity = NO;
        
        WMConfirmOrderInfo *info = [WMConfirmOrderOperation returnConfirmOrderResultWithData:data];
        
        if (info) {
            
            ConfirmOrderPageController *confirmOrder = [[ConfirmOrderPageController alloc] init];
            
            confirmOrder.isFastBuy = @"true";
            
            confirmOrder.orderInfo = info;
            
            [self.navigationController pushViewController:confirmOrder animated:YES];
        }
        return;
    }

    [WMGoodListOperation goodCollectResultFromData:data];
}

- (void)networkQueueDidFinish:(SeaNetworkQueue *)queue
{
    if(self.isLoadGoodList)
    {
        self.isLoadGoodList = NO;
        self.loadMoreControl.hidden = NO;
        self.requesting = NO;

        if(!self.collectionView)
        {
            [self initialization];
        }
        else
        {
            [self.collectionView reloadData];
        }

        if(self.refreshing)
        {
            [self endDropDownRefreshWithMsg:nil];
        }

        [self endPullUpLoadingWithMoreInfo:self.goodInfos.count < self.totalCount];
    }

    if([NSString isEmpty:self.brandDetailInfo.intro])
    {
        self.collectionView.sea_shouldShowEmptyView = YES;
    }
}

#pragma mark - 筛选视图

- (void)configureFilterController{
    
    WeakSelf(self);
    
    self.filterController = [[WMGoodFilterViewController alloc] init];
    self.filterController.filterGoodCount = self.totalCount;
    self.filterController.goodCateID = self.filterCategoryId;
    self.filterController.hasCategoryMenuBar = self.menuBar != nil;
    
    SeaPartialPresentTransitionDelegate *delegate = [[SeaPartialPresentTransitionDelegate alloc] init];
    delegate.backTransform = CGAffineTransformIdentity;
    delegate.transitionStyle = SeaPresentTransitionStyleCoverHorizontal;
    self.filterController.sea_transitioningDelegate = delegate;
    self.filterController.view.frame = CGRectMake(50.0, self.orderMenu.bottom, _width_ - 50.0, _height_);
    
    [self.filterController setConfirmButtonClick:^() {
        
        [weakSelf removeFilter];
        
    }];

    
//    [self.filterController setHttpFinishCallBack:^(NSArray *filterInfoArr) {
//        
//        WMCategoryInfo *info = nil;
//        
//        if(weakSelf.categoryInfo.categoryInfos.count > 0)
//        {
//            info = [weakSelf.categoryInfo.categoryInfos objectAtIndex:weakSelf.menuBar.selectedIndex];
//        }
//        else
//        {
//            info = weakSelf.categoryInfo;
//        }
//        
//        if (info) {
//            
//            info.filterInfoArr = filterInfoArr;
//        }
//        else{
//            
//            weakSelf.categoryInfo.filterInfoArr = filterInfoArr;
//        }
//    }];
}

//加载商品信息
- (void)loadInfo
{
    
    self.isLoadGoodList = YES;
    WMCategoryInfo *info = self.categoryInfo;
    if(self.categoryInfo.categoryInfos.count > 0)
    {
        info = [self.categoryInfo.categoryInfos objectAtIndex:self.menuBar.selectedIndex];
    }
    
    [self.queue addRequestWithURL:SeaNetworkRequestURL
                            param:[WMGoodListOperation goodListParamWithCategoryId:info.isVirtualCategory ? 0 : info.categoryId
                                                                 virtualCategoryId:info.isVirtualCategory ? info.categoryId : 0
                                                                           brandId:self.brandInfo.Id
                                                                    promotionTagId:self.promotionTagId
                                                                             order:self.currentOrder
                                                                         searchKey:self.searchKey
                                                                         pageIndex:self.loadMore ? self.curPage : WMHttpPageIndexStartingValue
                                                                           filters:self.filters
                                                                      needSettings:self.settings == nil onlyPresell:self.onlyPresell]
                       identifier:WMGoodListIdentifier];
    [self.queue startDownload];
}

- (void)reloadDataFromNetwork
{
    self.loading = YES;
    
    [self loadInfo];
}

- (void)beginPullUpLoading
{
    self.curPage ++;
    [self loadInfo];
}

- (void)beginDropDownRefresh
{
    [self loadInfo];
}

///重新加载数据
- (void)reloadData
{
    self.isLoadGoodList = YES;
    self.totalCount = 0;
    self.collectionView.sea_shouldShowEmptyView = NO;
    self.loadMoreControl.hidden = YES;

    [self.goodInfos removeAllObjects];
    [self.collectionView reloadData];
    
    self.curPage = WMHttpPageIndexStartingValue;

    if(self.loading)
    {
        [self.queue cancelRequestWithIdentifier:WMGoodListIdentifier];
        [self loadInfo];
    }
    else
    {
        self.requesting = YES;
        self.showNetworkActivity = YES;
        [self loadInfo];
    }

    //[self.refreshControl beginRefresh];
}

#pragma mark- 加载视图

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.shopcartButton.badge.value = [WMUserInfo displayShopcarCount];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    ///搜索进来的，添加搜索栏
//    if(![NSString isEmpty:self.searchKey])
//    {
        self.navigationItem.hidesBackButton = YES;
        ///搜索栏
        self.searchController = [[WMSearchController alloc] initWithViewController:self];
        self.searchController.searchContent = self.searchKey;
        self.searchController.keepSearchContent = YES;

        WeakSelf(self);
        self.searchController.searchHandler = ^(NSString *searchKey){

            if(![searchKey isEqualToString:weakSelf.searchKey])
            {
                ///有品牌信息和分类信息时，不需要刷新筛选信息
                if(!self.brandInfo && !self.categoryInfo)
                {
                    weakSelf.settings = nil;
                }
                weakSelf.searchKey = searchKey;
                [weakSelf reloadData];
            }
        };

        self.searchController.searchDidEndHandler = ^(void){

            weakSelf.backItem = YES;
            [weakSelf setRightBaritem];
        };
        
        self.searchController.searchDidBeginHandler = ^(void){
          
            [weakSelf removeFilter];
            [weakSelf.orderMenu closeList];
        };
  //  }

    self.tagReusedCells = [NSMutableDictionary dictionary];
    self.tagVisibleCells = [NSMutableDictionary dictionary];
    self.markReusedCells = [NSMutableSet set];
    self.markVisibleCells = [NSMutableSet set];

    self.view.backgroundColor = _SeaViewControllerBackgroundColor_;
    self.goodInfos = [NSMutableArray array];
    self.backItem = YES;
    self.title = self.titleName;
    self.queue = [[SeaNetworkQueue alloc] initWithDelegate:self];
    
    ///是否有次级级分类
//    if(self.categoryInfo.categoryInfos.count > 0)
//    {
//        NSMutableArray *itmes = [NSMutableArray arrayWithCapacity:self.categoryInfo.categoryInfos.count];
//        
//        for(WMCategoryInfo *info in self.categoryInfo.categoryInfos)
//        {
//            [itmes addNotNilObject:info.categoryName];
//        }
//        
//        SeaMenuBar *menu = [[SeaMenuBar alloc] initWithFrame:CGRectMake(0, 0, _width_, _SeaMenuBarHeight_) titles:itmes style:SeaMenuBarStyleItemWithRelateTitle];
//        menu.titleColor = MainTextColor;
//        menu.showSeparator = NO;
//        menu.selectedIndex = 0;
//        menu.buttonWidthExtension = 20.0;
//        menu.topSeparatorLine.hidden = YES;
//        menu.delegate = self;
//        self.menuBar = menu;
//    }

    self.currentOrder = nil;
    self.currentPriceOrder = WMGoodOrderByPiceAsc;
    self.currentBuycountOrder = WMGoodOrderByBuyCountDesc;
    
    self.view.backgroundColor = _SeaViewControllerBackgroundColor_;

    
    [self reloadDataFromNetwork];
}

- (void)initialization
{
    ///如果有品牌简介，等品牌简介加载完成在显示
    if([NSString isEmpty:self.brandDetailInfo.intro])
    {
        self.loading = NO;
    }
    else
    {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, _width_, self.brandDetailInfo.introHeight)];
        webView.delegate = self;
        webView.scrollView.showsVerticalScrollIndicator = NO;
        webView.scrollView.showsHorizontalScrollIndicator = NO;
        webView.scalesPageToFit = NO;
        webView.backgroundColor = [UIColor whiteColor];
        self.brandWebView = webView;

    }

     self.isSingleRow = self.settings.isSingleRow;
    
    [self initMenu];

    self.badNetworkRemindView.hidden = YES;

    SeaCollectionViewFlowLayout *layout = [[SeaCollectionViewFlowLayout alloc] init];
    layout.sectionHeaderSuspending = ![NSString isEmpty:self.brandDetailInfo.intro];
    self.layout = layout;
    
    [super initialization];

    [self.collectionView registerNib:[UINib nibWithNibName:@"WMGoodListCell" bundle:nil] forCellWithReuseIdentifier:@"WMGoodListCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"WMGoodGridCell" bundle:nil] forCellWithReuseIdentifier:@"WMGoodGridCell"];
    [self.collectionView registerClass:[WMBrandIntroHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WMBrandIntroHeader"];
    [self.collectionView registerClass:[WMGoodListMenuHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WMGoodListMenuHeader"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView"];

    CGFloat bottom = 0;
    ///分类菜单
    if(self.menuBar)
    {
        [self.view addSubview:self.menuBar];
        bottom = self.menuBar.bottom;
    }
    
    if([NSString isEmpty:self.brandDetailInfo.intro])
    {
        [self.view addSubview:self.orderMenu];
        bottom = self.orderMenu.bottom;
    }
    self.collectionView.backgroundColor = self.view.backgroundColor;

    ///促销类型
    if(self.promotionWayInfos.count > 0)
    {
        self.promotionWayView = [[WMGoodPromotionWayView alloc] initWithFrame:CGRectMake(0, self.orderMenu.bottom, _width_, _SeaMenuBarHeight_) infos:self.promotionWayInfos];
        self.promotionWayView.selectHandler = ^(void){

        };
        [self.view addSubview:self.promotionWayView];
        bottom = self.promotionWayView.bottom;
    }

    CGRect frame = self.collectionView.frame;
    frame.origin.y = bottom;
    frame.size.height -= bottom;
    
    if (isIPhoneX) {
        
        frame.size.height -= 35;
    }
    
    self.collectionView.frame = frame;
    
    self.enablePullUp = YES;
    self.enableDropDown = YES;
    self.loadMoreControl.backgroundColor = self.view.backgroundColor;
    
    ///购物车按钮
    self.shopcartButton = [[WMGoodListSuspensionButton alloc] initWithFrame:CGRectMake(_width_ - WMGoodListSuspensionButtonSize.width - 15.0, self.collectionView.bottom - WMGoodListSuspensionButtonSize.height - 15.0, WMGoodListSuspensionButtonSize.width, WMGoodListSuspensionButtonSize.height)];
    self.shopcartButton.navigationController = self.navigationController;
    self.shopcartButton.scrollView = self.scrollView;
    [self.view addSubview:self.shopcartButton];

    ///添加商品操作通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goodCollectDidChange:) name:WMGoodCollectDidChangeNotification object:nil];
    
    self.shopcartButton.badge.value = [WMUserInfo displayShopcarCount];
}

///菜单信息
- (void)initMenu
{
    if(self.goodInfos.count == 0 && ![NSString isEmpty:self.brandDetailInfo.intro])
        return;
    
    [self setRightBaritem];
    
    [self reloadMenu];
    
    if(self.filterCategoryId)
    {
        [self configureFilterController];
    }
}

///重新创建菜单
- (void)reloadMenu
{
    if(self.orderMenu)
    {
        [self.orderMenu removeFromSuperview];
    }
    NSMutableArray *itmes = [NSMutableArray arrayWithCapacity:4];
    
    SeaDropDownMenuItem *info = [[SeaDropDownMenuItem alloc] init];
    info.title = @"默认";
    
    if(self.orderByInfos.count > 0)
    {
        NSMutableArray *titleList = [NSMutableArray arrayWithCapacity:self.orderByInfos.count];
        for(WMGoodListOrderByInfo *orderBy in self.orderByInfos)
        {
            if(orderBy.name)
            {
                [titleList addObject:orderBy.name];
            }
        }
        info.title = nil;
        info.titleLists = titleList;
    }
    
    [itmes addObject:info];
    
    info = [[SeaDropDownMenuItem alloc] init];
    info.title = @"价格";
    info.normalImage = [UIImage imageNamed:@"goodlist_price_n"];
    info.highlightedImage1 = [UIImage imageNamed:@"goodlist_price_s1"];
    info.highlightedImage2 = [UIImage imageNamed:@"goodlist_price_s2"];
    [itmes addObject:info];
    
    info = [[SeaDropDownMenuItem alloc] init];
    info.title = @"销量";
    [itmes addObject:info];
    
    if(self.filterCategoryId)
    {
        info = [[SeaDropDownMenuItem alloc] init];
        info.title = @"筛选";
        info.normalImage = [UIImage imageNamed:@"goodlist_filter_icon"];
        [itmes addObject:info];
    }
    
    SeaDropDownMenu *menu = [[SeaDropDownMenu alloc] initWithFrame:CGRectMake(0, self.menuBar.bottom, _width_, SeaDropDownMenuHeight) items:itmes];
    menu.selectedIndex = 0;
    menu.delegate = self;
    menu.listSuperview = self.view;
    menu.indicatorImage = [UIImage imageNamed:@"tick_small"];
    self.orderMenu = menu;
    
    if(self.collectionView)
    {
        [self.view addSubview:self.orderMenu];
    }
}

///列表样式切换
- (void)listStyleChange
{
    [self removeFilter];

    self.isSingleRow = !self.isSingleRow;
    
    [self setRightBaritem];

    [self.collectionView reloadData];
}

///设置右边导航栏按钮
- (void)setRightBaritem
{
    if(self.isSingleRow)
    {
        [self setBarItemsWithTitle:nil icon:[UIImage imageNamed:@"goodlist_double"] action:@selector(listStyleChange) position:SeaNavigationItemPositionRight];
    }
    else
    {
        [self setBarItemsWithTitle:nil icon:[UIImage imageNamed:@"goodlist_single"] action:@selector(listStyleChange) position:SeaNavigationItemPositionRight];
    }
}

///获取商品列表的高度
- (CGFloat)goodListHeight
{
    CGFloat height = self.brandDetailInfo.introHeight + _SeaMenuBarHeight_;
    if(self.goodInfos.count > 0)
    {
        if(self.isSingleRow)
        {
            return WMGoodListCellMargin * 2 + (self.goodInfos.count - 1) * WMGoodListCellMargin + self.goodInfos.count * WMGoodListCellSize.height;
        }
        else
        {
            int row = (self.goodInfos.count - 1) / 2 + 1;
            return WMGoodGridCellInterval * 2 + (row - 1) * WMGoodGridCellInterval + row * WMGoodGridCellSize.height;
        }
    }
    else
    {
        height += WMGoodListMenuHeaderNoGoodHeight;
    }
    
    return height;
}

///header回到顶部
- (void)headerScrollToTop
{
    if(![NSString isEmpty:self.brandDetailInfo.intro])
    {
        ///把header弄到顶部
        if (self.collectionView.contentOffset.y < self.brandDetailInfo.introHeight)
        {
            self.collectionView.contentOffset = CGPointMake(0, self.brandDetailInfo.introHeight);
        }
    }
}

#pragma mark- SeaEmptyView

- (void)emptyViewWillAppear:(SeaEmptyView *)view
{
    WMShopCartEmptyView *emptyView = [[WMShopCartEmptyView alloc] init];
    
    emptyView.height = self.collectionView.height;
    
    emptyView.shopping_btn.hidden = YES;
    
    emptyView.logo_imageView.image = [UIImage imageNamed:@"good_list_empty"];
    
    emptyView.title_label.text = @"没有找到任何相关信息";
    
    emptyView.subtitle_label.text = @"选择或搜索其他商品分类/名称";
    
    emptyView.backgroundColor = _SeaViewControllerBackgroundColor_;
    
    view.customView = emptyView;
}

#pragma mark- 通知

///商品收藏
- (void)goodCollectDidChange:(NSNotification*) notification
{
    BOOL status = [[notification.userInfo objectForKey:WMGoodCollectStatus] boolValue];
    NSString *goodId = [notification.userInfo objectForKey:WMGoodOperationGoodId];

    for(WMGoodInfo *info in self.goodInfos)
    {
        if([info.goodId isEqualToString:goodId])
        {
            info.isCollect = status;
            [self.collectionView reloadData];
            break;
        }
    }
}

#pragma mark- 排序

///筛选
- (void)filter
{
    if(!self.filterController.view.superview)
    {
        [self headerScrollToTop];
        self.filterController.filterGoodCount = self.totalCount;
        [self presentViewController:self.filterController animated:YES completion:nil];
    }
    else
    {
        [self removeFilter];
    }
}

///移除筛选
- (void)removeFilter
{
//    if (self.filterController.view.superview)
//    {
        ///筛选参数是否改变
        NSDictionary *filters = [self.filterController filters];
        if(![filters isEqualToDictionary:self.filters] && !(filters.count == 0 && self.filters == nil))
        {
            self.filters = filters;
            self.collectionView.contentOffset = CGPointZero;
            [self.refreshControl beginRefresh];
        }
        
        [self.filterController dismissViewControllerAnimated:YES completion:nil];
        
        return;
   // }
}


#pragma mark- SeaMenuBar delegate

- (void)menuBar:(SeaMenuBar *)menu didSelectItemAtIndex:(NSInteger)index
{
    [self removeFilter];
    [self reloadData];
}

#pragma mark- SeaDropDownMenu delegate

- (CGFloat)YAsixAtListInDropDwonMenu:(SeaDropDownMenu *)menu
{
    [self headerScrollToTop];
    return menu.height;
}

- (BOOL)dropDownMenu:(SeaDropDownMenu *)menu shouldShowListInItem:(SeaDropDownMenuItem *)item
{
    return NO;
}

- (void)dropDownMenu:(SeaDropDownMenu *)menu didSelectItem:(SeaDropDownMenuItem *)item
{
    [self removeFilter];
    
    //商品排序
    NSString *order = nil;
    switch (item.itemIndex)
    {
        case 2 :
        {
            order = self.currentBuycountOrder;
        }
            break;
        case 1 :
        {
            if([self.currentPriceOrder isEqualToString:self.currentOrder])
            {
                if([self.currentPriceOrder isEqualToString:WMGoodOrderByPiceAsc])
                {
                    self.currentPriceOrder = WMGoodOrderByPiceDesc;
                }
                else
                {
                    self.currentPriceOrder = WMGoodOrderByPiceAsc;
                }
            }
            order = self.currentPriceOrder;
        }
            break;
        case 0 :
        {
            if(self.orderByInfos.count > 0)
            {
                WMGoodListOrderByInfo *info = [self.orderByInfos objectAtIndex:item.selectedIndex];
                order = info.key;
            }
        }
            break;
        default:
            break;
    }

    self.currentOrder = order;

    [self reloadData];
}

- (void)dropDownMenu:(SeaDropDownMenu *)menu didSelectItemWithSecondMenu:(SeaDropDownMenuItem *)item
{
    WMGoodListOrderByInfo *info = [self.orderByInfos objectAtIndex:item.selectedIndex];
    self.currentOrder = info.key;

    [self reloadData];
}

- (BOOL)dropDownMenu:(SeaDropDownMenu *)menu shouldSelectItem:(SeaDropDownMenuItem *)item
{
    if(item.itemIndex == 3)
    {
        if(self.filterController.view.superview)
        {
            [self removeFilter];
        }
        else
        {
            [menu closeList];
            [self filter];
        }
        return NO;
    }

    return YES;
}

#pragma mark- SeaCollectionViewFlowLayout delegate

- (BOOL)collectionViewFlowLayout:(SeaCollectionViewFlowLayout *)layout shouldSuspendHeaderForSection:(NSInteger)section
{
    return section == 1;
}

#pragma mark- UICollectionView delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if(!self.orderMenu)
        return 1;
    
    return [NSString isEmpty:self.brandDetailInfo.intro] ? 1 : 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(![NSString isEmpty:self.brandDetailInfo.intro] && section == 0)
    {
        return 0;
    }
    
    return self.goodInfos.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.isSingleRow ? WMGoodListCellSize : WMGoodGridCellSize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return self.isSingleRow ? WMGoodListCellMargin : WMGoodGridCellInterval;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return self.isSingleRow ? 0 : WMGoodGridCellInterval;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if(![NSString isEmpty:self.brandDetailInfo.intro])
    {
        switch (section)
        {
            case 0 :
            {
                return CGSizeMake(_width_, self.brandDetailInfo.introHeight);
            }
                break;
            case 1 :
            {
                return CGSizeMake(_width_, _SeaMenuBarHeight_ + ((self.goodInfos.count > 0 || self.isLoadGoodList) ? 0 : WMGoodListMenuHeaderNoGoodHeight));
            }
                break;
            default:
                break;
        }
    }

    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if(![NSString isEmpty:self.brandDetailInfo.intro] && section == 1)
    {
        CGFloat contentHeight = [self goodListHeight] + _SeaMenuBarHeight_;
        
        ///判断内容是否已经够回到顶部了
        if(contentHeight < self.collectionView.height)
        {
            return CGSizeMake(_width_, self.collectionView.height - contentHeight);
        }
    }
    
    return CGSizeZero;
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        switch (indexPath.section)
        {
            case 0 :
            {
                WMBrandIntroHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"WMBrandIntroHeader" forIndexPath:indexPath];
                header.webView = self.brandWebView;
                
                return header;
            }
                break;
            case 1 :
            {
                WMGoodListMenuHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"WMGoodListMenuHeader" forIndexPath:indexPath];
                header.menuBar = self.orderMenu;
                header.textLabel.text = @"暂无商品信息";
                header.textLabel.hidden = self.goodInfos.count > 0 || self.isLoadGoodList;
                
                return header;
            }
            default:
                break;
        }
    }
    else
    {
        UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
        footer.backgroundColor = [UIColor clearColor];
        
        return footer;
    }
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    if(!self.brandDetailInfo.introIsFinishLoading)
    {
        [self.brandWebView loadHTMLString:self.brandDetailInfo.intro baseURL:nil];
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if(![NSString isEmpty:self.brandDetailInfo.intro] && section == 0)
        return UIEdgeInsetsZero;
    
    return self.isSingleRow ? UIEdgeInsetsMake(WMGoodListCellMargin, WMGoodListCellMargin, WMGoodListCellMargin, WMGoodListCellMargin) : UIEdgeInsetsMake(WMGoodGridCellInterval, WMGoodGridCellInterval, WMGoodGridCellInterval, WMGoodGridCellInterval);
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WMGoodInfo *info = [self.goodInfos objectAtIndex:indexPath.item];
    WMGoodBaseCollectionViewCell *cell = nil;
    if(self.isSingleRow)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WMGoodListCell" forIndexPath:indexPath];
        WMGoodListCell *cell1 = (WMGoodListCell*)cell;
        cell.navigationController = self.navigationController;

        [[cell1 mark_view] setVisibleCells:self.markVisibleCells];
        [[cell1 mark_view] setReusedCells:self.markReusedCells];
        [[cell1 tag_view] setVisibleCells:self.tagVisibleCells];
        [[cell1 tag_view] setReusedCells:self.tagReusedCells];

        cell1.comment_count_label.hidden = !self.settings.showCommentCount;
    }
    else
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WMGoodGridCell" forIndexPath:indexPath];

        WMGoodGridCell *cell1 = (WMGoodGridCell*)cell;

        [[cell1 mark_view] setVisibleCells:self.markVisibleCells];
        [[cell1 mark_view] setReusedCells:self.markReusedCells];
        [[cell1 tag_view] setVisibleCells:self.tagVisibleCells];
        [[cell1 tag_view] setReusedCells:self.tagReusedCells];

        cell1.comment_count_label.hidden = !self.settings.showCommentCount;
    }

    cell.info = info;
    cell.delegate = self;

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    WMGoodInfo *info = [_goodInfos objectAtIndex:indexPath.row];
    
    WMGoodDetailContainViewController *goodDetailController = [[WMGoodDetailContainViewController alloc] init];
    
    goodDetailController.productID = info.productId;
    
    goodDetailController.goodID = info.goodId;
    
    [self.navigationController pushViewController:goodDetailController animated:YES];
}

///让默认的回到顶部按钮不显示
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

#pragma mark- UIWebView delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if(!self.brandDetailInfo.introIsFinishLoading)
    {
        self.brandDetailInfo.introIsFinishLoading = YES;
        CGFloat height = 0;
        webView.height = 1;
        height = webView.scrollView.contentSize.height;

        self.brandDetailInfo.introHeight = height;
        [self.collectionView reloadData];

        ///延迟显示，让webView渲染
        WeakSelf(self);
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.25 * NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), ^(void){

            weakSelf.loading = NO;
        });
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = request.URL.absoluteString;
    if(![url isEqualToString:@"about:blank"])
    {
        SeaWebViewController *web = [[SeaWebViewController alloc] initWithURL:url];
        web.backItem = YES;
        [self.navigationController pushViewController:web animated:YES];
        
        return NO;
    }
    
    return YES;
}

#pragma mark- WMGoodListCell delegate

- (void)goodListCellDidShopcartAdd:(WMGoodBaseCollectionViewCell *)cell
{
    ///不登录也可以加入购物车
    [self shopcartAddWithInfo:cell.info];
//    if([AppDelegate instance].isLogin)
//    {
//        [self shopcartAddWithInfo:cell.info];
//    }
//    else
//    {
//        WeakSelf(self);
//        [[AppDelegate instance] showLoginViewControllerWithAnimate:YES completion:nil loginCompletion:^(void){
//
//            
//        }];
//    }
}

- (void)goodListCellDidCollect:(WMGoodListCell *)cell
{
    if([AppDelegate instance].isLogin)
    {
        [self goodDidCollect:cell];
    }
    else
    {
        WeakSelf(self);
        [[AppDelegate instance] showLoginViewControllerWithAnimate:YES completion:nil loginCompletion:^(void){

            [weakSelf goodDidCollect:cell];
        }];
    }
}

///加入购物车
- (void)shopcartAddWithInfo:(WMGoodInfo*) info
{
    self.selectGoodInfo = info;
    self.showNetworkActivity = YES;
    self.requesting = YES;
    
    if (info.isPresell) {
        
        if (info.preapreType != PrepareSaleTypeBargainBegin) {
            
            self.requesting = NO;
            
            self.showNetworkActivity = NO;
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:info.prepareMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [alertView show];
            
            return;
        }
        
        ///预售商品只能立即购买
        [self.queue addRequestWithURL:SeaNetworkRequestURL param:[WMShopCarOperation returnAddShopCarParamWithBuyType:@"is_fastbuy" goodsID:info.goodId productID:info.productId buyQuantity:1 adjunctIndex:0 adjunctGoodID:nil adjunctGoodQuantity:0 goodType:@"goods"] identifier:WMShopCarAddIdentifier];
        [self.queue startDownload];
    }
    else{
        
        [self.queue addRequestWithURL:SeaNetworkRequestURL param:[WMShopCarOperation returnAddShopCarParamWithBuyType:nil goodsID:info.goodId productID:info.productId buyQuantity:1 adjunctIndex:0 adjunctGoodID:nil adjunctGoodQuantity:0 goodType:@"goods"] identifier:WMShopCarAddIdentifier];
        [self.queue startDownload];
    }
}

///商品收藏
- (void)goodDidCollect:(WMGoodListCell*) cell
{
    WMGoodInfo *info = cell.info;
    info.isCollect = !info.isCollect;
    cell.collect_btn.selected = !cell.collect_btn.selected;
    [self.queue addRequestWithURL:SeaNetworkRequestURL param:[WMGoodListOperation goodCollectParamWithType:info.isCollect ? 0 : 1 goodId:info.goodId] identifier:info.goodId];
    [self.queue startDownload];
}

@end

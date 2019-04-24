//
//  WMShopCarForOrderViewController.m
//  StandardShop
//
//  Created by mac on 16/6/22.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMShopCarForOrderViewController.h"

#import "WMGoodListCollectionViewCell.h"

#import "WMShopCarGoodInfo.h"
#import "WMShopCarOperation.h"
#import "WMUserInfo.h"

@interface WMShopCarForOrderViewController ()<SeaHttpRequestDelegate,SeaMenuBarDelegate>
/**网络请求
 */
@property (strong,nonatomic) SeaHttpRequest *request;
@end

@implementation WMShopCarForOrderViewController

#pragma mark - 控制器生命周期
- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        
        self.title = @"凑单商品";
        
        self.backItem = YES;
        
        self.hidesBottomBarWhenPushed = YES;
        
        self.request = [[SeaHttpRequest alloc] initWithDelegate:self];
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = _SeaViewControllerBackgroundColor_;
    
    self.loading = YES;
    
    self.requesting = YES;
    
    [self reloadDataFromNetwork];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - 初始化
- (void)initialization
{
    CGFloat margin = 8.0;
    
    CGFloat imageMargin = 4.0;
    
    CGFloat topMargin = 8.0;
    
    CGFloat cellWidth = (_width_ - 3 * margin) / 2.0;
    
    CGFloat cellHeight = topMargin + (cellWidth - imageMargin * 2) + 80;
    
    self.layout.itemSize = CGSizeMake(cellWidth, cellHeight);
    
    self.layout.minimumLineSpacing = margin;
    
    self.layout.minimumInteritemSpacing = margin;
    
    self.layout.sectionInset = UIEdgeInsetsMake(margin, margin, 0, margin);
    
    [super initialization];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"WMGoodListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:WMGoodListCollectionViewCellIden];
    
    self.collectionView.frame = CGRectMake(0, self.menuBar.bottom, _width_, self.contentHeight - _SeaMenuBarHeight_);
    
    self.collectionView.backgroundColor = [UIColor clearColor];
}

- (void)configureMenuBar{
    
    NSMutableArray *titlesArr = [NSMutableArray arrayWithCapacity:_tabContentsArr.count];
    
    for (NSDictionary *dict in _tabContentsArr) {
        
        [titlesArr addObject:[dict sea_stringForKey:@"tab_name"]];
    }
    
    SeaMenuBar *menuBar = [[SeaMenuBar alloc] initWithFrame:CGRectMake(0, 0, _width_, _SeaMenuBarHeight_) titles:titlesArr style:SeaMenuBarStyleItemWithRelateTitle];
    
    menuBar.delegate = self;
    
    self.menuBar = menuBar;
    
    [self.view addSubview:self.menuBar];
}

#pragma mark - 网络请求
- (void)reloadDataFromNetwork{
    
    self.request.identifier = WMShopCarForOrderIdentifier;
    
    NSString *filter;
    
    if (self.menuBar) {
        
        NSDictionary *dict = [self.tabContentsArr objectAtIndex:self.menuBar.selectedIndex];
        
        filter = [dict sea_stringForKey:@"tab_filter"];
    }
    else{
        
        filter = nil;
    }
        
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMShopCarOperation returnForOrderGoodWithPriceFilter:filter]];
}

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error{
    
    self.requesting = NO;
    
    self.showNetworkActivity = NO;
    
    self.loading = NO;
    
    if ([request.identifier isEqualToString:WMShopCarForOrderIdentifier]) {
        
        [self failToLoadData];
    }
    else{
        
        [self alertMsg:@"网络错误，请重试"];
    }
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data{
    
    self.requesting = NO;
    
    self.showNetworkActivity = NO;
    
    if ([request.identifier isEqualToString:WMShopCarForOrderIdentifier]) {
        
        NSDictionary *dict = [WMShopCarOperation returnForOrderGoodResutlWithData:data];
        
        if (dict) {
            
            if (!self.collectionView) {
                
                self.tabContentsArr = [dict arrayForKey:@"fororder_tab"];
                
                [self configureMenuBar];
                
                [self initialization];
                
                self.menuBar.selectedColor = 0;
                
                [self reloadDataFromNetwork];
            }
            else{
                
                self.loading = NO;
                
                self.datasArr = [dict arrayForKey:@"list"];
                
                [self setHasNoMsgViewHidden:self.datasArr.count == 0 ? NO : YES msg:@"暂无商品"];
                
                [self.collectionView reloadData];
            }
        }
        else{
            
            [self failToLoadData];
        }
    }
    else{
        
        if ([WMShopCarOperation returnAddShopCarResultWithData:data]) {
            
            [WMShopCarOperation updateShopCarNumberQuantity:[WMUserInfo sharedUserInfo].shopcartCount + 1 needChange:YES];
            
            [self alertMsg:@"加入购物车成功"];
        }
    }
    
}

#pragma mark - 集合视图协议
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.datasArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WeakSelf(self);
    
    WMGoodListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WMGoodListCollectionViewCellIden forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    WMShopCarForOrderGoodInfo *goodInfo = [_datasArr objectAtIndex:indexPath.row];
    
    [cell configureCellWithForOrderGoodInfoWith:goodInfo];
    
    [cell setAddShopCarCallBack:^(NSString *productID) {
        
        weakSelf.requesting = YES;
        
        weakSelf.showNetworkActivity = YES;
        
        weakSelf.request.identifier = WMShopCarAddIdentifier;
        
        [weakSelf.request downloadWithURL:SeaNetworkRequestURL dic:[WMShopCarOperation returnAddShopCarParamWithBuyType:nil goodsID:goodInfo.goodID productID:productID buyQuantity:1 adjunctIndex:0 adjunctGoodID:nil adjunctGoodQuantity:0 goodType:@"goods"]];
    }];
    
    return cell;
}

#pragma mark - 菜单栏协议
- (void)menuBar:(SeaMenuBar *)menu didSelectItemAtIndex:(NSInteger)index{
    
    self.requesting = YES;
    
    self.showNetworkActivity = YES;
    
    [self reloadDataFromNetwork];
}
















@end

//
//  WMGoodCategoryViewController.m
//  WuMei
//
//  Created by 罗海雄 on 15/7/18.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "WMGoodCategoryViewController.h"
#import "WMGoodCategoryCell.h"
#import "WMGoodListViewController.h"
#import "WMCategoryOperation.h"
#import "WMCategoryInfo.h"
#import "WMGoodCategorySectionHeader.h"
#import "WMGoodCategorySeparator.h"

@interface WMGoodCategoryViewController ()<SeaHttpRequestDelegate,WMGoodCategorySectionImageHeaderDelegate>

/**一级分类列表
 */
@property(nonatomic,strong) UITableView *tableView;

/**次级分类列表
 */
@property(nonatomic,strong) UICollectionView *collectionView;

/**选中的一级分类
 */
@property(nonatomic,strong) NSIndexPath *selectedIndexPath;

/**网络请求
 */
@property(nonatomic,strong) SeaHttpRequest *httpRequest;

/**商品分类 数组元素是 WMCategoryInfo
 */
@property(nonatomic,strong) NSArray *categoryInfos;

@end

@implementation WMGoodCategoryViewController

#pragma mark- http

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
    [self failToLoadData];
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{
    self.categoryInfos = [WMCategoryOperation goodCategoryFromData:data];

    if(self.categoryInfos)
    {
        self.loading = NO;
        [self initialization];
    }
    else
    {
        [self failToLoadData];
    }
}

//加载数据
- (void)loadInfo
{
    self.loading = YES;
    
    self.httpRequest = [[SeaHttpRequest alloc] initWithDelegate:self];
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMCategoryOperation goodCategoryParam]];
}

- (void)reloadDataFromNetwork
{
    [self loadInfo];
}

#pragma mark- 视图

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.tableView.height = self.view.height;
    self.collectionView.height = self.view.height;
}

- (void)setLoading:(BOOL)loading
{
    [super setLoading:loading];
    self.loadingIndicator.height = _height_ - self.statusBarHeight - self.navigationBarHeight - self.tabBarHeight - _SeaMenuBarHeight_;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"分类";
    
    self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    if(self.categoryInfos)
    {
        [self initialization];
    }
    else
    {
         [self loadInfo];
    }
}

//初始化视图
- (void)initialization
{
    ///获取有二级分类的indexPath
    for(NSInteger i = 0;i < self.categoryInfos.count;i ++)
    {
        WMCategoryInfo *info = [self.categoryInfos objectAtIndex:i];
        if(info.categoryInfos.count > 0)
        {
            self.selectedIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
            break;
        }
    }

    self.view.backgroundColor = _SeaViewControllerBackgroundColor_;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WMGoodCategoryFirstCellWidth, self.view.height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = WMGoodCategoryFirstCellHeight;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorColor = _separatorLineColor_;
    self.tableView = tableView;
    [self.view addSubview:self.tableView];

    CGFloat margin = WMGoodSecondaryCategoryCellMargin;
    
    CGSize size = [WMGoodSecondaryCategoryCell sea_itemSize];
    CGFloat width = size.width * 3;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = size;
    layout.minimumInteritemSpacing = WMGoodSecondaryCategoryCellInterval;
    layout.minimumLineSpacing = WMGoodSecondaryCategoryCellInterval;


    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(self.tableView.right + margin, 0, width, self.view.height) collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[WMGoodSecondaryCategoryCell class] forCellWithReuseIdentifier:@"WMGoodSecondaryCategoryCell"];
    
    [collectionView registerClass:[WMGoodCategorySectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WMGoodCategorySectionHeader"];
    [collectionView registerClass:[WMGoodCategorySectionImageHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WMGoodCategorySectionImageHeader"];
    
    [collectionView registerClass:[WMGoodCategorySeparator class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"WMGoodCategorySeparator"];
    [collectionView registerClass:[WMGoodCategorySeparator class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WMGoodCategorySeparator"];
    
    collectionView.alwaysBounceVertical = YES;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.contentInset = UIEdgeInsetsMake(margin, 0, margin, 0);
    self.collectionView = collectionView;
    [self.view addSubview:self.collectionView];
    
    if(self.categoryInfos.count > 0)
    {
        [self.tableView selectRowAtIndexPath:self.selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
    }
    
    [self.tableView setExtraCellLineHidden];
}

#pragma mark- UITableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.categoryInfos.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setSeparatorInset:UIEdgeInsetsZero];

    if([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)viewDidLayoutSubviews
{
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];

    if([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    
    WMGoodCategoryFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil)
    {
        cell = [[WMGoodCategoryFirstCell alloc] initWithReuseIdentifier:cellIdentifier width:tableView.width];
    }
    
    cell.sea_selected = self.selectedIndexPath.row == indexPath.row;
    
    WMCategoryInfo *info = [self.categoryInfos objectAtIndex:indexPath.row];
    cell.info = info;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WMCategoryInfo *info = [self.categoryInfos objectAtIndex:indexPath.row];
    if(self.selectedIndexPath.row != indexPath.row)
    {
        if(info.categoryInfos.count > 0)
        {
            ///刷新次级分类
            WMGoodCategoryFirstCell *cell = (WMGoodCategoryFirstCell*)[tableView cellForRowAtIndexPath:self.selectedIndexPath];
            cell.sea_selected = NO;
            
            self.selectedIndexPath = indexPath;
            [self.collectionView reloadData];
            [self.collectionView setContentOffset:CGPointZero];
            
            cell = (WMGoodCategoryFirstCell*)[tableView cellForRowAtIndexPath:indexPath];
            cell.sea_selected = YES;
        }
        else
        {
            ///该分类没有次级分类，直接打开商品列表
            [self openGoodListWithCategoryInfo:info];
        }
    }
}

#pragma mark- UICollectionView delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if(self.selectedIndexPath.row < self.categoryInfos.count)
    {
        WMCategoryInfo *info = [self.categoryInfos objectAtIndex:self.selectedIndexPath.row];

        ///存在3级分类，按3级分类的样式显示
        if(info.existThreeCategory)
        {
            return info.categoryInfos.count;
        }
        else
        {
            ///按二级分类的样式显示
            return info.categoryInfos.count > 0 ? 1 : 0;
        }
    }

    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    WMCategoryInfo *info = [self.categoryInfos objectAtIndex:self.selectedIndexPath.row];

    ///存在3级分类，按3级分类的样式显示
    if(info.existThreeCategory)
    {
        info = [info.categoryInfos objectAtIndex:section];
    }

    NSInteger count = info.categoryInfos.count;

    ///让item满行
    if(count % 3 == 0)
    {
        return count;
    }
    else
    {
        return count + (3 - count % 3);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    WMCategoryInfo *info = [self.categoryInfos objectAtIndex:self.selectedIndexPath.row];

    if(info.existThreeCategory)
    {
        info = [info.categoryInfos objectAtIndex:section];
        
        if(info.categoryInfos.count > 0)
        {
            return CGSizeMake(collectionView.width, WMGoodCategorySectionHeaderHeight);
        }
        else
        {
            
            return [WMGoodCategorySectionImageHeader sizeForWidth:collectionView.width];
        }
    }
    else
    {
        //return CGSizeMake(collectionView.width, _separatorLineWidth_);
    }
//
//    ///不存在3级分类，没有sectionHeader
    return CGSizeZero;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
//{
//    WMCategoryInfo *info = [self.categoryInfos objectAtIndex:self.selectedIndexPath.row];
//    
//    if(info.existThreeCategory)
//    {
//        info = [info.categoryInfos objectAtIndex:section];
//        
//        ///没有3级分类了
//        if(info.categoryInfos.count == 0)
//        {
//            return CGSizeZero;
//        }
//    }
//    return CGSizeMake(collectionView.width, _separatorLineWidth_);
//}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        WMCategoryInfo *info = [self.categoryInfos objectAtIndex:self.selectedIndexPath.row];
        
        if(info.existThreeCategory)
        {
            info = [info.categoryInfos objectAtIndex:indexPath.section];
            if(info.categoryInfos.count > 0)
            {
                WMGoodCategorySectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"WMGoodCategorySectionHeader" forIndexPath:indexPath];
                header.title_label.text = info.categoryName;
                
                return header;
            }
            else
            {
                WMGoodCategorySectionImageHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"WMGoodCategorySectionImageHeader" forIndexPath:indexPath];
                header.section = indexPath.section;
                header.delegate = self;
                header.info = info;
                
                return header;
            }
        }
        else
        {
            WMGoodCategorySeparator *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"WMGoodCategorySeparator" forIndexPath:indexPath];
            return header;
        }
    }
    else
    {
        WMGoodCategorySeparator *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"WMGoodCategorySeparator" forIndexPath:indexPath];
        return footer;
    }
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WMCategoryInfo *info = [self categoryInfoForIndexPath:indexPath];
    WMGoodSecondaryCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WMGoodSecondaryCategoryCell" forIndexPath:indexPath];
    cell.info = info;
    
    if(indexPath.row % 3 == 0)
    {
        cell.line.hidden = NO;
        cell.position = 0;
    }
    else if ((indexPath.row + 1) % 3 == 0)
    {
        cell.line.hidden = NO;
        cell.position = 1;
    }
    else
    {
        cell.line.hidden = YES;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    WMCategoryInfo *info = [self categoryInfoForIndexPath:indexPath];

    if(info)
    {
        [self openGoodListWithCategoryInfo:info];
    }
}

#pragma mark- WMGoodCategorySectionImageHeader delegate

- (void)goodCategorySectionImageHeaderDidTapImage:(WMGoodCategorySectionImageHeader *)header
{
    [self openGoodListWithCategoryInfo:header.info];
}

#pragma mark- private method

///次级分类信息
- (WMCategoryInfo*)categoryInfoForIndexPath:(NSIndexPath*) indexPath
{
    WMCategoryInfo *info = [self.categoryInfos objectAtIndex:self.selectedIndexPath.row];

    ///存在3级分类
    if(info.existThreeCategory)
    {
        info = [info.categoryInfos objectAtIndex:indexPath.section];
    }

    if(indexPath.row < info.categoryInfos.count)
    {
        return [info.categoryInfos objectAtIndex:indexPath.row];
    }

    return nil;
}

///打开商品列表
- (void)openGoodListWithCategoryInfo:(WMCategoryInfo*) info
{
    WMGoodListViewController *list = [[WMGoodListViewController alloc] initWithCategoryInfo:info];
    list.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:list animated:YES];
}

@end

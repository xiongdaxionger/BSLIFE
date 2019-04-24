//
//  WMSearchController.m
//  StandardShop
//
//  Created by 罗海雄 on 16/6/22.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMSearchController.h"
#import "WMGoodListViewController.h"
#import "SeaCollectionViewFlowLayout.h"
#import "WMHomeOperation.h"
#import "WMGoodSearchHistoryDataBase.h"
#import "WMSearchAssociateViewController.h"

@interface WMTitleView : UIView

@end

@implementation WMTitleView

//- (CGSize)intrinsicContentSize
//{
//    return UILayoutFittingExpandedSize;
//}

@end

@interface WMSearchController ()<UISearchBarDelegate>

///搜索栏所在的视图
@property(nonatomic,weak) UIViewController *viewController;

///搜索视图
@property(nonatomic,strong) WMSearchViewController *searchViewController;

///是否已关闭联想
@property(nonatomic,assign) BOOL alreadyCloseAssociate;

///搜索联想
@property(nonatomic,strong) WMSearchAssociateViewController *associateViewController;

///是否是取消搜索
@property(nonatomic,assign) BOOL isCancelSearch;

@end

@implementation WMSearchController

/**构造方法
 *@param viewController 搜索栏所在的视图
 *@return 一个实例
 */
- (instancetype)initWithViewController:(UIViewController*) viewController
{
    self = [super init];
    if(self)
    {
        self.viewController = viewController;

        //导航栏搜索栏
        
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, _width_, 45.0)];
        
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.text = @"搜索";
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索";

        if(_ios11_0_){
            _searchBar.translatesAutoresizingMaskIntoConstraints = NO;
            NSDictionary *views = NSDictionaryOfVariableBindings(_searchBar);
            [_searchBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_searchBar(44)]" options:0 metrics:nil views:views]];
        }

        [_searchBar setImage:[UIImage new] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
        
        UIImage *image = [UIImage imageNamed:@"search_icon"];
        if(image.renderingMode != UIImageRenderingModeAlwaysTemplate)
        {
            image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        }
        [_searchBar setImage:image forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];

        _searchBar.searchTextPositionAdjustment = UIOffsetMake(5.0, 0);
        _searchBar.sea_searchedTextField.borderStyle = UITextBorderStyleNone;
        _searchBar.sea_searchedTextField.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        _searchBar.sea_searchedTextField.layer.cornerRadius = 3.0;
        _searchBar.sea_searchedTextField.layer.masksToBounds = YES;
        _searchBar.sea_searchedTextField.textColor = [UIColor grayColor];
        _searchBar.tintColor = _searchBar.sea_searchedTextField.textColor;

        self.viewController.navigationItem.titleView = _searchBar;
        _alpha = 1.0;
    }

    return self;
}

#pragma mark- property

- (void)setAlpha:(CGFloat)alpha
{
    if(_alpha != alpha || [_searchBar isFirstResponder])
    {
        _alpha = alpha;
        _searchBar.sea_searchedTextField.backgroundColor = [UIColor colorWithWhite:0.95 alpha:_alpha];
        if(_alpha >= 1.0)
        {
            _searchBar.sea_searchedTextField.textColor = [_searchBar isFirstResponder] ? [UIColor blackColor] : [UIColor grayColor];
        }
        else
        {
            _searchBar.sea_searchedTextField.textColor = [UIColor whiteColor];
        }
        _searchBar.tintColor = [_searchBar isFirstResponder] ? [UIColor grayColor] : _searchBar.sea_searchedTextField.textColor;
    }
}

- (void)setSearchContent:(NSString *)searchContent
{
    if(_searchContent != searchContent)
    {
        _searchContent = searchContent;
        self.searchBar.text = searchContent;
        self.searchBar.sea_searchedTextField.textColor = [UIColor blackColor];
    }
}


#pragma mark- method

///搜索
- (void)search
{
    NSString *searchKey = self.searchBar.text;
    
    [self.searchViewController addHistory:searchKey];
    [self cancelSearch];
    !self.searchHandler ?: self.searchHandler(searchKey);
}

/**
 *  取消搜索
 */
- (void)cancelSearch
{
    self.isCancelSearch = YES;
    if(self.keepSearchContent)
    {
        self.searchContent = self.searchBar.text;
    }
    else
    {
        self.searchContent = nil;
    }
    
    if([_searchBar isFirstResponder])
    {
        [self.searchBar resignFirstResponder];
    }
    else
    {
        [self setContent];
    }

    [self.viewController.navigationItem setRightBarButtonItems:nil animated:YES];
    [self setSearchViewControllerHidden:YES];
    !self.searchDidEndHandler ?: self.searchDidEndHandler();
}

///设置内容
- (void)setContent
{
    if((!self.searchContent || [NSString isEmpty:_searchBar.text]))
    {
        self.searchBar.text = self.searchBar.placeholder;
        self.searchBar.sea_searchedTextField.textColor = [UIColor grayColor];
        self.searchBar.tintColor = _searchBar.sea_searchedTextField.textColor;
    }
}

///关闭联想
- (void)closeAssociate
{
    self.alreadyCloseAssociate = NO;
    [self.associateViewController.view removeFromSuperview];
    [self.associateViewController removeFromParentViewController];
    self.associateViewController = nil;
}

///设置联想控制视图的显示
- (void)setAssociateViewControllerHidden:(BOOL) hidden
{
    if(hidden)
    {
        self.associateViewController.view.hidden = YES;
    }
    else
    {
        if(!self.associateViewController && !self.alreadyCloseAssociate)
        {
            self.associateViewController = [[WMSearchAssociateViewController alloc] init];
            self.associateViewController.searchController = self;
            self.associateViewController.view.frame = CGRectMake(0, 0, _width_, self.viewController.contentHeight);
            [self.associateViewController willMoveToParentViewController:self.viewController];
            [self.searchViewController.view addSubview:self.associateViewController.view];
            [self.searchViewController addChildViewController:self.associateViewController];
        }
        
        self.associateViewController.view.hidden = NO;
    }
}

#pragma mark- UISearchBar delegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    if([[UIDevice currentDevice].systemVersion floatValue] >= 7.0 && [[UIDevice currentDevice].systemVersion floatValue] < 8.0)
    {
        ///在ios7中，searchBarTextDidBeginEditing 修改字体颜色会失败
        searchBar.sea_searchedTextField.textColor = [UIColor blackColor];
    }
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setImage:nil forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];

    if([NSString isEmpty:self.searchContent])
    {
        self.searchBar.text = @"";
    }

    searchBar.sea_searchedTextField.textColor = [UIColor blackColor];
    
    if(!self.searchViewController)
    {
        [self.viewController.navigationItem setLeftBarButtonItems:nil animated:YES];
        id item = [UIViewController barButtonItemWithTitle:@"取消" icon:nil target:self action:@selector(cancelSearch) tintColor:WMTintColor];
        [self.viewController setBarItem:item position:SeaNavigationItemPositionRight];
        
        [self setSearchViewControllerHidden:NO];
        
        if(![NSString isEmpty:self.searchBar.text])
        {
            [self setAssociateViewControllerHidden:NO];
            [self.associateViewController refreshKey:self.searchBar.text];
        }
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self.searchBar setImage:[UIImage new] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];

    if(!self.isCancelSearch)
    {
        self.searchContent = searchBar.text;
    }
    
    [self setContent];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if([NSString isEmpty:searchBar.text])
        return;

    if(self.searchContent)
    {
        self.searchContent = searchBar.text;
    }
    
    
    [self search];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if([NSString isEmpty:searchText])
    {
        [self setAssociateViewControllerHidden:YES];
    }
    else
    {
        [self setAssociateViewControllerHidden:NO];
        
        if(!searchBar.sea_searchedTextField.markedTextRange || searchText.length == 1)
        {
            [self.associateViewController refreshKey:searchText];
        }
    }
}

///设置搜索视图
- (void)setSearchViewControllerHidden:(BOOL) hidden
{
    if(hidden)
    {
        [self.searchViewController.view removeFromSuperview];
        [self.searchViewController removeFromParentViewController];
        self.searchViewController = nil;
        self.associateViewController = nil;
        self.isCancelSearch = NO;
    }
    else
    {
        if(!self.searchViewController)
        {
            !self.searchDidBeginHandler ?: self.searchDidBeginHandler();
            self.searchViewController = [[WMSearchViewController alloc] init];
            self.searchViewController.searchController = self;
            self.searchViewController.view.frame = CGRectMake(0, 0, _width_, self.viewController.contentHeight);
            [self.searchViewController willMoveToParentViewController:self.viewController];
            [self.viewController.view addSubview:self.searchViewController.view];
            [self.viewController addChildViewController:self.searchViewController];
            [self.searchViewController didMoveToParentViewController:self.viewController];
        }
    }
}

@end

///字体
#define WMSearchTextFont [UIFont fontWithName:MainFontName size:14.0]
#define WMSearchTextCellInterval 8.0 ///间隔
#define WMSearchTextCellMargin 15.0 ///边距

@implementation WMSearchTextCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _title_label = [[UILabel alloc] initWithFrame:self.bounds];
        _title_label.font = WMSearchTextFont;
        _title_label.textAlignment = NSTextAlignmentCenter;
        _title_label.textColor = MainGrayColor;
        _title_label.layer.cornerRadius = 2.0;
        _title_label.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:1.0].CGColor;
        _title_label.layer.borderWidth = _separatorLineWidth_;
        [self.contentView addSubview:_title_label];
    }

    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _title_label.frame = self.contentView.bounds;
}

@end

#define WMSearchSectionHeaderSize CGSizeMake(_width_, 35.0)

@implementation WMSearchSectionHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {

        UIImage *image = [UIImage imageNamed:@"search_delete_icon"];
        _delete_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_delete_btn setImage:image forState:UIControlStateNormal];
        [_delete_btn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        [_delete_btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        _delete_btn.frame = CGRectMake(self.width - WMSearchTextCellMargin - image.size.width - 10.0, 0, image.size.width + 10.0, self.height);
        [self addSubview:_delete_btn];

        _title_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _title_btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5.0, 0, 0);
        [_title_btn setTitleColor:MainGrayColor forState:UIControlStateNormal];
        _title_btn.titleLabel.font = [UIFont fontWithName:MainFontName size:12.0];
        [_title_btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        _title_btn.userInteractionEnabled = NO;
        _title_btn.frame = CGRectMake(WMSearchTextCellMargin, 0, _delete_btn.right - WMSearchTextCellMargin, self.height);
        [self addSubview:_title_btn];
    }

    return self;
}

- (void)deleteAction:(UIButton*) btn
{
    if([self.delegate respondsToSelector:@selector(searchSectionHeaderDidDelete:)])
    {
        [self.delegate searchSectionHeaderDidDelete:self];
    }
}

@end

///大小
#define WMSearchSectionFooterSize CGSizeMake(_width_, 40.0)

@implementation WMSearchSectionFooter

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _title_label = [[UILabel alloc] initWithFrame:self.bounds];
        _title_label.font = [UIFont fontWithName:MainFontName size:17.0];
        _title_label.textAlignment = NSTextAlignmentCenter;
        _title_label.textColor = [UIColor blackColor];
        _title_label.text = @"暂无搜索历史";
        [self addSubview:_title_label];
    }

    return self;
}

@end

///热门搜索
#define WMSearchHotKey @"WMSearchHotKey"

@interface WMSearchViewController ()<WMSearchSectionHeaderDelegate, SeaHttpRequestDelegate>

///搜索历史记录，数组元素是 NSString
@property(nonatomic,strong) NSMutableArray *historys;

///热门搜索 数组元素是 NSString
@property(nonatomic,strong) NSMutableArray *hots;

///网络请求
@property(nonatomic,strong) SeaHttpRequest *httpRequest;


@end

@implementation WMSearchViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.collectionView.frame = self.view.bounds;
    self.hasNoMsgView.frame = self.view.bounds;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.httpRequest = [[SeaHttpRequest alloc] initWithDelegate:self];
    
    [self getHots];

    [self getHistorys];
    
    [self loadHots];

    [self initialization];
}

- (void)initialization
{
    SeaCollectionViewFlowLayout *layout = [[SeaCollectionViewFlowLayout alloc] init];
    layout.itemAlignment = SeaCollectionViewItemAlignmentLeft;
    layout.minimumInteritemSpacing = WMSearchTextCellInterval;
    layout.minimumLineSpacing = WMSearchTextCellInterval;
    layout.sectionInset = UIEdgeInsetsMake(0, WMSearchTextCellMargin, 0, WMSearchTextCellMargin);
    self.layout = layout;

    [super initialization];

    [self.collectionView registerClass:[WMSearchTextCell class] forCellWithReuseIdentifier:@"WMSearchTextCell"];
    [self.collectionView registerClass:[WMSearchSectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WMSearchSectionHeader"];
    [self.collectionView registerClass:[WMSearchSectionFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"WMSearchSectionFooter"];
}

///刷新数据
- (void)reloadData
{
    [self.collectionView reloadData];
}

#pragma mark- SeaHttpRequest delegate

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
    
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{
    NSArray *array = [WMHomeOperation hotSearchFromData:data];
    if(array)
    {
        [self.hots removeAllObjects];
        [self.hots addObjectsFromArray:array];
        [self saveHots];
        [self reloadData];
    }
}

///加载热门搜索
- (void)loadHots
{
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMHomeOperation hotSearchParams]];
}

#pragma mark- UICollectionView delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(section == 1)
    {
        return self.historys.count;
    }
    else
    {
        return self.hots.count;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if(section == 1)
    {
        return self.historys.count > 0 ? CGSizeZero : WMSearchSectionFooterSize;
    }

    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if(section == 0 && self.hots.count == 0)
    {
        return CGSizeZero;
    }

    return WMSearchSectionHeaderSize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = indexPath.section == 0 ? [self.hots objectAtIndex:indexPath.row] : [self.historys objectAtIndex:indexPath.row];

    CGFloat maxWidth = _width_ - WMSearchTextCellMargin * 2;
    CGSize size = [title stringSizeWithFont:WMSearchTextFont contraintWith:maxWidth];
    size.height = 25;
    size.width = MIN(size.width + 20.0, maxWidth);

    return size;
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        WMSearchSectionFooter *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"WMSearchSectionFooter" forIndexPath:indexPath];

        return footer;
    }
    else
    {
        WMSearchSectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"WMSearchSectionHeader" forIndexPath:indexPath];
        header.delegate = self;
        [header.title_btn setTitle:indexPath.section == 0 ? @"热门搜索" : @"最近搜索" forState:UIControlStateNormal];
        [header.title_btn setImage:indexPath.section == 0 ? [UIImage imageNamed:@"search_hot_icon"] : [UIImage imageNamed:@"search_recent_icon"] forState:UIControlStateNormal];
        header.delete_btn.hidden = indexPath.section == 0 || self.historys.count == 0;
        
        return header;
    }
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WMSearchTextCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WMSearchTextCell" forIndexPath:indexPath];

    NSString *title = indexPath.section == 0 ? [self.hots objectAtIndex:indexPath.row] : [self.historys objectAtIndex:indexPath.row];
    cell.title_label.text = title;

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];

    NSString *title = indexPath.section == 0 ? [self.hots objectAtIndex:indexPath.row] : [self.historys objectAtIndex:indexPath.row];
    self.searchController.searchBar.text = title;
    [self.searchController search];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchController.searchBar resignFirstResponder];
}


#pragma mark- WMSearchSectionHeader delegate

- (void)searchSectionHeaderDidDelete:(WMSearchSectionHeader *)header
{
    [self clearHistory];
}

#pragma mark- hot

///插入热门搜索
- (void)insertHots
{
    if(self.hots.count > 0)
    {
        [self.collectionView reloadData];
    }
}

#pragma mark- history

///获取搜索记录
- (void)getHistorys
{
    self.historys = [NSMutableArray array];

    NSArray *infos = [WMGoodSearchHistoryDataBase searchHistoryList];
    if(infos)
    {
        [self.historys addObjectsFromArray:infos];
    }
}

///清除搜索记录
- (void)clearHistory
{
    [self.historys removeAllObjects];
    [self reloadData];
    
     [WMGoodSearchHistoryDataBase deleteAllSearchHistory];
}

///添加搜索记录
- (void)addHistory:(NSString*) history
{
    if([NSString isEmpty:history])
        return;
    ///判断是否已存在该历史记录，如果存在，删除
    BOOL exist = NO;
    NSInteger index = NSNotFound;
    for(NSInteger i = 0;i < self.historys.count;i ++)
    {
        NSString *string = [self.historys objectAtIndex:i];
        if([string isEqualToString:history])
        {
            exist = YES;
            index = i;
            break;
        }
    }

    if(index < self.historys.count)
    {
        [self.historys removeObjectAtIndex:index];
    }

    [self.historys insertObject:history atIndex:0];

    [self reloadData];
    
    [WMGoodSearchHistoryDataBase insertSearchHistory:history];
}

///获取热门搜索
- (void)getHots
{
    self.hots = [NSMutableArray array];
    
    NSArray *infos = [[NSUserDefaults standardUserDefaults] arrayForKey:WMSearchHotKey];
    if(infos)
    {
        [self.hots addObjectsFromArray:infos];
    }
}

///保存热门搜索
- (void)saveHots
{
    [[NSUserDefaults standardUserDefaults] setObject:self.hots forKey:WMSearchHotKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end

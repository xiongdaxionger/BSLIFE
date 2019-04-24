//
//  WMGoodFilterViewController.m
//  StandardFenXiao
//
//  Created by mac on 16/1/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#define WMFilterNameCellMargin 8.0
#define WMFilterImageCellMargin 10.0
#define WMFilterNameMaxRowCount 3

#define WMFilterImageMaxRowCount (_width_ == 320 ? 3 : 4)

#import "WMGoodFilterViewController.h"
#import "WMCollectionFilterTypeReusableView.h"
#import "WMFilterCollectionNameViewCell.h"
#import "WMFilterCollectionImageViewCell.h"
#import "WMFilterBottomView.h"
#import "UIView+XQuickStyle.h"
#import "WMGoodFilterModel.h"
#import "WMGoodListOperation.h"
#import "SeaCollectionViewFlowLayout.h"
#import "WMBrandInfo.h"
#import "WMGoodListViewController.h"

@interface WMGoodFilterViewController ()<WMCollectionFilterTypeReusableViewDelegate,SeaHttpRequestDelegate>
/**网络请求
 */
@property (strong,nonatomic) SeaHttpRequest *request;

/**底部视图
 */
@property (strong,nonatomic) WMFilterBottomView *bottomView;
@end

@implementation WMGoodFilterViewController

#pragma mark - 控制器的生命周期
- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self reloadDataFromNetwork];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    !self.confirmButtonClick ? : self.confirmButtonClick();
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

#pragma mark - 初始化
- (void)initialization
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.collectionView.showsVerticalScrollIndicator = NO;
    
    ///放在状态栏下面的视图
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.statusBarHeight)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];

    SeaCollectionViewFlowLayout *layout = [[SeaCollectionViewFlowLayout alloc] init];
    layout.itemAlignment = SeaCollectionViewItemAlignmentLeft;
    self.layout = layout;
    self.layout.headerReferenceSize = CGSizeMake(_width_, WMCollectionFilterTypeReusableViewHeight);
        
    self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    [super initialization];
    
    CGFloat height = 0.0;
    
    if (_hasCategoryMenuBar) {
        
        height = _SeaMenuBarHeight_;
    }
    
    UINib *reusableNib = [UINib nibWithNibName:@"WMCollectionFilterTypeReusableView" bundle:nil];
    
    [self.collectionView registerNib:reusableNib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:WMCollectionFilterTypeReusableViewIden];
    
    UINib *filterNameCell = [UINib nibWithNibName:@"WMFilterCollectionNameViewCell" bundle:nil];
    
    [self.collectionView registerNib:filterNameCell forCellWithReuseIdentifier:WMFilterCollectionNameViewCellIden];
    
    UINib *filterImageCell = [UINib nibWithNibName:@"WMFilterCollectionImageViewCell" bundle:nil];
    
    [self.collectionView registerNib:filterImageCell forCellWithReuseIdentifier:WMFilterCollectionImageViewCellIden];

    self.collectionView.frame = CGRectMake(0, view.bottom, self.view.width, _height_ - 49.0 - view.bottom);

    self.collectionView.showsVerticalScrollIndicator = NO;

    self.collectionView.alwaysBounceVertical = NO;

    self.collectionView.backgroundColor = [UIColor clearColor];

    self.collectionView.allowsMultipleSelection = YES;

    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, WMFilterImageCellMargin, 0);
    
    [self configureUI];
}

#pragma mark - 配置UI

- (void)configureUI
{
    WeakSelf(self);
    
    self.bottomView = [[WMFilterBottomView alloc] initWithGoodCount:self.filterGoodCount];
    
    self.bottomView.frame = CGRectMake(0, self.collectionView.bottom, self.view.width, 49.0);
    
    [self.bottomView setResetButtonClick:^(UIButton *button) {
        
        [weakSelf resetButtonClick];
    }];
    
    [self.bottomView setCommitButtonClick:^(UIButton *button) {
        
        [weakSelf commitButtonClick:button];
        
    }];
    
    [self.view addSubview:self.bottomView];
    
    [self.bottomView changeFilterGoodCountWith:self.filterGoodCount];
    
}

///点击确定按钮
- (void)commitButtonClick:(UIButton *)button{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSDictionary*)filters
{
    NSDictionary *dic = [WMGoodListOperation returnGoodSelectFilterTypeStr:self.filterModelArr];
    return dic;
}

#pragma mark - 网络协议

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
    [self failToLoadData];
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{
    self.loading = NO;
    
    NSArray *filterArr = [WMGoodListOperation returnGoodFilterTypeArrWithData:data];
    
    if (filterArr) {
        
        ///选中品牌筛选
        if(self.goodListViewController.brandInfo && filterArr.count > 0)
        {
            NSMutableArray *array = [NSMutableArray arrayWithArray:filterArr];
            for(NSInteger i = 0;i < array.count;i ++)
            {
                WMGoodFilterModel *model = [array objectAtIndex:i];
                if([model.filterField isEqualToString:@"brand_id"])
                {
                    for(NSInteger j = 0;j < model.filterTypeArr.count;j ++)
                    {
                        WMGoodFilterOptionModel *option = [model.filterTypeArr objectAtIndex:j];
                        if([option.filterOptionID isEqualToString:self.goodListViewController.brandInfo.Id])
                        {
                            option.isSelect = YES;
                            model.singleSelectPath = [NSIndexPath indexPathForItem:j inSection:i];
                            self.goodListViewController.brandInfo.Id = nil;
                            break;
                        }
                    }
                    break;
                }
            }
            
            filterArr = array;
        }
        
        ///选中促销标签筛选
        if(self.goodListViewController.promotionTagId && filterArr.count > 0)
        {
            NSMutableArray *array = [NSMutableArray arrayWithArray:filterArr];
            for(NSInteger i = 0;i < array.count;i ++)
            {
                WMGoodFilterModel *model = [array objectAtIndex:i];
                if([model.filterField isEqualToString:@"pTag"])
                {
                    for(NSInteger j = 0;j < model.filterTypeArr.count;j ++)
                    {
                        WMGoodFilterOptionModel *option = [model.filterTypeArr objectAtIndex:j];
                        if([option.filterOptionID isEqualToString:self.goodListViewController.promotionTagId])
                        {
                            option.isSelect = YES;
                            model.singleSelectPath = [NSIndexPath indexPathForItem:j inSection:i];
                            self.goodListViewController.promotionTagId = nil;
                            break;
                        }
                    }
                    break;
                }
            }
            
            filterArr = array;
        }
        
        self.filterModelArr = filterArr;
        
        if (self.httpFinishCallBack) {
            
            self.httpFinishCallBack(self.filterModelArr);
        }
        
        ///计算按钮宽度
        CGFloat maxWidth = self.view.width - (WMFilterNameMaxRowCount + 1.0) * WMFilterNameCellMargin;
        CGFloat minWidth = 60.0;
        
        CGFloat width = 0;
        for(WMGoodFilterModel *model in self.filterModelArr)
        {
            width = 0;
            if(!model.isLogo)
            {
                for(WMGoodFilterOptionModel *option in model.filterTypeArr)
                {
                    CGSize size = [option.filterOptionName stringSizeWithFont:WMFilterCollectionNameViewCellFont contraintWith:maxWidth];
                    size.width = MIN(maxWidth, size.width + 10.0);
                    if(size.width < minWidth)
                        size.width = minWidth;
                    size.height = WMFilterCollectionNameViewCellHeight;
                    option.size = size;
                    
                    width += size.width;
                    if(width <= maxWidth)
                    {
                        model.maxCountWhenNotExpand ++;
                    }
                }
            }
        }
        
        if (!self.collectionView) {
            
            [self initialization];
        }
        else
        {
            [self.collectionView reloadData];
        }
    }
    else{
        
        [self failToLoadData];
    }
}

- (void)reloadDataFromNetwork{
    
    self.loading = YES;
    if(!self.request)
    {
        self.request = [[SeaHttpRequest alloc] initWithDelegate:self];
    }
    
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMGoodListOperation returnGoodCateFilterParamWithCateID:self.goodCateID]];
}

#pragma mark - 集合视图协议
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return _filterModelArr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    WMGoodFilterModel *model = [_filterModelArr objectAtIndex:section];
    
    if (model.isDrop)
    {
        return model.filterTypeArr.count;
    }
    else
    {
        if(model.isLogo)
        {
            return MIN(WMFilterImageMaxRowCount, model.filterTypeArr.count);
        }
        else
        {
            return model.maxCountWhenNotExpand;
        }
    }
    
    return model.filterTypeArr.count;
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
        
    WMGoodFilterModel *model = [_filterModelArr objectAtIndex:indexPath.section];

    WMCollectionFilterTypeReusableView *filterTypeView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:WMCollectionFilterTypeReusableViewIden forIndexPath:indexPath];

    if(model.isLogo)
    {
        filterTypeView.filterButton.hidden = model.filterTypeArr.count <= WMFilterImageMaxRowCount;
    }
    else
    {
        filterTypeView.filterButton.hidden = model.maxCountWhenNotExpand == model.filterTypeArr.count;
    }

    [filterTypeView configureFilterType:model];

    filterTypeView.section = indexPath.section;

    filterTypeView.delegate = self;

    //        if (!self.goodCateID) {
    //
    //            if (model.isLogo) {
    //
    //                filterTypeView.filterButton.hidden = !(model.filterTypeArr.count > WMFilterImageMaxRowCount);
    //            }
    //            else{
    //
    //                filterTypeView.filterButton.hidden = !(model.filterTypeArr.count > WMFilterNameMaxRowCount);
    //            }
    //        }

    //        if (self.goodCateID) {
    //
    //            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width_, _separatorLineWidth_)];
    //
    //            lineView.backgroundColor = _separatorLineColor_;
    //
    //            [filterTypeView addSubview:lineView];
    //        }

    return filterTypeView;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    WMGoodFilterModel *typeModel = [self.filterModelArr objectAtIndex:section];
    
    CGFloat bottomMargin;
    
    if (typeModel.isDrop)
    {
        bottomMargin = 0;
    }
    else
    {
        bottomMargin = 0;
    }
    
    return typeModel.isLogo ? UIEdgeInsetsMake(WMFilterImageCellMargin, WMFilterImageCellMargin, bottomMargin, WMFilterImageCellMargin) : UIEdgeInsetsMake(WMFilterNameCellMargin, WMFilterNameCellMargin, bottomMargin, WMFilterNameCellMargin);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    WMGoodFilterModel *typeModel = [self.filterModelArr objectAtIndex:section];

    return typeModel.isLogo ? WMFilterImageCellMargin : WMFilterNameCellMargin;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    WMGoodFilterModel *typeModel = [self.filterModelArr objectAtIndex:section];

    return typeModel.isLogo ? WMFilterImageCellMargin : WMFilterNameCellMargin;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WMGoodFilterModel *typeModel = [self.filterModelArr objectAtIndex:indexPath.section];
    
    WMGoodFilterOptionModel *optionModel = [typeModel.filterTypeArr objectAtIndex:indexPath.row];
    
    if (optionModel.filterLogo) {
        
        WMFilterCollectionImageViewCell *imageCell = [collectionView dequeueReusableCellWithReuseIdentifier:WMFilterCollectionImageViewCellIden forIndexPath:indexPath];
        
        [imageCell configureWithImageURL:optionModel.filterLogo];
        
        imageCell.selectStatus = optionModel.isSelect;
        
        return imageCell;
    }
    else{
        
        WMFilterCollectionNameViewCell *nameCell = [collectionView dequeueReusableCellWithReuseIdentifier:WMFilterCollectionNameViewCellIden forIndexPath:indexPath];
        
        nameCell.backgroundColor = _SeaViewControllerBackgroundColor_;
        
        [nameCell configureWithFilterName:optionModel.filterOptionName];
        
        nameCell.selectStatus = optionModel.isSelect;
        
        return nameCell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    WMGoodFilterModel *typeModel = [self.filterModelArr objectAtIndex:indexPath.section];
    
    [self changeSelectStatusWithIndexPath:indexPath collectionView:collectionView isDeselect:NO];
    
    if (typeModel.isSingle) {
        
        if (typeModel.singleSelectPath) {
            
            if (![typeModel.singleSelectPath isEqual:indexPath]) {
                
                [self changeSelectStatusWithIndexPath:typeModel.singleSelectPath collectionView:collectionView isDeselect:YES];
            }
            
            typeModel.singleSelectPath = nil;
        }
        
        typeModel.singleSelectPath = indexPath;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WMGoodFilterModel *typeModel = [self.filterModelArr objectAtIndex:indexPath.section];
    
    CGSize itemSize;
    if(typeModel.isLogo)
    {
        itemSize = CGSizeMake((_width_ - (WMFilterImageMaxRowCount + 1.0) * WMFilterImageCellMargin) / WMFilterImageMaxRowCount, (_width_ - (WMFilterImageMaxRowCount + 1.0) * WMFilterImageCellMargin) / WMFilterImageMaxRowCount);
    }
    else
    {
        WMGoodFilterOptionModel *option = [typeModel.filterTypeArr objectAtIndex:indexPath.item];

        return option.size;
    }
    
    return itemSize;
}

#pragma mark - 点击的协议
- (void)collectionFilterTypeReusableViewButtonClick:(WMCollectionFilterTypeReusableView *)view
{
    
    WMGoodFilterModel *filterModel = [self.filterModelArr objectAtIndex:view.section];
    
    NSInteger startNum;
    
    if (filterModel.isLogo) {
        
        startNum = MIN(WMFilterImageMaxRowCount, filterModel.filterTypeArr.count);
    }
    else{
        
        startNum = filterModel.maxCountWhenNotExpand;
    }
    
    NSMutableArray *indexPathArr = [NSMutableArray arrayWithCapacity:filterModel.filterTypeArr.count - startNum];
    
    for (NSInteger i = startNum;i < filterModel.filterTypeArr.count;i ++) {
        
        [indexPathArr addObject:[NSIndexPath indexPathForItem:i inSection:view.section]];
    }
    if (filterModel.isDrop) {
        
        [self.collectionView insertItemsAtIndexPaths:indexPathArr];
    }
    else{
        
        [self.collectionView deleteItemsAtIndexPaths:indexPathArr];
    }
}

- (void)changeSelectStatusWithIndexPath:(NSIndexPath *)indexPath collectionView:(UICollectionView *)collectionView isDeselect:(BOOL)isDeselect{
    
    WMGoodFilterModel *typeModel = [self.filterModelArr objectAtIndex:indexPath.section];
    
    WMGoodFilterOptionModel *optionModel = [typeModel.filterTypeArr objectAtIndex:indexPath.row];
    
    if (isDeselect) {
        
        optionModel.isSelect = NO;
    }
    else{
        
        optionModel.isSelect = !optionModel.isSelect;
    }
    
    if (optionModel.filterLogo) {
        
        WMFilterCollectionImageViewCell *imageCell = (WMFilterCollectionImageViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        imageCell.selectStatus = optionModel.isSelect;
    }
    else{
        
        WMFilterCollectionNameViewCell *nameCell = (WMFilterCollectionNameViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        nameCell.selectStatus = optionModel.isSelect;
    }
}
#pragma mark - 重置事件
- (void)resetButtonClick{
    
    for (NSInteger i = 0; i < self.filterModelArr.count; i++) {
        
        WMGoodFilterModel *model = [self.filterModelArr objectAtIndex:i];
        
        for (NSInteger j = 0; j < model.filterTypeArr.count; j++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            
            WMGoodFilterOptionModel *optionModel = [model.filterTypeArr objectAtIndex:j];
            
            if (optionModel.isSelect) {
                
                optionModel.isSelect = NO;
                
                [self changeSelectStatusWithIndexPath:indexPath collectionView:self.collectionView isDeselect:YES];
            }
        }
        
        model.singleSelectPath = nil;
    }
}

- (void)setLoading:(BOOL)loading
{
    [super setLoading:loading];
    self.loadingIndicator.height = _height_;
}

- (void)setFilterGoodCount:(NSInteger)filterGoodCount
{
    if(_filterGoodCount != filterGoodCount)
    {
        _filterGoodCount = filterGoodCount;
        [self.bottomView changeFilterGoodCountWith:filterGoodCount];
    }
}


@end

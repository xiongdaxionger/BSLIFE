//
//  WMCustomerServiceViewController.m
//  StandardShop
//
//  Created by Hank on 16/9/13.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMCustomerServiceViewController.h"
#import "WMFeedBackPageController.h"
#import "WMCustomerServiceInfo.h"
#import "WMShareOperation.h"
#import "WMCustomerServiceOperation.h"
#import "WMActivityListCell.h"
#import "WMCustomerServicePhoneInfo.h"

@interface WMCustomerServiceViewController ()<SeaHttpRequestDelegate>

/**数组元素是 WMCustomerServiceInfo
 */
@property (nonatomic,strong) NSArray *infos;

/**网路请求
 */
@property (nonatomic,strong) SeaHttpRequest *request;

@end

@implementation WMCustomerServiceViewController

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.hidesBottomBarWhenPushed = YES;
        self.infos = [WMCustomerServiceInfo returnCustomerServiceInfosArr];
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.backItem = YES;
    
    self.title = @"客户服务";
    
    self.request = [[SeaHttpRequest alloc] initWithDelegate:self];
    
    if([NSString isEmpty:[WMCustomerServicePhoneInfo shareInstance].servicePhoneNumber])
    {
        [self reloadDataFromNetwork];
    }
    else
    {
        [self initialization];
    }
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (void)initialization
{
    self.layout.minimumLineSpacing = WMActivityListCellMargin;
    
    self.layout.minimumInteritemSpacing = WMActivityListCellMargin;
    
    self.layout.itemSize = WMActivityListCellSize;
    
    self.layout.headerReferenceSize = CGSizeMake(_width_, _separatorLineWidth_);
    
    [super initialization];
    
    NSInteger rowCount = 0;
    
    if (self.infos.count % 3 == 0) {
        
        rowCount = self.infos.count / 3;
    }
    else{
        
        rowCount = self.infos.count /3 + 1;
    }
    
    self.collectionView.scrollEnabled = NO;
    
    self.collectionView.frame = CGRectMake(0, 0, _width_, self.layout.itemSize.height * rowCount + 10.0);
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"WMActivityListCell" bundle:nil] forCellWithReuseIdentifier:@"WMActivityListCell"];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView"];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self configureExplainInfo];
}

#pragma mark - 网络请求
- (void)reloadDataFromNetwork
{
    self.loading = YES;
    
    self.request.identifier = WMCustomerServiceInfoIdentifier;
    
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMCustomerServiceOperation returnCustomServiceParam]];
}

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error{
    
    self.loading = NO;
    
    [self failToLoadData];
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data{
    
    self.loading = NO;
    
    if([request.identifier isEqualToString:WMCustomerServiceInfoIdentifier])
    {
        NSDictionary *customerServiceDict = [WMCustomerServiceOperation returnCustomServiceResultWithData:data];
        
        if(customerServiceDict)
        {
            [self initialization];
        }
        else
        {
            [self failToLoadData];
        }
    }
}

#pragma mark- UICollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = self.infos.count;
    
    return count + (count % WMActivityListCellCountPerRow == 0 ? 0 : (WMActivityListCellCountPerRow - count % WMActivityListCellCountPerRow));
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
    
    header.backgroundColor = _separatorLineColor_;
    
    return header;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WMActivityListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WMActivityListCell" forIndexPath:indexPath];
    
    cell.customerInfo = [self.infos objectAtNotBeyondIndex:indexPath.item];
    
    cell.index = indexPath.item;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    WMCustomerServiceInfo *info = [self.infos objectAtNotBeyondIndex:indexPath.item];
    
    if(!info)
        return;
    
    switch (info.type)
    {
        case WMCustomerServiceTypePhone :
        {
            makePhoneCall([WMCustomerServicePhoneInfo shareInstance].servicePhoneNumber, YES);
        }
            break;
        case WMCustomerServiceTypeFeedBack :
        {
            if ([AppDelegate instance].isLogin) {
                
                [self.navigationController pushViewController:[WMFeedBackPageController new] animated:YES];
            }
            else{
                
                WeakSelf(self);
                
                [[AppDelegate instance] showLoginViewControllerWithAnimate:YES completion:nil loginCompletion:^(void){
                    
                    [weakSelf.navigationController pushViewController:[WMFeedBackPageController new] animated:YES];
                }];
            }
        }
            break;
        case WMCustomerServiceTypeOnLine :
        {
            NSString *type = [WMCustomerServicePhoneInfo shareInstance].type;
            
            if ([type isEqualToString:@"weixin"]) {
                
                [WMShareOperation openWeinxinWithUserName:[WMCustomerServicePhoneInfo shareInstance].contact];
            }
            else if ([type isEqualToString:@"qq"]){
                
                [WMShareOperation openQQWithQQ:[WMCustomerServicePhoneInfo shareInstance].contact];
            }
            else{
                
                SeaWebViewController *web = [[SeaWebViewController alloc] initWithURL:[WMCustomerServicePhoneInfo shareInstance].contact];
                
                web.backItem = YES;
                
                web.title = @"在线客服";
                
                [self.navigationController pushViewController:web animated:YES];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - 配置扩展信息
- (void)configureExplainInfo{
    
    CGFloat margin = 24.0;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin / 2.0, self.collectionView.bottom + margin, _width_ - 2 * margin, 21.0)];
    
    titleLabel.textColor = [UIColor blackColor];
    
    titleLabel.text = @"服务说明:";
    
    titleLabel.font = [UIFont fontWithName:MainFontName size:14.0];

    [self.view addSubview:titleLabel];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[WMCustomerServicePhoneInfo shareInstance].intro];
    
    NSMutableParagraphStyle *paragarphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragarphStyle setLineSpacing:8];
    
    [attrString addAttributes:@{NSParagraphStyleAttributeName:paragarphStyle,NSForegroundColorAttributeName:WMMarketPriceColor,NSFontAttributeName:[UIFont fontWithName:MainFontName size:14.0]} range:NSMakeRange(0, attrString.string.length)];
    
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin / 2.0, titleLabel.bottom + margin / 3.0, _width_ - margin, [attrString boundsWithConstraintWidth:_width_ - margin].height)];
    
    infoLabel.attributedText = attrString;
    
    infoLabel.numberOfLines = 0;
    
    [self.view addSubview:infoLabel];
}



@end

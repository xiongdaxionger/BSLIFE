//
//  WMGoodDetailAdviceViewController.m
//  StandardShop
//
//  Created by mac on 16/6/2.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodDetailAdviceViewController.h"
#import "WMCommitAdviceViewController.h"
#import "WMAdviceAnswerViewController.h"

#import "WMAdviceHeaderViewCell.h"
#import "WMAdviceContentViewCell.h"
#import "WMMoreAdviceViewCell.h"
#import "WMAdviceReplyViewCell.h"
#import "XTableCellConfigEx.h"

#import "WMAdviceQuestionInfo.h"
#import "WMAdviceContentInfo.h"
#import "WMAdviceSettingInfo.h"
#import "WMAdviceTypeInfo.h"
#import "WMAdviceOperation.h"

@interface WMGoodDetailAdviceViewController ()<SeaHttpRequestDelegate,SeaMenuBarDelegate>
/**网络请求
 */
@property (strong,nonatomic) SeaHttpRequest *request;
/**咨询的设置信息
 */
@property (strong,nonatomic) WMAdviceSettingInfo *settingInfo;
@end

@implementation WMGoodDetailAdviceViewController

#pragma mark - 初始化
- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        
        self.title = @"购买咨询";
        
        self.backItem = YES;
        
        self.request = [[SeaHttpRequest alloc] initWithDelegate:self];
        
        self.adviceInfoArr  = [[NSMutableArray alloc] init];
        
        self.pageNum = 1;
        
        self.selectIndex = 0;
        
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

#pragma mark - 配置表格视图
- (void)initialization{
    
    self.style = UITableViewStyleGrouped;
    
    [super initialization];
    
    [self configureCellConfig];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView setBackgroundColor:_SeaViewControllerBackgroundColor_];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.enableDropDown = YES;
    
    self.enablePullUp = YES;
    
    self.tableView.sea_shouldShowEmptyView = YES;
    
    self.tableView.frame = CGRectMake(0, _SeaMenuBarHeight_, _width_, self.contentHeight - _SeaMenuBarHeight_);
}

#pragma mark - 控制器生命周期
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.loading = YES;
    
    [self getAdviceFirstPageContent];
}

#pragma mark- SeaEmptyView delegate

- (void)emptyViewWillAppear:(SeaEmptyView *)view
{
    if(self.adviceTypeInfoArr.count > 0)
    {
        WMAdviceTypeInfo *typeInfo = [self.adviceTypeInfoArr objectAtIndex:self.selectIndex];
        view.textLabel.text = [NSString stringWithFormat:@"暂无%@内容",typeInfo.adviceTypeName];
    }
    else
    {
        view.textLabel.text = @"暂无商品咨询";
    }
}

#pragma mark - 配置单元格

- (void)configureCellConfig{
    
    XTableCellConfigEx *adviceHeaderConfig = [XTableCellConfigEx cellConfigWithClassName:[WMAdviceHeaderViewCell class] heightOfCell:WMAdviceHeaderViewCellHeight tableView:self.tableView isNib:YES];
    
    XTableCellConfigEx *adviceContentConfig = [XTableCellConfigEx cellConfigWithClassName:[WMAdviceContentViewCell class] heightOfCell:WMAdviceContentViewCellHeight tableView:self.tableView isNib:YES];
    
    XTableCellConfigEx *adviceMoreConfig = [XTableCellConfigEx cellConfigWithClassName:[WMMoreAdviceViewCell class] heightOfCell:WMMoreAdviceViewCellHeight tableView:self.tableView isNib:YES];
    
    XTableCellConfigEx *replyConfig = [XTableCellConfigEx cellConfigWithClassName:[WMAdviceReplyViewCell class] heightOfCell:CGFLOAT_MIN tableView:self.tableView isNib:YES];
    
    _configureArr = @[adviceHeaderConfig,adviceContentConfig,replyConfig,adviceMoreConfig];
}

#pragma mark - 网络请求
- (void)beginDropDownRefresh{
    
    self.pageNum = 1;
    
    self.refreshing = YES;
    
    [self getAdvicepageContent];
}

- (void)beginPullUpLoading{
    
    self.pageNum += 1;
    
    [self getAdvicepageContent];
}

- (void)getAdviceFirstPageContent{
    
    self.request.identifier = WMGetAdviceContentIdentifier;
    
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMAdviceOperation returnAdviceListFirstPageParamWithGoodID:self.goodID]];
}

- (void)getAdvicepageContent{
    
    WMAdviceTypeInfo *selectTypeInfo = [self.adviceTypeInfoArr objectAtIndex:self.selectIndex];
    
    self.request.identifier = WMGetAdviceContentPageIdentifier;
    
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMAdviceOperation returnAdviceListPageParamWithGoodID:self.goodID page:self.pageNum typeID:selectTypeInfo.adviceTypeID]];
}

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error{
    
    self.requesting = NO;
    
    self.showNetworkActivity = NO;
    
    self.loading = NO;
    
    if ([request.identifier isEqualToString:WMGetAdviceContentIdentifier]) {
        
        [self failToLoadData];
    }
    else if ([request.identifier isEqualToString:WMGetAdviceContentPageIdentifier]){
        
        [self failToLoadData];
    }
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data{
    
    self.requesting = NO;
    
    self.showNetworkActivity = NO;
    
    self.loading = NO;
    
    if ([request.identifier isEqualToString:WMGetAdviceContentIdentifier]) {
        
        NSDictionary *contentDict = [WMAdviceOperation returnAdviceListResultWithData:data];
        
        if (contentDict) {

            self.settingInfo = [contentDict objectForKey:@"setting"];
            
            self.adviceTypeInfoArr = [contentDict arrayForKey:@"type"];
            
            [self setBarItemsWithTitle:nil icon:[UIImage imageNamed:@"commit_advice"] action:@selector(commitAdvice) position:SeaNavigationItemPositionRight];
            
            if (!self.tableView) {
                
                [self configureSeaMenuBar];
                
                [self initialization];
            }
            
            [self dataActionWithContentDict:contentDict];
        }
        else{
            
            [self failToLoadData];
        }
    }
    else if ([request.identifier isEqualToString:WMGetAdviceContentPageIdentifier]){
        
        NSDictionary *contentDict = [WMAdviceOperation returnAdviceListPageResultWithData:data];
        
        if (contentDict) {
            
            if (self.refreshing) {
                
                [self.adviceInfoArr removeAllObjects];
                
                self.refreshing = NO;
            }
            
            [self endDropDownRefreshWithMsg:nil];
            
            [self dataActionWithContentDict:contentDict];
        }
        else{
            
            if (self.loadMore) {
                
                self.pageNum -= 1;
            }
        }
    }
}

- (void)dataActionWithContentDict:(NSDictionary *)contentDict{
    
    [self.adviceInfoArr addObjectsFromArray:[contentDict arrayForKey:@"list"]];
    
    [self.tableView reloadData];
    
    [self endPullUpLoadingWithMoreInfo:self.adviceInfoArr.count < [[contentDict numberForKey:@"total"] integerValue]];
}

- (void)reloadDataFromNetwork{
    
    if (self.refreshing) {
        
        [self getPageContentRequestFail];
    }
    else{
        
        [self getAdviceFirstPageContent];
    }
}

- (void)getPageContentRequestFail{
    
    self.pageNum = 1;
    
    self.refreshing = YES;
    
    self.requesting = YES;
        
    [self getAdvicepageContent];
}

#pragma mark - 配置菜单栏
- (void)configureSeaMenuBar{
    
    NSArray *titlesArr = [WMAdviceOperation returnMenuBarTitleArrWithAdviceTypeInfoArr:self.adviceTypeInfoArr];
    
    SeaMenuBar *menu = [[SeaMenuBar alloc] initWithFrame:CGRectMake(0, 0, _width_, _SeaMenuBarHeight_) titles:titlesArr style:titlesArr.count > 3 ? SeaMenuBarStyleItemWithRelateTitle : SeaMenuBarStyleItemWithRelateTitleInFullScreen];
    
    menu.delegate = self;
    
    menu.topSeparatorLine.hidden = YES;
    
    menu.callDelegateWhenSetSelectedIndex = NO;
    
    self.adviceListMenuBar = menu;
    
    [self.view addSubview:self.adviceListMenuBar];
}

#pragma mark - SeaMenuBar协议
- (void)menuBar:(SeaMenuBar *)menu didSelectItemAtIndex:(NSInteger)index{
    
    self.selectIndex = index;
    
    self.pageNum = 1;
    
    self.requesting = YES;
    
    self.showNetworkActivity = YES;
    
    self.refreshing = YES;
    
    [self getAdvicepageContent];
}

#pragma mark - UITableView协议
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _adviceInfoArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    WMAdviceQuestionInfo *questionInfo = [_adviceInfoArr objectAtIndex:section];
    
    if (questionInfo.adviceAnswerInfoArr.count > WMShowMoreInfoMaxCount) {
        
        if (questionInfo.isShowMoreOpen) {
            
            return questionInfo.adviceAnswerInfoArr.count + 3;
        }
        else{
            
            return WMShowMoreInfoMaxCount + 3;
        }
    }
    else{
        
        return questionInfo.adviceAnswerInfoArr.count + 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XTableCellConfigEx *config = [self findConfigWithIndexPath:indexPath];
    
    id model = [self findModelWithIndexPath:indexPath];
    
    id<XTableCellConfigExDelegate> cell = [config cellOfCellConfigWithTableView:tableView indexPath:indexPath];
    
    if ([cell isKindOfClass:[WMMoreAdviceViewCell class]]) {
        
        WMMoreAdviceViewCell *moreCell = (WMMoreAdviceViewCell *)cell;
        
        WeakSelf(self);
        
        [moreCell setCallBack:^(UITableViewCell *callBackCell) {
            
            NSIndexPath *selectIndexPath = [weakSelf.tableView indexPathForCell:callBackCell];
            
            WMAdviceQuestionInfo *info = [weakSelf.adviceInfoArr objectAtIndex:selectIndexPath.section];
            
            info.isShowMoreOpen = !info.isShowMoreOpen;
            
            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:selectIndexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
        
        [moreCell configureCellWithModel:model];
        
        return moreCell;
    }
    
    [cell configureCellWithModel:model];
    
    return (UITableViewCell *)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WMAdviceQuestionInfo *questionInfo = [_adviceInfoArr objectAtIndex:indexPath.section];
    
    if (!indexPath.row) {
        
        return WMAdviceHeaderViewCellHeight;
    }
    
    NSInteger maxCount = 0;
    
    if (questionInfo.adviceAnswerInfoArr.count > WMShowMoreInfoMaxCount) {
        
        if (questionInfo.isShowMoreOpen) {
            
            maxCount = questionInfo.adviceAnswerInfoArr.count;
        }
        else{
            
            maxCount = WMShowMoreInfoMaxCount;
        }
    }
    else{
        
        maxCount = questionInfo.adviceAnswerInfoArr.count;
    }
    
    if (indexPath.row == 1) {
        
        return [questionInfo returnContentHeightCanReply:self.settingInfo.canReplyAdvice];
    }
    else if(indexPath.row > 1 && indexPath.row <= maxCount + 1){
        
        WMAdviceContentInfo *answerInfo = [questionInfo.adviceAnswerInfoArr objectAtIndex:indexPath.row - 2];
        
        return [answerInfo returnContentHeight];
    }
    else{
        
        return WMMoreAdviceViewCellHeight;;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WMAdviceQuestionInfo *questionInfo = [_adviceInfoArr objectAtIndex:indexPath.section];

    if (indexPath.row == 1) {
        
        if (self.settingInfo.canReplyAdvice) {
            
            WMAdviceAnswerViewController *answer = [[WMAdviceAnswerViewController alloc] init];
            
            answer.settingInfo = self.settingInfo;
            
            answer.questionInfo = questionInfo;
            
            WeakSelf(self);
            
            [answer setCommitReplySuccess:^(WMAdviceContentInfo *newAnswerInfo) {
                
                [questionInfo.adviceAnswerInfoArr insertObject:newAnswerInfo atIndex:0];
                
                [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            }];
            
            [self.navigationController pushViewController:answer animated:YES];
        }
        
        return;
    }
}

#pragma mark - 返回配置累类和模型
- (XTableCellConfigEx *)findConfigWithIndexPath:(NSIndexPath *)indexPath{
    
    WMAdviceQuestionInfo *questionInfo = [_adviceInfoArr objectAtIndex:indexPath.section];
    
    if (!indexPath.row) {
        
        return [_configureArr firstObject];
    }
    else{
        //    _configureArr = @[adviceHeaderConfig,adviceContentConfig,replyConfig,adviceMoreConfig];

        if (questionInfo.adviceAnswerInfoArr.count > WMShowMoreInfoMaxCount) {
            
            if (questionInfo.isShowMoreOpen) {
                
                if (indexPath.row == 1) {
                    
                    return [_configureArr objectAtIndex:1];
                }
                else if (indexPath.row > 1 && indexPath.row <= questionInfo.adviceAnswerInfoArr.count + 1) {
                    
                    return [_configureArr objectAtIndex:2];
                }
                else{
                    
                    return [_configureArr lastObject];
                }
            }
            else{
                
                if (indexPath.row == 1) {
                    
                    return [_configureArr objectAtIndex:1];
                }
                else if (indexPath.row > 1 && indexPath.row <= WMShowMoreInfoMaxCount + 1) {
                    
                    return [_configureArr objectAtIndex:2];
                }
                else{
                    
                    return [_configureArr lastObject];
                }
            }
        }
        else{
            
            if (indexPath.row == 1) {
                
                return [_configureArr objectAtIndex:1];
            }
            else{
                
                return [_configureArr objectAtIndex:2];
            }
        }
    }
}

- (id)findModelWithIndexPath:(NSIndexPath *)indexPath{
    
    WMAdviceQuestionInfo *questionInfo = [_adviceInfoArr objectAtIndex:indexPath.section];
    
    if (!indexPath.row) {
        
        return questionInfo;
    }
    else{
        
        NSInteger maxCount = 0;
        
        if (questionInfo.adviceAnswerInfoArr.count > WMShowMoreInfoMaxCount) {
            
            if (questionInfo.isShowMoreOpen) {
                
                maxCount = questionInfo.adviceAnswerInfoArr.count;
            }
            else{
                
                maxCount = WMShowMoreInfoMaxCount;
            }
        }
        else{
            
            maxCount = questionInfo.adviceAnswerInfoArr.count;
        }
        
        if (indexPath.row == 1) {
            
            return @{@"setting":self.settingInfo,@"content":questionInfo};
        }
        else if(indexPath.row > 1 && indexPath.row <= maxCount + 1){
            
            return [questionInfo.adviceAnswerInfoArr objectAtIndex:indexPath.row - 2];
        }
        else{
            
            return questionInfo;
        }
    }
}

#pragma mark - 发布咨询
- (void)commitAdvice{
    
    NSMutableArray *infoArr = [NSMutableArray new];
    
    for (WMAdviceTypeInfo *info in _adviceTypeInfoArr) {
        
        if (![info.adviceTypeID isEqualToString:WMAdviceAllTypeID]) {
            
            [infoArr addObject:info];
        }
    }
    
    for (NSInteger i = 0; i < infoArr.count; i++) {
        
        WMAdviceTypeInfo *info = [infoArr objectAtIndex:i];
        
        if (!i) {
            
            info.adviceTypeIsSelect = YES;
        }
        else{
            
            info.adviceTypeIsSelect = NO;
        }
    }
    
    WMAdviceTypeInfo *selectTypeInfo = [_adviceTypeInfoArr objectAtIndex:self.selectIndex];
    
    WMCommitAdviceViewController *commitAdvice = [[WMCommitAdviceViewController alloc] init];
    
    commitAdvice.goodID = self.goodID;
    
    commitAdvice.listSelectAdviceTypeID = selectTypeInfo.adviceTypeID;
    
    commitAdvice.adviceTypeInfoArr = infoArr;
    
    commitAdvice.settingInfo = self.settingInfo;
    
    WeakSelf(self);
    
    [commitAdvice setCommitAdviceSuccess:^(WMAdviceQuestionInfo *newAdviceInfo) {
        
        [weakSelf.adviceInfoArr insertObject:newAdviceInfo atIndex:0];
        
        [weakSelf.tableView beginUpdates];
        
        [weakSelf.tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [weakSelf.tableView endUpdates];
    }];
    
    [commitAdvice setChangeAdviceCount:^(NSArray *titlesArr) {
        
        [weakSelf.adviceListMenuBar setTitles:titlesArr];
    }];
    
    [self.navigationController pushViewController:commitAdvice animated:YES];
}











@end

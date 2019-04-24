//
//  WMGoodCommentAddViewController.m
//  StandardShop
//
//  Created by 罗海雄 on 16/6/29.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodCommentAddViewController.h"
#import "WMGoodInfo.h"
#import "WMGoodCommentAddHeaderView.h"
#import "WMGoodCommentImageUploadCell.h"
#import "WMGoodCommentScoreSelectCell.h"
#import "WMGoodCommentAddFooter.h"
#import "WMGoodCommentScoreInfo.h"
#import "WMGoodCommentRuleInfo.h"
#import "WMCommentOperation.h"
#import "WMImageVerificationCodeView.h"
#import "WMGoodCommentScoreView.h"
#import "WMImageUploadInfo.h"

@interface WMGoodCommentAddViewController ()<SeaHttpRequestDelegate,WMGoodCommentImageUploadCellDelegate>

///网络请求
@property(nonatomic,strong) SeaHttpRequest *httpRequest;

///cells 数组元素是 UITableViewCell
@property(nonatomic,strong) NSMutableArray *cells;

///提交按钮
@property(nonatomic,strong) UIButton *submit_btn;

///评分规则信息
@property(nonatomic,strong) WMGoodCommentRuleInfo *ruleInfo;

///头部
@property(nonatomic,strong) WMGoodCommentAddHeaderView *header;

///底部
@property(nonatomic,strong) WMGoodCommentAddFooter *footer;

///上传图片的cell
@property(nonatomic,strong) WMGoodCommentImageUploadCell *imageUploadCell;

@end

@implementation WMGoodCommentAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"商品评价";
    self.backItem = YES;
    self.view.backgroundColor = _SeaViewControllerBackgroundColor_;
    self.httpRequest = [[SeaHttpRequest alloc] initWithDelegate:self];

    [self reloadDataFromNetwork];
}

- (void)initialization
{
    self.loading = NO;
    self.cells = [NSMutableArray arrayWithCapacity:self.ruleInfo.scoreInfos.count];
    self.imageUploadCell = [[WMGoodCommentImageUploadCell alloc] initWithMaxCount:6];
    [self.cells addObject:self.imageUploadCell];

    ///表头
    WMGoodCommentAddHeaderView *header = [[WMGoodCommentAddHeaderView alloc] init];
    if(![NSString isEmpty:self.ruleInfo.codeURL])
    {
        [header addImageCode:self.ruleInfo.codeURL];
    }

    if(self.ruleInfo.placeHolder)
    {
        header.textView.placeholder = self.ruleInfo.placeHolder;
    }

    ///评分选项
    for(WMGoodCommentScoreInfo *info in self.ruleInfo.scoreInfos)
    {
        if(info.isDefault)
        {
            header.titleLabel.text = info.name;
            header.info = info;
        }
        else
        {
            WMGoodCommentScoreSelectCell *cell = [[WMGoodCommentScoreSelectCell alloc] init];
            cell.titleLabel.text = info.name;
            cell.info = info;
            [self.cells addObject:cell];
        }
    }


    [header.goodImageView sea_setImageWithURL:self.goodInfo.imageURL];

    [super initialization];

    self.header = header;

    self.tableView.tableHeaderView = header;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];

    ///表底部
    WMGoodCommentAddFooter *footer = [[WMGoodCommentAddFooter alloc] init];
    self.tableView.tableFooterView = footer;

    self.footer = footer;

    self.tableView.showsVerticalScrollIndicator = NO;


    ///提交按钮
    CGFloat margin = 10.0;
    CGFloat height = margin + WMLongButtonHeight;

    self.tableView.height -= height;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.tableView.bottom, _width_, height)];
    view.backgroundColor = [UIColor clearColor];

    self.submit_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submit_btn.backgroundColor = WMButtonBackgroundColor;
    [self.submit_btn setTitle:@"提交" forState:UIControlStateNormal];
    [self.submit_btn setTitleColor:WMButtonTitleColor forState:UIControlStateNormal];
    [self.submit_btn addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    self.submit_btn.layer.cornerRadius = WMLongButtonCornerRaidus;
    self.submit_btn.layer.masksToBounds = YES;
    self.submit_btn.frame = CGRectMake(margin, 0, view.width - margin * 2, WMLongButtonHeight);
    [view addSubview:self.submit_btn];

    [self.view addSubview:view];
}

///提交评价
- (void)submit:(UIButton*) btn
{
    if([NSString isEmpty:self.header.textView.text])
    {
        [self alertMsg:@"请输入评价内容"];
        return;
    }

    if(![NSString isEmpty:self.ruleInfo.codeURL] && [NSString isEmpty:self.header.imageCodeView.textField.text])
    {
        [self alertMsg:@"请输入验证码"];
        return;
    }

    for(WMGoodCommentScoreSelectCell *cell in self.cells)
    {
        if([cell isKindOfClass:[WMGoodCommentScoreSelectCell class]])
        {
            cell.info.score = cell.scoreView.score;
        }
    }
    
    NSArray *images = self.imageUploadCell.infos;
    
    for(WMImageUploadInfo *info in images)
    {
        if(info.uploading)
        {
            [self alertMsg:@"图片正在上传，请稍后"];
            return;
        }
        else if(info.uploadFail)
        {
            [self alertMsg:@"图片上传失败，请重新上传"];
            return;
        }
    }

    self.header.info.score = self.header.scoreView.score;

    self.showNetworkActivity = YES;
    self.requesting = YES;

    self.httpRequest.identifier = WMGoodCommentAddIdentifier;
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMCommentOperation goodCommentAddParamsWithGoodId:self.goodInfo.goodId productId:self.goodInfo.productId orderId:self.orderId content:self.header.textView.text anonymous:self.footer.aSwitch.on code:self.header.imageCodeView.textField.text scores:self.ruleInfo.scoreInfos images:images]];
}

#pragma mark- http

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
    if([request.identifier isEqualToString:WMGoodCommentRuleIdentifier])
    {
        [self failToLoadData];
        return;
    }

    if([request.identifier isEqualToString:WMGoodCommentAddIdentifier])
    {
        self.requesting = NO;
        [self alertMsg:@"评价失败"];
        return;
    }
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{
    if([request.identifier isEqualToString:WMGoodCommentRuleIdentifier])
    {
        self.ruleInfo = [WMCommentOperation goodCommentRuleFromData:data];
        if(self.ruleInfo)
        {
            [self initialization];
        }
        else
        {
            [self failToLoadData];
        }

        return;
    }

    if([request.identifier isEqualToString:WMGoodCommentAddIdentifier])
    {
        self.showNetworkActivity = NO;
        if([WMCommentOperation goodCommentAddResultFromData:data])
        {
            [[AppDelegate instance] alertMsg:@"评价成功"];
            !self.commentDidFinsihHandler ?: self.commentDidFinsihHandler();
            [self performSelector:@selector(back) withObject:nil afterDelay:1.0];
        }
        else
        {
            self.requesting = NO;
            [self.header.imageCodeView refreshCode];
        }

        return;
    }
}

- (void)reloadDataFromNetwork
{
    self.loading = YES;
    [self loadRuleInfo];
}

///加载商品评价规则
- (void)loadRuleInfo
{
    self.httpRequest.identifier = WMGoodCommentRuleIdentifier;
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMCommentOperation goodCommentRuleParams]];
}

#pragma mark- UITableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cells.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMGoodCommentImageUploadCell *cell = [self.cells objectAtIndex:indexPath.row];
    if([cell isKindOfClass:[WMGoodCommentImageUploadCell class]])
    {
        return cell.rowHeight;
    }
    else
    {
        return WMGoodCommentScoreSelectCellHeight;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMGoodCommentImageUploadCell *cell = [self.cells objectAtIndex:indexPath.row];
    if([cell isKindOfClass:[WMGoodCommentImageUploadCell class]])
    {
        cell.viewController = self;
        cell.delegate = self;
    }

    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

#pragma mark- WMGoodCommentImageUploadCell delegate

- (void)goodCommentImageUploadCellHeightDidChange:(WMGoodCommentImageUploadCell *)cell
{
    [self.tableView reloadData];
}

@end

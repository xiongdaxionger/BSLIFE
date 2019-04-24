//
//  WMGoodDetailInfoExtraInfoViewController.m
//  StandardShop
//
//  Created by mac on 16/6/12.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodDetailInfoExtraInfoViewController.h"

#import "WMGoodExtraInfoTableViewCell.h"

@interface WMGoodDetailInfoExtraInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
/**内容视图
 */
@property (strong,nonatomic) UIView *contentView;
/**表格视图
 */
@property (strong,nonatomic) UITableView *tableView;
@end

@implementation WMGoodDetailInfoExtraInfoViewController

#pragma mark - 控制器生命周期
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    
    [self initialization];
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
        
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.0, _width_, _height_ - 200.0)];

    _contentView.backgroundColor = [UIColor whiteColor];
    
    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _width_, WMGoodExtraInfoTableViewCellHeight)];
    
    headerView.font = [UIFont fontWithName:MainFontName size:16.0];
    
    headerView.textAlignment = NSTextAlignmentCenter;
    
    headerView.text = @"商品属性";
    
    headerView.backgroundColor = [UIColor whiteColor];
    
    [_contentView addSubview:headerView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, headerView.bottom, _width_, _contentView.height - 2 * WMGoodExtraInfoTableViewCellHeight) style:UITableViewStyleGrouped];
    
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.dataSource = self;
    
    self.tableView.delegate = self;
        
    [self.tableView registerNib:[UINib nibWithNibName:@"WMGoodExtraInfoTableViewCell" bundle:nil] forCellReuseIdentifier:WMGoodExtraInfoTableViewCellIden];
    
    [_contentView addSubview:self.tableView];
    
    UIButton *finishButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.tableView.bottom, _width_, WMGoodExtraInfoTableViewCellHeight)];
    
    finishButton.backgroundColor = WMRedColor;
    
    [finishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [finishButton setTitle:@"完成" forState:UIControlStateNormal];
    
    [finishButton addTarget:self action:@selector(finishButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_contentView addSubview:finishButton];
    
    [self.view addSubview:_contentView];
}

#pragma mark - 表格视图协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _extraInfosArr.count;
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
    
    WMGoodExtraInfoTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:WMGoodExtraInfoTableViewCellIden forIndexPath:indexPath];
    
    [cell configureWithDict:[_extraInfosArr objectAtIndex:indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *extraDict = [_extraInfosArr objectAtIndex:indexPath.row];
    
    return MAX(WMGoodExtraInfoTableViewCellHeight, [[extraDict sea_stringForKey:@"value"] stringSizeWithFont:[UIFont fontWithName:MainFontName size:15.0] contraintWith:_width_ - 100.0].height);
}

#pragma mark - 私有方法

- (void)dismissSelf{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)finishButtonClick{
    
    [self dismissSelf];
}









@end

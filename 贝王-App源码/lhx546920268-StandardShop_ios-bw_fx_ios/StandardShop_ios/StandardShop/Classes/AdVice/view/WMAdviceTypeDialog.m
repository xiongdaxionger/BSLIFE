//
//  WMAdviceTypeDialog.m
//  StandardShop
//
//  Created by mac on 16/6/2.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMAdviceTypeDialog.h"
#import "WMAdviceTypeSelectViewCell.h"

#import "WMAdviceTypeInfo.h"

@interface WMAdviceTypeDialog ()<UITableViewDataSource,UITableViewDelegate>
/**咨询类型列表
 */
@property (strong,nonatomic) UITableView *tableView;
/**上次选中的列
 */
@property (assign,nonatomic) NSInteger lastSelectRow;
@end

@implementation WMAdviceTypeDialog

#pragma mark - 初始化
- (id)initWithTypeInfoArr:(NSArray *)infoArr{
    
    self = [super init];
    
    CGFloat margin = 20.0;
    
    CGFloat width = _width_ - margin * 2;
    
    CGFloat rollHeight = WMAdviceTypeSelectViewCellHeight *infoArr.count + WMAdviceTypeFooterHeight + WMAdviceTypeHeaderHeight;
    
    CGRect frame = CGRectMake(margin, (_height_ - rollHeight) / 2.0, width,rollHeight);
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.lastSelectRow = 0;

        self.adviceTypeInfoArr = infoArr;
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, width, rollHeight) style:UITableViewStylePlain];
        
        self.tableView.dataSource = self;
        
        self.tableView.delegate = self;
        
        self.tableView.scrollEnabled = NO;
        
        self.tableView.scrollsToTop = NO;
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        self.tableView.layer.cornerRadius = 5.0;
        
        self.tableView.layer.masksToBounds = YES;
        
        self.tableView.backgroundColor = [UIColor whiteColor];
        
        CGFloat titleWidth = width / 2.0;
        
        CGFloat titleHeight = 30.0;
        
        CGFloat buttonWidth = 25.0;
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, WMAdviceTypeHeaderHeight)];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((headerView.width - titleWidth) / 2.0, (WMAdviceTypeHeaderHeight - titleHeight) / 2.0, titleWidth, titleHeight)];
        
        titleLabel.text = @"请选择咨询类型";
        
        titleLabel.font = [UIFont fontWithName:MainFontName size:18.0];
        
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        titleLabel.textColor = WMRedColor;
        
        [headerView addSubview:titleLabel];
        
        UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(headerView.width - buttonWidth - 10.0, (headerView.height - buttonWidth) / 2.0, buttonWidth, buttonWidth)];
        
        [closeButton setBackgroundImage:[UIImage imageNamed:@"close_dialog"] forState:UIControlStateNormal];
        
        [headerView addSubview:closeButton];
        
        [closeButton addTarget:self action:@selector(closeDialog) forControlEvents:UIControlEventTouchUpInside];
        
        self.tableView.tableHeaderView = headerView;
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, WMAdviceTypeFooterHeight)];
        
        CGFloat margin = 10.0;
        
        CGFloat buttonHeight = 38.0;
        
        CGFloat commitButtonWidth = footerView.width - 2 * margin;
        
        UIButton *commitButton = [[UIButton alloc] initWithFrame:CGRectMake(margin, (WMAdviceTypeHeaderHeight - buttonHeight) / 2.0, commitButtonWidth, buttonHeight)];
        
        commitButton.layer.cornerRadius = 3.0;
        
        [commitButton setTitle:@"确定" forState:UIControlStateNormal];
        
        [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        commitButton.backgroundColor = WMPriceColor;
        
        commitButton.titleLabel.font = [UIFont fontWithName:MainFontName size:16.0];
        
        [commitButton addTarget:self action:@selector(commitButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        [footerView addSubview:commitButton];
        
        self.tableView.tableFooterView = footerView;
        
        [self.tableView registerNib:[UINib nibWithNibName:@"WMAdviceTypeSelectViewCell" bundle:nil] forCellReuseIdentifier:WMAdviceTypeSelectViewCellIden];
        
        [self addSubview:self.tableView];
        
        self.height = self.tableView.bottom;
        
        self.showAnimate = SeaDialogAnimateUpDown;
        
        self.dismissAnimate = SeaDialogAnimateUpDown;
        
        self.targetFrame = frame;
    }
    
    return self;
}

#pragma mark - UITableView协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _adviceTypeInfoArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return WMAdviceTypeSelectViewCellHeight;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMAdviceTypeSelectViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WMAdviceTypeSelectViewCellIden forIndexPath:indexPath];
    
    WMAdviceTypeInfo *info = [_adviceTypeInfoArr objectAtIndex:indexPath.row];
    
    [cell configureAdviceTypeInfo:info];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self selectPayMethod:indexPath tableView:tableView];
}

#pragma mark - 切换咨询类型
- (void)selectPayMethod:(NSIndexPath *)indexPath tableView:(UITableView *)tableView{
    
    if (self.lastSelectRow == indexPath.row) {
        
        return;
    }
    else{
        
        [self selectPayMethod:tableView indexPath:indexPath iamge:[WMImageInitialization tickingIcon] isSelect:YES didSelect:YES];
        
        [self selectPayMethod:tableView indexPath:[NSIndexPath indexPathForRow:self.lastSelectRow inSection:indexPath.section] iamge:[WMImageInitialization untickIcon] isSelect:NO didSelect:NO];
        
        self.lastSelectRow = indexPath.row;
    }
}

- (void)selectPayMethod:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath iamge:(UIImage *)image isSelect:(BOOL)isSelect didSelect:(BOOL)didSelect{
    
    WMAdviceTypeInfo *infoModel = _adviceTypeInfoArr[indexPath.row];
    
    WMAdviceTypeSelectViewCell *cell = (WMAdviceTypeSelectViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    [cell.adviceSelectButton setBackgroundImage:image forState:UIControlStateDisabled];
    
    infoModel.adviceTypeIsSelect = isSelect;
}

#pragma mark - 关闭弹窗
- (void)closeDialog
{
    [self dismiss];
}

#pragma mark - 确定按钮事件
- (void)commitButtonClick{
    
    for (WMAdviceTypeInfo *selectInfo in self.adviceTypeInfoArr) {
        
        if (selectInfo.adviceTypeIsSelect) {
            
            if (self.commitAdvice) {
                
                self.commitAdvice(selectInfo);
            }
            
            [self closeDialog];
            
            break;
        }
    }
}


















@end

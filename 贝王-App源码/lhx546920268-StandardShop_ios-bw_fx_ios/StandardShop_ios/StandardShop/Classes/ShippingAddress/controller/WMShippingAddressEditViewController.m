//
//  WMShippingAddressEditViewController.m
//  WuMei
//
//  Created by 罗海雄 on 15/7/22.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "WMShippingAddressEditViewController.h"
#import "WMShippingAddressInfo.h"
#import "WMShippingAddressDelegate.h"
#import "WMShippingAddressOperation.h"
#import "WMShippingAddressEditCell.h"
#import "WMAreaSelectViewController.h"
#import "WMAreaInfo.h"
#import "SeaNumberKeyboard.h"

@interface WMShippingAddressEditViewController ()<SeaHttpRequestDelegate,WMAreaSelectViewControllerDelegate,UIAlertViewDelegate,UITextViewDelegate>

/**网络请求
 */
@property(nonatomic,strong) SeaHttpRequest *httpRequest;

/**要修改的收货地址信息
 */
@property(nonatomic,copy) WMShippingAddressInfo *info;

/**地区信息
 */
@property(nonatomic,strong) NSMutableArray *areaInfos;

/**选中的cell
 */
@property(nonatomic,strong) NSIndexPath *selectedIndexPath;

///详细地址
@property(nonatomic,strong) UITextView *textView;

/**默认按钮
 */
@property (strong,nonatomic) WMShippingAddressDefaultCell *defaultCell;

@end

@implementation WMShippingAddressEditViewController

- (void)setRequesting:(BOOL)requesting
{
    [super setRequesting:requesting];
    self.tableView.userInteractionEnabled = !self.requesting;
    self.rightBarButtonItem.enabled = !self.requesting;
}

/**以收货地址信息初始化，新增传nil
 */
- (id)initWithInfo:(WMShippingAddressInfo*) info
{
    self = [super init];
    if(self)
    {
        self.info = info;
        
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = _SeaViewControllerBackgroundColor_;
    self.areaInfos = [NSMutableArray array];
    
    self.backItem = YES;
    self.defaultCell = [[WMShippingAddressDefaultCell alloc] init];
    
    if(!self.info)
    {
        self.info = [[WMShippingAddressInfo alloc] init];
        self.title = @"新增收货地址";
    }
    else
    {
        self.title = @"编辑收货地址";
    }
    
    self.httpRequest = [[SeaHttpRequest alloc] initWithDelegate:self];
    
    if(self.info.Id != 0)
    {
        
        [self reloadDataFromNetwork];
    }
    else
    {
        [self initialization];
    }
}

- (void)initialization
{
    self.info.telPhoneNumber = @"34498327492384743";
    
    if(self.info.telPhoneNumber)
    {
        self.info.telPhoneNumber = [self.info.telPhoneNumber formatTelPhoneNumber];
    }
    
    self.loading = NO;
    self.style = UITableViewStyleGrouped;
    self.separatorEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [super initialization];
    
    if(self.info.Id != 0)
    {
        //设置删除按钮
        if (self.canDeleteAddress) {
            
            [self setBarItemsWithTitle:@"删除" icon:nil action:@selector(deleteAddress) position:SeaNavigationItemPositionRight];
        }
    }
    
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    CGFloat topMargin = 40.0;
    CGFloat margin = 15.0;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:WMButtonTitleColor forState:UIControlStateNormal];
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    btn.titleLabel.font = WMLongButtonTitleFont;
    [btn setBackgroundColor:WMButtonBackgroundColor];
    [btn setFrame:CGRectMake(margin, self.contentHeight - 55.0 - (isIPhoneX ? 35.0 : 0.0), _width_ - margin * 2, topMargin)];
    
    btn.layer.cornerRadius = 3.0;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(saveShippingAddress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

    self.tableView.height -= (55.0 + (isIPhoneX ? 35.0 : 0.0));
    
    
    
    if (self.info) {
        
        self.defaultCell.defaultButton.selected = self.info.isDefaultAdr;
    }
}

//删除收货地址
- (void)deleteAddress
{
    if(self.requesting)
        return;
    [self reconverKeyboard];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"确定删除此收货地址？" delegate:self cancelButtonTitle:nil otherButtonTitles:@"删除", @"取消", nil];
    [alertView show];
}

///设置为默认
- (void)setDefaultClick
{
    self.defaultCell.defaultButton.selected = !self.defaultCell.defaultButton.selected;
    _info.isDefaultAdr = self.defaultCell.defaultButton.selected;
}

#pragma mark- UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [self deleteAddr];
    }
}

- (void)deleteAddr
{
    self.requesting = YES;
    self.showNetworkActivity = YES;
    self.httpRequest.identifier = WMDeleteShippingAddresInfoIdentifier;
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMShippingAddressOperation deleteShippingAddresInfo:self.info memberID:self.selectMemberID]];
}

//保存收货信息
- (void)saveShippingAddress
{
    [self reconverKeyboard];
    
    [self uploadInfo];
}

//回收键盘
- (void)reconverKeyboard
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

#pragma mark- http

//加载要编辑的地址信息
- (void)reloadDataFromNetwork
{
    self.loading = YES;
    self.httpRequest.identifier = WMEditedShippingAddressIdentifier;
    
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMShippingAddressOperation editedShippingAddressParamWithId:self.info.Id memberID:self.selectMemberID]];
}

//上传地址信息
- (void)uploadInfo
{
    if([NSString isEmpty:_info.consignee])
    {
        [self alertMsg:@"请输入收货人"];
        return;
    }
    
//    if ([NSString isEmpty:_info.phoneNumber] && [NSString isEmpty:_info.telPhoneNumber])
//    {
//        [self alertMsg:@"手机号和固定电话必须输入一个"];
//        return;
//    }
    
    if(![_info.phoneNumber isMobileNumber])
    {
        [self alertMsg:@"请输入有效手机号"];
        return;
    }
    
//    if(![NSString isEmpty:_info.telPhoneNumber] && ![_info.telPhoneNumber isTelPhoneNumber])
//    {
//        [self alertMsg:@"请输入有效固定电话"];
//        return;
//    }
//    
    if([NSString isEmpty:_info.mainland])
    {
        [self alertMsg:@"请选择地区"];
        return;
    }

    _info.detailAddress = [_info.detailAddress stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    _info.detailAddress = [_info.detailAddress stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    _info.detailAddress = [_info.detailAddress stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    if([NSString isEmpty:_info.detailAddress])
    {
        [self alertMsg:@"请输入详细地址"];
        return;
    }
    
    
    
//    if([NSString isEmpty:_info.cartId])
//    {
//        [self alertMsg:@"请输入身份证号码"];
//        return;
//    }
//    else if (![_info.cartId isCardId])
//    {
//        [self alertMsg:@"请输入有效身份证号码"];
//        return;
//    }

        
    self.requesting = YES;
    self.showNetworkActivity = YES;
    self.httpRequest.identifier = WMSaveShippingAddressInfoIdentifier;
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMShippingAddressOperation saveShippingAddressInfo:self.info memberID:self.selectMemberID]];
}


#pragma mark-

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
    if([request.identifier isEqualToString:WMEditedShippingAddressIdentifier])
    {
        [self failToLoadData];
        return;
    }
    
    
    self.requesting = NO;
    self.showNetworkActivity = NO;
    if([request.identifier isEqualToString:WMDeleteShippingAddresInfoIdentifier])
    {
        [self alerBadNetworkMsg:@"删除收货地址失败"];
        return;
    }
    
    if([request.identifier isEqualToString:WMSaveShippingAddressInfoIdentifier])
    {
        
        [self alerBadNetworkMsg:[NSString stringWithFormat:@"%@失败", self.title]];
        return;
    }
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{
    if([request.identifier isEqualToString:WMEditedShippingAddressIdentifier])
    {
        WMShippingAddressInfo *info = [WMShippingAddressOperation editedShippingAddressFromData:data];
        
        if(info)
        {
            self.info = info;
            
            
            [self initialization];
        }
        else
        {
            [self failToLoadData];
        }
        return;
    }
    
    self.requesting = NO;
    self.showNetworkActivity = NO;
    if([request.identifier isEqualToString:WMDeleteShippingAddresInfoIdentifier])
    {
        if([WMShippingAddressOperation deleteShippingAddressResultFromData:data])
        {
            [self alertMsg:@"删除成功"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:WMShippingAddressOperaionDidFinishNotification object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:WMShippingAddressOperationDeleted], WMShippingAddressOperationType, self.info, WMShippingAddressOperaionInfo, nil]];
            [self back];
        }
        return;
    }
    
    if([request.identifier isEqualToString:WMSaveShippingAddressInfoIdentifier])
    {
        WMShippingAddressInfo *addressInfo = [WMShippingAddressOperation saveShippingAddressResultFromData:data];
        
        if(addressInfo)
        {
            WMShippingAddressOperationStyle type = self.info.Id != 0 ? WMShippingAddressOperationModified : WMShippingAddressOperationAdded;
            
            if(self.info.Id == 0)
            {
                self.info.Id = addressInfo.Id;
            }
            
            self.info.jsonValue = addressInfo.jsonValue;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:WMShippingAddressOperaionDidFinishNotification object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:type], WMShippingAddressOperationType, self.info, WMShippingAddressOperaionInfo, nil]];
            
            if (self.canDeleteAddress) {
                
                [super back];
            }
            else{
                
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 3] animated:YES];
            }
            
        }
        
        return;
    }
}

#pragma mark- 视图消失出现

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self addKeyboardNotification];
    
    [self textViewDidChange:self.textView];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self removeKeyboardNotification];
}


#pragma mark- UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? 4 : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return WMShippingAddressEditCellRowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *result;
    if(indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 0 :
            case 1 :
            case 5 :
            {
                static NSString *cellIdentifier = @"cell1";
                WMShippingAddressEditSingleInputCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                
                UIFont *font = [UIFont fontWithName:MainFontName size:15.0];
                if(cell == nil)
                {
                    cell = [[WMShippingAddressEditSingleInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    cell.textField.delegate = self;
                }
                
                cell.textField.tag = indexPath.row;
                cell.textField.textAlignment = NSTextAlignmentLeft;
                cell.textField.keyboardType = UIKeyboardTypeDefault;
                cell.textField.font = font;
                cell.textField.inputView = nil;
                
                switch (indexPath.row)
                {
                    case 0 :
                    {
                        cell.titleLabel.text = @"收货人";
                        cell.titleLabel.font = font;
                        cell.textField.text = self.info.consignee;
                    }
                        break;
                    case 1 :
                    {
                        cell.titleLabel.text = @"手机号码";
                        cell.textField.text = self.info.phoneNumber;
                        cell.titleLabel.font = font;
                        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                    }
                        break;
                    case 2 :
                    {
                        cell.titleLabel.text = @"固定电话";
                        cell.textField.text = self.info.telPhoneNumber;
                        cell.titleLabel.font = font;
                        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                    }
                        break;
                    case 5 :
                    {
                        cell.titleLabel.text = @"身份证号码";
                        cell.titleLabel.font = font;
//                        cell.textField.text = self.info.cartId;
                        
                        SeaNumberKeyboard *keyboard = [[SeaNumberKeyboard alloc] initWithotherButtonTittle:@"X"];
                        keyboard.textField = cell.textField;
                        keyboard.inpuLimitMax = 18;
                        
                        cell.textField.inputView = keyboard;
                    }
                        break;
                    default:
                        break;
                }
                result = cell;
            }
                break;
            case 2 :
            {
                static NSString *cellIdentifier = @"cell2";
                WMShippingAddressEditCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                
                if(cell == nil)
                {
                    cell = [[WMShippingAddressEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                }
                
                switch (indexPath.row)
                {
                    case 2 :
                    {
                        cell.titleLabel.text = @"地区";
                        cell.titleLabel.font = [UIFont fontWithName:MainFontName size:15.0];
                        
                        cell.contentLabel.text = self.info.area;
                        cell.contentLabel.font = [UIFont fontWithName:MainFontName size:15.0];
                        //85
                        cell.contentLabel.textAlignment = NSTextAlignmentLeft;
                    }
                        break;
                        break;
                }
                result = cell;
            }
                break;
            case 3 :
            {
                static NSString *cellIdentifier = @"cell3";
                WMShippingAddressEditMultiInputCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                
                if(cell == nil)
                {
                    cell = [[WMShippingAddressEditMultiInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    cell.textView.delegate = self;
                }
                
                self.textView = cell.textView;
                cell.titleLabel.text = @"详细地址";
                cell.titleLabel.font = [UIFont fontWithName:MainFontName size:15.0];
                cell.textView.text = self.info.detailAddress;
                cell.textView.font = [UIFont fontWithName:MainFontName size:15.0];
                cell.textView.textAlignment = NSTextAlignmentLeft;
                cell.textView.keyboardType = UIKeyboardTypeDefault;
                cell.textView.delegate = self;
                cell.textView.returnKeyType = UIReturnKeyDone;
                [self textViewDidChange:cell.textView];
                
                result = cell;
            }
                break;
            default:
                break;
        }
    }
    else
    {
        result = self.defaultCell;
    }
    
    return result;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.selectedIndexPath = indexPath;
    
    if(indexPath.section == 0)
    {
        NSString *title = nil;
        
        switch (indexPath.row)
        {
            case 2 :
            {
                title = @"地区";
            }
                break;
            default:
                break;
        }
        
        if(title)
        {
            WMAreaSelectViewController *area = [[WMAreaSelectViewController alloc] init];
            area.delegate = self;
            area.title = title;
            area.infos = self.areaInfos;
            area.rootViewController = self;
            [self.navigationController pushViewController:area animated:YES];
        }
    }
    else
    {
        [self setDefaultClick];
    }
}

#pragma mark- WMAreaSelectViewController delegate

- (void)areaSelectViewController:(WMAreaSelectViewController *)view didSelectArea:(NSString *)area
{
    self.info.area = area;
    self.info.mainland = [WMShippingAddressOperation combineAreaParamFromInfos:view.selectedInfos];
    
    [self.tableView reloadData];
}

#pragma mark- UITextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
   // CGRect frame = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag inSection:0]];
    //[self.tableView setContentOffset:CGPointMake(0, frame.origin.y) animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag)
    {
        case 0 :
        {
            self.info.consignee = textField.text;
        }
            break;
        case 1 :
        {
            self.info.phoneNumber = textField.text;
        }
            break;
//        case 2 :
//        {
//            self.info.telPhoneNumber = textField.text;
//        }
//            break;
//        case  4 :
//        {
//            self.info.cartId = textField.text;
//        }
//            break;
        default:
            break;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    switch (textField.tag)
    {
        case 0 :
        {
            return [textField textShouldChangeCharactersInRange:range replacementString:string limitedCount:WMConsigneeInputLimitMax];
        }
            break;
        case 1 :
        {
            return [textField textShouldChangeCharactersInRange:range replacementString:string limitedCount:WMPhoneNumberInputLimitMax];
        }
            break;
//        case 2 :
//        {
//            return [textField telPhoneNumberShouldChangeCharactersInRange:range replacementString:string];
//        }
//            break;
//        default:
            break;
    }

    return YES;
}

#pragma mark- UITextView delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
   // CGRect frame = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    //[self.tableView setContentOffset:CGPointMake(0, frame.origin.y) animated:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.info.detailAddress = textView.text;
    
    [self layoutTextView];
}

- (void)textViewDidChange:(UITextView *)textView
{
    [textView textDidChangeWithLimitedCount:WMAddressInputLimitMax];
    [self layoutTextView];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }

    [textView shouldChangeTextInRange:range replacementText:text withLimitedCount:WMAddressInputLimitMax];

    return YES;
}

//把textView的内容垂直居中
- (void)layoutTextView
{
    CGFloat textMargin = 8.0;
    CGSize size = [self.textView.text stringSizeWithFont:_textView.font contraintWith:_textView.width - textMargin * 2];
    
    CGFloat margin = MAX(0, (44 - size.height - textMargin * 2)) / 2.0;
    CGFloat height = MIN(44, size.height + textMargin * 2);
   
    CGRect frame = _textView.frame;
    frame.origin.y = margin;
    frame.size.height = height;
    _textView.frame = frame;
}

@end

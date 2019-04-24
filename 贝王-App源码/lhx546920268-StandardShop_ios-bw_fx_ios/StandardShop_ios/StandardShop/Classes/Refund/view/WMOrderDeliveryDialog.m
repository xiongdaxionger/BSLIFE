//
//  WMOrderDeliveryDialog.m
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/15.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMOrderDeliveryDialog.h"
#import "UBPicker.h"
#import "WMQRCodeScanViewController.h"
#import "WMTabBarController.h"

#import "WMRefundOperation.h"

///边距
#define WMOrderDeliveryDialogMargin 15.0

@interface WMOrderDeliveryDialog ()<UBPickerDelegate,UITextFieldDelegate,SeaHttpRequestDelegate>

/**取消按钮
 */
@property(nonatomic,strong) UIButton *cancelButton;

/**发货按钮
 */
@property(nonatomic,strong) UIButton *deliveryButton;

/**快递输入框
 */
@property(nonatomic,strong) UITextField *courierTextField;

/**物流
 */
@property(nonatomic,strong) UITextField *logisticsTextField;

///物流公司选择器
@property(nonatomic,strong) UBPicker *picker;

///请求
@property (strong,nonatomic) SeaHttpRequest *request;
@end

@implementation WMOrderDeliveryDialog

- (id)init
{
    
    CGFloat margin = WMOrderDeliveryDialogMargin;
    CGFloat width = _width_ - margin * 2;
    
    self = [super initWithFrame:CGRectMake(margin, (_height_ - 340.0) / 2.0, width, 340.0)];
    if(self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5.0;
        self.layer.masksToBounds = YES;
        
        ///分段选择
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(WMOrderDeliveryDialogMargin, WMOrderDeliveryDialogMargin, width - 2 * WMOrderDeliveryDialogMargin, 25.0)];
        headerLabel.text = @"请填写退回货物的快递信息";
        headerLabel.textColor = WMRedColor;
        headerLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:headerLabel];
        
        ///分割线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, headerLabel.bottom + margin, width, _separatorLineWidth_)];
        line.backgroundColor = _separatorLineColor_;
        [self addSubview:line];
        
        ///物流单号
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(margin, line.bottom + WMOrderDeliveryDialogMargin, width - margin * 2, 40.0)];
        textField.borderStyle = UITextBorderStyleNone;
        textField.layer.cornerRadius = 3.0;
        textField.layer.masksToBounds = YES;
        textField.layer.borderColor = _separatorLineColor_.CGColor;
        textField.layer.borderWidth = _separatorLineWidth_;
        textField.placeholder = @"请输入快递单号";
        textField.delegate = self;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, margin, textField.height)];
        textField.leftViewMode = UITextFieldViewModeAlways;
        
        ///扫描按钮
        UIImage *image = [UIImage imageNamed:@"qrcode_icon_black"];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(scanCourier) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:image forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(0, 0, image.size.width + margin * 2, textField.height)];
        textField.rightView = btn;
        textField.rightViewMode = UITextFieldViewModeAlways;
        [self addSubview:textField];
        self.courierTextField = textField;
        
        ///物流公司
        textField = [[UITextField alloc] initWithFrame:CGRectMake(margin, self.courierTextField.bottom + WMOrderDeliveryDialogMargin, width - margin * 2, 40.0)];
        textField.borderStyle = UITextBorderStyleNone;
        textField.layer.cornerRadius = 3.0;
        textField.layer.masksToBounds = YES;
        textField.layer.borderColor = _separatorLineColor_.CGColor;
        textField.layer.borderWidth = _separatorLineWidth_;
        textField.placeholder = @"请选择物流公司";
        textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, margin, textField.height)];
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.delegate = self;
        
        ///物流公司选择
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tintColor = [UIColor blackColor];
        [btn addTarget:self action:@selector(selectLogistics) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:@"triangle_down"] forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(0, 0, image.size.width + margin * 2, textField.height)];
        textField.rightView = btn;
        textField.rightViewMode = UITextFieldViewModeAlways;
        [self addSubview:textField];
        self.logisticsTextField = textField;
        
        
        CGFloat buttonHeight = 49.0;
        CGFloat buttonWidth = width / 2.0;
        
        //取消按钮
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:MainFontName size:16.0];
        [btn addTarget:self action:@selector(closeDialog) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(0, self.height - buttonHeight, buttonWidth, buttonHeight);
        [self addSubview:btn];
        self.cancelButton = btn;
        
        ///发货按钮
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"确认" forState:UIControlStateNormal];
        [btn setBackgroundColor:WMRedColor];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:MainFontName size:16.0];
        btn.frame = CGRectMake(self.cancelButton.right, self.height - buttonHeight, buttonWidth, buttonHeight);
        [btn addTarget:self action:@selector(delivery) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        self.deliveryButton = btn;
        
        ///分割线
        line = [[UIView alloc] initWithFrame:CGRectMake(0, self.cancelButton.top - _separatorLineWidth_, width, _separatorLineWidth_)];
        line.backgroundColor = _separatorLineColor_;
        [self addSubview:line];
        
        line = [[UIView alloc] initWithFrame:CGRectMake((width - _separatorLineWidth_) / 2.0, self.cancelButton.top, _separatorLineWidth_, self.cancelButton.height)];
        line.backgroundColor = _separatorLineColor_;
        [self addSubview:line];
        
        self.showAnimate = SeaDialogAnimateScale;
        
        self.request = [[SeaHttpRequest alloc] initWithDelegate:self];
    }
    
    return self;
}


#pragma mark- private method
///关闭
- (void)closeDialog
{
    if([self.courierTextField isFirstResponder] || [self.logisticsTextField isFirstResponder])
    {
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
        
        return;
    }
    
    if(!self.cancelButton.enabled)
        return;
    self.cancelButton.enabled = NO;
    
    [self dismiss];
}

///发货
- (void)delivery
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    AppDelegate *delegate = [AppDelegate instance];
    
    [_picker dismissWithAnimated:YES completion:nil];
    
    if ([NSString isEmpty:_courierTextField.text]) {
        
        [delegate alertMsg:@"请输入快递单号"];
        
        return;
    }
    
    if ([NSString isEmpty:_logisticsTextField.text]) {
        
        [delegate alertMsg:@"请选择快递公司"];
        
        return;
    }
    
    delegate.showNetworkActivity = YES;
    
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMRefundOperation returnSaveDeliveryInfoWithCompanyName:_logisticsTextField.text deliveryNumber:_courierTextField.text orderID:self.refundID]];
}

///扫描快递单
- (void)scanCourier
{
    WMQRCodeScanViewController *qrcode = [[WMQRCodeScanViewController alloc] init];
    qrcode.type = WMCodeScaneTypeBarCode;
    qrcode.codeScanHandler = ^(NSString *result){
      
        self.courierTextField.text = result;
    };
    
    SeaNavigationController *nav = [[SeaNavigationController alloc] initWithRootViewController:qrcode];
    nav.targetStatusBarStyle = [[AppDelegate tabBarController] preferredStatusBarStyle];
    [self.dialogViewController presentViewController:nav animated:YES completion:nil];
}

///选择物流
- (void)selectLogistics
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if(!self.picker || self.picker.infos.count == 0)
    {
        [self.picker removeFromSuperview];
        self.picker = [[UBPicker alloc] initWithSuperView:self.dialogViewController.view style:UBPickerStyleLogistics];
        self.picker.hidden = YES;
        self.picker.infos = self.deliverysArr;
        self.picker.delegate = self;
    }
    
    if(self.picker.hidden)
    {
        self.picker.hidden = NO;
        [self.picker showWithAnimated:YES completion:nil];
    }
    else
    {
        [self.picker dismissWithAnimated:YES completion:nil];
    }
}

#pragma mark- UBPicker delegate


- (void)pickerDidDismiss:(UBPicker *)picker
{
    self.picker.hidden = YES;
}

- (void)picker:(UBPicker *)picker didFinisedWithConditions:(NSDictionary *)conditions
{
    NSString *logistics = [conditions objectForKey:@"content"];
    
    self.logisticsTextField.text = logistics;
}

#pragma mark- UITextField delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if([textField isEqual:self.logisticsTextField])
    {
        if([textField.text isEqualToString:@"其他"])
        {
            return YES;
        }
        else
        {
            [self selectLogistics];
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - 网络请求结果
- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error{
    
    AppDelegate *delegate = [AppDelegate instance];
    
    delegate.showNetworkActivity = NO;
    
    [delegate alertMsg:@"网络错误，请重试"];
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data{
    
    AppDelegate *delegate = [AppDelegate instance];
    
    delegate.showNetworkActivity = NO;
    
    NSDictionary *result = [WMRefundOperation returnSaveDeliveryInfoResultWithData:data];
    
    if (result) {
        
        [delegate alertMsg:@"保存成功"];
        
        [self performSelector:@selector(closeDialog) withObject:nil afterDelay:1.0];
        
        if (self.orderDeliveryCompletionHandler) {
            
            self.orderDeliveryCompletionHandler(result);
        }
    }
}

@end

//
//  WMQRCodeScanViewController.m
//  WestMailDutyFee
//
//  Created by 罗海雄 on 15/8/26.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMQRCodeScanViewController.h"
#import "WMQRCodeScanBackgroundView.h"
#import <AVFoundation/AVFoundation.h>
#import "WMGoodDetailOperation.h"
#import "WMGoodDetailContainViewController.h"
#import "WMGoodInfo.h"

@interface WMQRCodeScanViewController ()<AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate,SeaHttpRequestDelegate>

/**二维码扫描背景
 */
@property(nonatomic,strong) WMQRCodeScanBackgroundView *scanBackgroundView;

//摄像头调用会话
@property (nonatomic, strong) AVCaptureSession *session;

//摄像头输入
@property (nonatomic, strong) AVCaptureDeviceInput *input;

//摄像头输出
@property (nonatomic, strong) AVCaptureMetadataOutput *output;

//摄像头图像预览
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;

//网络请求
@property (nonatomic, strong) SeaHttpRequest *httpRequest;

///商品productId
@property (nonatomic, copy) NSString *productId;

//当前解析的扫描结果
@property (nonatomic, copy) NSString *codeStringValue;

@end

@implementation WMQRCodeScanViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        self.hidesBottomBarWhenPushed = YES;
        self.title = @"扫码";
        self.type = WMCodeScaneTypeAll;
    }
    
    return self;
}

#pragma mark- 视图消失出现

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(self.session)
    {
        [_scanBackgroundView startScanAnimate];
        [self.session startRunning];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [_scanBackgroundView stopScanAnimate];
    [self.session stopRunning];
    
}

#pragma mark- 加载视图

- (void)back
{
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    
    [super back];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.httpRequest = [[SeaHttpRequest alloc] initWithDelegate:self];
    self.view.backgroundColor = [UIColor blackColor];
    self.backItem = YES;
    
    //添加二维码扫描背景
    _scanBackgroundView = [[WMQRCodeScanBackgroundView alloc] initWithFrame:CGRectMake(0, 0, _width_, self.contentHeight)];
    
    //检测摄像头授权状态
    if ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusDenied)
    {
        NSString *msg = [NSString stringWithFormat:@"无法使用您的相机，请在本机的“设置-隐私-相机”中设置,允许%@使用您的相机", appName()];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消", @"去设置", nil];
        [alertView show];
    }
    ///检测摄像头是否可用
    else if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"摄像头不可用" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    else
    {
        [self setupSession];
    }
    
   
    [self.view addSubview:_scanBackgroundView];
}

#pragma mark- http

/**获取商品productId
 */
- (void)loadProductIdFromBN:(NSString*) BN
{
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMGoodDetailOperation productIdFromBNParam:BN]];
}

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
    if(self.session)
    {
        [_scanBackgroundView startScanAnimate];
        [self.session startRunning];
    }
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{
    NSString *productId = [WMGoodDetailOperation productIdFromData:data];
     if(![NSString isEmpty:productId])
     {
         [self seeGoodDetail:productId];
     }
     else
     {
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"扫描结果" message:self.codeStringValue delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
         [alertView show];
     }
}

#pragma mark- UIALertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"去设置"])
    {
        openSystemSettings();
    }
    else if ([title isEqualToString:@"确定"])
    {
        if(self.session)
        {
            [_scanBackgroundView startScanAnimate];
            [self.session startRunning];
        }
    }
}

#pragma mark- 二维码扫描设置

//通过摄像头位置，获取可用的摄像头
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition) position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}

//获取前置摄像头
- (AVCaptureDevice *)frontFacingCamera
{
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}

//获取后置摄像头
- (AVCaptureDevice *)backFacingCamera
{
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}


//二维码扫描摄像头设置
- (void)setupSession
{
    //设置闪光灯为自动
    //更改这个设置的时候必须先锁定设备，修改完后再解锁，否则崩溃
//    if([[self backFacingCamera] lockForConfiguration:nil])
//    {
//        if([[self backFacingCamera] isFocusModeSupported:AVCaptureFocusModeAutoFocus])
//        {
//            [[self backFacingCamera] setFocusMode:AVCaptureFocusModeAutoFocus];
//        }
    
//        [[self backFacingCamera] unlockForConfiguration];
//    }
//    
//    if ([[self backFacingCamera] hasFlash]) {
//        if ([[self backFacingCamera] lockForConfiguration:nil]) {
//            if ([[self backFacingCamera] isFlashModeSupported:AVCaptureFlashModeOff]) {
//                [[self backFacingCamera] setFlashMode:AVCaptureFlashModeOff];
//            }
//            [[self backFacingCamera] unlockForConfiguration];
//        }
//    }
//    if ([[self backFacingCamera] hasTorch]) {
//        if ([[self backFacingCamera] lockForConfiguration:nil]) {
//            if ([[self backFacingCamera] isTorchModeSupported:AVCaptureTorchModeOff]) {
//                [[self backFacingCamera] setTorchMode:AVCaptureTorchModeOff];
//            }
//            [[self backFacingCamera] unlockForConfiguration];
//        }
//    }
    
    //初始化摄像头信息采集
    self.input = [[AVCaptureDeviceInput alloc] initWithDevice:[self backFacingCamera] error:nil];
    self.output = [[AVCaptureMetadataOutput alloc] init];
    
    CGRect rect = self.scanBackgroundView.scanBoxRect;
    
    //设置解析范围
    self.output.rectOfInterest = CGRectMake(rect.origin.y / _height_, rect.origin.x / _width_, rect.size.height / _height_, rect.size.width / _width_);

    dispatch_queue_t videoQueue = dispatch_queue_create("queue", NULL);
    [self.output setMetadataObjectsDelegate:self queue:videoQueue];
    
#if !OS_OBJECT_USE_OBJC
    dispatch_release(videoQueue);
#endif
    
    self.session = [[AVCaptureSession alloc] init];
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    }
    
    switch (self.type)
    {
        case WMCodeScaneTypeQRCode :
        {
            //设置可扫描的类型
            if ([self.output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
                self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
            }
        }
            break;
        case WMCodeScaneTypeBarCode :
        {
            NSMutableArray *types = [NSMutableArray array];
            NSArray *availableMetadataObjectTypes = self.output.availableMetadataObjectTypes;
            [types addObjectsFromArray:availableMetadataObjectTypes];
            [types removeObject:AVMetadataObjectTypeQRCode];
            
            self.output.metadataObjectTypes = types;
        }
        case WMCodeScaneTypeAll :
        {
            self.output.metadataObjectTypes = self.output.availableMetadataObjectTypes;
        }
            break;
    }
    
    
    
    //要判断是否支持，否则会蹦
    if([self.session canSetSessionPreset:AVCaptureSessionPreset1920x1080])
    {
        [self.session setSessionPreset:AVCaptureSessionPreset1920x1080];
    }
    else if([self.session canSetSessionPreset:AVCaptureSessionPresetHigh])
    {
        [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    }
    
    //图像图层
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    captureVideoPreviewLayer.frame = self.view.bounds;
    [captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    self.captureVideoPreviewLayer = captureVideoPreviewLayer;
    [self.view.layer addSublayer:captureVideoPreviewLayer];
}

#pragma mark - delegate

///判断类型
- (BOOL)isAVMetadataObjectAvailable:(AVMetadataObject*) obj
{
    switch (self.type)
    {
        case WMCodeScaneTypeBarCode :
        case WMCodeScaneTypeAll :
        {
            return [self.output.availableMetadataObjectTypes containsObject:obj.type];
        }
            break;
        case WMCodeScaneTypeQRCode :
        {
            return [[obj type] isEqualToString:AVMetadataObjectTypeQRCode];
        }
            break;
    }
    
    return NO;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    for (AVMetadataObject *object in metadataObjects)
    {
        if([object isKindOfClass:[AVMetadataMachineReadableCodeObject class]])
        {
            if ([self isAVMetadataObjectAvailable:object])
            {
                AVMetadataMachineReadableCodeObject *code = (AVMetadataMachineReadableCodeObject *)object;
                
                self.codeStringValue = code.stringValue;
                NSLog(@"%@", self.codeStringValue);
                
                if([object.type isEqualToString:AVMetadataObjectTypeQRCode])
                {
                    [self dealwithQRCodeResult:code.stringValue];
                }
                else
                {
                    dispatch_main_async_safe((^(void){
                        
                        [self.session stopRunning];
                        
                        if(self.codeScanHandler)
                        {
                            self.codeScanHandler(self.codeStringValue);
                            [self back];
                        }
                        else
                        {
                            [_scanBackgroundView stopScanAnimate];
                            [self loadProductIdFromBN:self.codeStringValue];
                        }
                    }));
                }
            }
        }
    }
}

///处理二维码扫描结果
- (void)dealwithQRCodeResult:(NSString*) reulst
{
    NSRange range = [reulst rangeOfString:SeaNetworkDomainName];
    if(range.location != NSNotFound)
    {
        NSString *pId = [WMGoodInfo productIdFromURL:reulst];
        if(pId != nil)
        {
            dispatch_main_async_safe(^(void){
                
                [self.session stopRunning];
                self.productId = pId;
                [self seeGoodDetail:self.productId];
            });
        }
    }
}

//查看商品详情
- (void)seeGoodDetail:(NSString*) productId
{
    WMGoodDetailContainViewController *detail = [[WMGoodDetailContainViewController alloc] init];
    detail.productID = productId;
    [self.navigationController pushViewController:detail animated:YES];
}

@end

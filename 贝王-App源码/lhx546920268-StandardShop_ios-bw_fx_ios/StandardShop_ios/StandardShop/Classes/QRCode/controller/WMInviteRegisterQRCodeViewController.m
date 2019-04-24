//
//  WMInviteRegisterQRCodeViewController.m
//  StandardShop
//
//  Created by 罗海雄 on 16/8/3.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMInviteRegisterQRCodeViewController.h"
#import "WMQRCodeOperation.h"
#import "WMShareActionSheet.h"

@interface WMInviteRegisterQRCodeViewController ()<SeaHttpRequestDelegate>

///网络请求
@property(nonatomic,strong) SeaHttpRequest *httpRequest;

///二维码链接
@property(nonatomic,copy) NSString *qrCodeURL;

@end

@implementation WMInviteRegisterQRCodeViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        self.hidesBottomBarWhenPushed = YES;
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(!self.title)
    {
        self.title = @"邀请注册";
    }
    
    self.backItem = YES;
    self.view.backgroundColor = _SeaViewControllerBackgroundColor_;
    self.white_bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.white_bgView.layer.borderWidth = 0.6;
    self.dash_view.dashesInterval = 2.0;
    self.dash_view.dashesLength = 3.0;
    
    [self caculateWidthBackgroundHeight];
    
    self.httpRequest = [[SeaHttpRequest alloc] initWithDelegate:self];
    
    [self reloadDataFromNetwork];
}



///分享
- (void)share
{
    UIImage *image = [UIImage imageFromView:self.white_bgView];
    
    image = [image aspectFitthumbnailWithSize:[image shrinkWithSize:CGSizeMake(190, 225) type:SeaImageShrinkTypeWidth]];
    
    WMShareActionSheet *share = [[WMShareActionSheet alloc] init];
    share.shareContentView.inviteRegisterImage = image;
    share.shareContentView.shareType = WMShareTypeInviteRegister;
    share.shareContentView.navigationController = self.navigationController;
    [share show];
}

/**
 *  计算白色背景高度
 */
- (void)caculateWidthBackgroundHeight
{
    CGSize size = [self.name_label.text stringSizeWithFont:self.name_label.font contraintWith:_width_ - 10.0 * 2];
    
    CGFloat height = 20.0 + MAX(21.0, size.height) + 5.0 + 21.0 + 15.0 + 1.0 + 15.0 + _width_ - 45.0 * 2 + 20.0;
    
    self.white_bgView_heightConstraint.constant = height;
}


#pragma mark- http

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
    [self failToLoadData];
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{
    self.loading = NO;
    self.qrCodeURL = [WMQRCodeOperation qrCodeResultFromData:data];
    [self.QRCode_imageView sea_setImageWithURL:self.qrCodeURL];
    [self setBarItemsWithTitle:nil icon:[UIImage imageNamed:@"share_icon"] action:@selector(share) position:SeaNavigationItemPositionRight];
}

///加载用户二维码
- (void)loadQRCode
{
    self.loading = YES;
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMQRCodeOperation qrCodeParamWithType:1]];
}

- (void)reloadDataFromNetwork
{
    [self loadQRCode];
}

@end

//
//  WMMyQRCodeViewController.m
//  AKYP
//
//  Created by 罗海雄 on 15/11/25.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMMyQRCodeViewController.h"
#import "WMQRCodeOperation.h"
#import <ShareSDK/ShareSDK.h>
#import "WMUserInfo.h"
#import "WXApi.h"
#import "WMShareActionSheet.h"
#import "WMGoodInfo.h"
#import "WMFoundListInfo.h"

@interface WMMyQRCodeViewController ()<SeaHttpRequestDelegate>

///网络请求
@property(nonatomic,strong) SeaHttpRequest *httpRequest;

///二维码链接
@property(nonatomic,copy) NSString *qrCodeURL;

@end

@implementation WMMyQRCodeViewController

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

    self.title = @"二维码";
    self.backItem = YES;
    self.view.backgroundColor = _SeaViewControllerBackgroundColor_;
    self.white_bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.white_bgView.layer.borderWidth = 0.6;
    self.dash_view.dashesInterval = 2.0;
    self.dash_view.dashesLength = 3.0;
    
    UIFont *font = [UIFont fontWithName:MainFontName size:15.0];
    self.weixin_timeline_title_label.font = font;
    self.save_title_label.font = font;
    self.weixin_friend_title_label.font = font;
    self.httpRequest = [[SeaHttpRequest alloc] initWithDelegate:self];
    

    switch (self.QRCodeType) {
        case WMMyQRCodeTypeAddPartner:
        {
            NSString *name = [NSString isEmpty:[WMUserInfo sharedUserInfo].name] ? [WMUserInfo sharedUserInfo].account : [WMUserInfo sharedUserInfo].name;
            
            self.name_label.text = [NSString stringWithFormat:@"%@邀请您成为会员", name];
        }
            break;
            
        default:
            break;
    }
    
    if(self.qrCodeURL)
    {
        [self.QRCode_imageView sea_setImageWithURL:self.qrCodeURL];
    }
    else
    {

        NSString *shareURL = nil;
        if(self.shareContentView)
        {
            WMShareActionSheetContentView *contentView = self.shareContentView;
            switch (contentView.shareType)
            {
                case WMShareTypeIntegralSignIn :
                {
                    self.name_label.text = @"注册 即可获得积分";
                }
                    break;
                case WMShareTypeCollectMoney :
                {
                    self.name_label.text = contentView.shareContent;
                }
                    break;
                default:
                {
                    self.name_label.text = contentView.shareTitle;
                }
                    break;
            }
            shareURL = contentView.shareURL;
        }
        else
        {
            shareURL = [WMUserInfo sharedUserInfo].personCenterInfo.addPartnerURL;
        }

        self.loading = NO;
        WeakSelf(self);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
           
            UIImage *image = [UIImage qrCodeImageWithString:shareURL correctionLevel:SeaQRCodeImageCorrectionLevelPercent7 size:CGSizeMake(100, 100) contentColor:[UIColor blackColor] backgroundColor:[UIColor whiteColor] logo:nil];
            dispatch_async(dispatch_get_main_queue(), ^(void){
               
                weakSelf.loading = NO;
                weakSelf.QRCode_imageView.image = image;
            });
            
        });
    }
    [self caculateWidthBackgroundHeight];
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

- (void)reloadDataFromNetwork
{
    [self loadQRCode];
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
}

///加载用户二维码
- (void)loadQRCode
{
    self.loading = YES;
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMQRCodeOperation qrCodeParamWithType:1]];
}

#pragma mark- 保存

///保存到手机
- (IBAction)saveToPhone:(id)sender
{
    self.showNetworkActivity = YES;
    self.requesting = YES;
    
    if(self.QRCode_imageView.image)
    {
        UIImage *image = [UIImage imageFromView:self.white_bgView];
        image = [image aspectFitthumbnailWithSize:[image shrinkWithSize:CGSizeMake(200, 568.0 - self.statusBarHeight - self.navigationBarHeight) type:SeaImageShrinkTypeWidth]];
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    }
    else
    {
        __weak WMMyQRCodeViewController *weakSelf = self;
        [[SeaImageCacheTool sharedInstance] getImageWithURL:self.qrCodeURL thumbnailSize:CGSizeZero completion:^(UIImage *image, BOOL fromNetwork)
        {
            if(image)
            {
                weakSelf.QRCode_imageView.image = image;
            }
            
            image = [UIImage imageFromView:weakSelf.white_bgView];
            image = [image aspectFitthumbnailWithSize:[image shrinkWithSize:CGSizeMake(200, 568.0 - self.statusBarHeight - self.navigationBarHeight) type:SeaImageShrinkTypeWidth]];
            UIImageWriteToSavedPhotosAlbum(image, weakSelf, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
            
        }target:self.QRCode_imageView];
    }
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    self.showNetworkActivity = NO;
    self.requesting = NO;
    
    NSString *message = @"保存失败";
    if (!error)
    {
        message = @"成功保存到相册";
        [self alertMsg:message];
    }
    else
    {
        [self alertMsg:message];
    }
    
}

#pragma mark- share

///分享到微信朋友圈
- (IBAction)shareToWeixinTimeline:(id)sender
{
    [self simplyShareWithType:SSDKPlatformSubTypeWechatTimeline];
}

///分享给微信好友
- (IBAction)shareToWeixinFriend:(id)sender
{
    [self simplyShareWithType:SSDKPlatformSubTypeWechatSession];
}

/**
 *  简单分享
 */
- (void)simplyShareWithType:(SSDKPlatformType) type
{
    if(![WXApi isWXAppInstalled])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"尚未安装微信客户端，无法分享到微信" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        
        return;
    }
    
    /**
     * 在简单分享中，只要设置共有分享参数即可分享到任意的社交平台
     **/
    
    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    self.showNetworkActivity = YES;
    self.requesting = YES;
    
    UIImage *image = [UIImage imageFromView:self.white_bgView];
    
    image = [image aspectFitthumbnailWithSize:[image shrinkWithSize:CGSizeMake(190, 225) type:SeaImageShrinkTypeWidth]];
    
    [shareParams SSDKSetupShareParamsByText:[WMUserInfo sharedUserInfo].name
                                     images:image
                                        url:nil
                                      title:appName()
                                       type:SSDKContentTypeAuto];

    __weak WMMyQRCodeViewController *weakSelf = self;
    
    //NSLog(@"%@", shareParams);
    
    
    //进行分享
    [ShareSDK share:type
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error)
     {
         
         weakSelf.showNetworkActivity = NO;
         weakSelf.requesting = NO;
         
         switch (state)
         {
             case SSDKResponseStateSuccess:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             case SSDKResponseStateFail:
             {

                 NSLog(@"%@",error);
                 break;
             }
             default:
                 break;
         }
         
     }];
}

@end

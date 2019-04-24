//
//  WMMyQRCodeViewController.m
//  AKYP
//
//  Created by 罗海雄 on 15/11/25.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMPartnerInviteQRCodeViewController.h"
#import "WMQRCodeOperation.h"
#import <ShareSDK/ShareSDK.h>
#import "WMUserInfo.h"
#import "WXApi.h"
#import "WMShareActionSheet.h"
#import "WMGoodInfo.h"
#import "WMFoundListInfo.h"

@interface WMPartnerInviteQRCodeViewController ()

@end

@implementation WMPartnerInviteQRCodeViewController

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
    
    self.title = @"邀请二维码";
    self.backItem = YES;
    self.view.backgroundColor = _SeaViewControllerBackgroundColor_;
    
    UIFont *font = [UIFont fontWithName:MainFontName size:15.0];
    self.weixin_timeline_title_label.font = font;
    self.save_title_label.font = font;
    self.weixin_friend_title_label.font = font;
    
        
        NSString *shareURL = [WMUserInfo sharedUserInfo].personCenterInfo.addPartnerURL;;

    
        
        self.loading = NO;
        WeakSelf(self);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            
            UIImage *image = [UIImage qrCodeImageWithString:shareURL correctionLevel:SeaQRCodeImageCorrectionLevelPercent7 size:CGSizeMake(100, 100) contentColor:[UIColor blackColor] backgroundColor:[UIColor whiteColor] logo:nil];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                
                weakSelf.loading = NO;
                weakSelf.QRCode_imageView.image = image;
            });
            
        });
    
    NSString *name = [WMUserInfo sharedUserInfo].name;
    if([NSString isEmpty:name])
    {
        name = [WMUserInfo sharedUserInfo].account;
    }
    self.title_label.font = [UIFont boldSystemFontOfSize:16.0];
    self.title_label.text = [NSString stringWithFormat:@"我是%@", name];
    self.title_label.textColor = [UIColor colorFromHexadecimal:@"ff9000"];
    self.subtitle_label.textColor = [UIColor colorFromHexadecimal:@"5a5a5a"];
    
    self.title_label_leftLayoutConstraint.constant = 65.0 * _width_ / 320.0;
    self.title_label_rightLayoutConstraint.constant = 120.0 * _width_ / 320.0;
}


#pragma mark- 保存

///保存到手机
- (IBAction)saveToPhone:(id)sender
{
    self.showNetworkActivity = YES;
    self.requesting = YES;
    
    UIImage *image = [UIImage imageFromView:self.white_bgView];
    image = [image aspectFitthumbnailWithSize:[image shrinkWithSize:CGSizeMake(200, 568.0 - self.statusBarHeight - self.navigationBarHeight) type:SeaImageShrinkTypeWidth]];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
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
    
    __weak WMPartnerInviteQRCodeViewController *weakSelf = self;
    
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

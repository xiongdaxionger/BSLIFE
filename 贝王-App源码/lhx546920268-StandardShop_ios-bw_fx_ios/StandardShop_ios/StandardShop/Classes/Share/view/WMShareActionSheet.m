//
//  WMShareActionSheet.m
//  WestMailDutyFee
//
//  Created by 罗海雄 on 15/8/28.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMShareActionSheet.h"
#import <MessageUI/MessageUI.h>
#import <ShareSDK/ShareSDK.h>
#import "WMUserInfo.h"
#import "WMGoodInfo.h"
#import "WMAboutMeInfo.h"
#import "WMIntegralSignInInfo.h"
#import "WMFoundListInfo.h"
#import "WMMyQRCodeViewController.h"
#import "WMDistributionInfo.h"
#import "WMCollegeInfo.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WMCollectMoneyInfo.h"
#import "WMInviteRegisterQRCodeViewController.h"

/**起始tag
 */
#define WMShareActionSheetCellStartTag 1500

@implementation WMShareActionSheetCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        CGFloat imageSize = 42.0;
        CGFloat titleHeight = 20.0;
        CGFloat interval = 5.0;
        CGFloat margin = (frame.size.height - imageSize - titleHeight - interval) / 2.0;
        
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width - imageSize) / 2.0, margin, imageSize, imageSize)];
        _iconImageView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:_iconImageView];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _iconImageView.bottom + interval, frame.size.width, titleHeight)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont fontWithName:MainFontName size:12.0];
        _titleLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_titleLabel];
    }
    
    return self;
}

@end

@interface WMShareActionSheetContentView()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

///集合视图
@property(nonatomic,strong) UICollectionView *collectionView;

///图标 数组元素是 NSString
@property(nonatomic,strong) NSMutableArray *icons;

///标题 数组元素是 NSString
@property(nonatomic,strong) NSMutableArray *titles;

///当前选择的分享类型
@property(nonatomic,assign) WMShareWay selectedShareWay;

@end

@implementation WMShareActionSheetContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self initialization];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        self.width = _width_;
        [self initialization];
    }
    return self;
}

//初始化
- (void)initialization
{
    _titleFont = [UIFont fontWithName:MainFontName size:[UIScreen mainScreen].scale == 3.0 ? 16.0 : 15.0];
    self.titles = [NSMutableArray arrayWithObjects:@"微信", @"朋友圈", @"QQ", @"QQ空间", @"微博", @"发短信", @"复制链接", @"生成二维码", nil];
    self.icons = [NSMutableArray arrayWithObjects:@"share_weixin_friend", @"share_weixin_timeline", @"share_qq", @"share_qq_zone", @"share_sina", @"share_send_msg", @"share_copy_link", @"share_qrcode",nil];

    [self layoutContentView];
}

///重新计算视图
- (void)layoutContentView
{
    NSInteger countPerRow = 4;
    
    NSInteger row = self.titles.count == 0 ? 0 : (self.titles.count - 1) / countPerRow + 1;
    
    CGFloat width = self.width / countPerRow;
    CGFloat height = width;
    
    CGFloat margin = 0;
    
    if(!self.collectionView)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.itemSize = CGSizeMake(width, height);
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, margin, _width_, 0) collectionViewLayout:layout];
        [self.collectionView registerClass:[WMShareActionSheetCell class] forCellWithReuseIdentifier:@"WMShareActionSheetCell"];
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.showsVerticalScrollIndicator = NO;
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        [self addSubview:self.collectionView];
    }
    
    self.collectionView.height = height * row + (row - 1) * margin;
    self.height = self.collectionView.bottom + margin * 2;
}

- (void)setShareType:(WMShareType)shareType
{
    if(_shareType != shareType)
    {
        _shareType = shareType;
        switch (_shareType) {
            case WMShareTypeInviteRegister :
            {
                [self.titles removeLastObject];
                [self.icons removeLastObject];
                [self layoutContentView];
                [self.collectionView reloadData];
            }
                break;
                
            default:
                break;
        }
    }
}

#pragma mark- UICollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = MIN(self.titles.count, self.icons.count);
    if(count % 4 != 0)
    {
        NSInteger i = count % 4;
        count += 4 - i;
    }
    
    return count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WMShareActionSheetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WMShareActionSheetCell" forIndexPath:indexPath];
    
    if(indexPath.item < self.titles.count && indexPath.item < self.icons.count)
    {
        cell.iconImageView.image = [UIImage imageNamed:[self.icons objectAtIndex:indexPath.item]];
        cell.titleLabel.text = [self.titles objectAtIndex:indexPath.item];
        cell.iconImageView.hidden = NO;
        cell.titleLabel.hidden = NO;
    }
    else
    {
        cell.iconImageView.hidden = YES;
        cell.titleLabel.hidden = YES;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    NSInteger index = indexPath.item;
    if(index >= self.icons.count || index >= self.titles.count)
        return;
    
    self.selectedShareWay = index;
    switch (index)
    {
        case WMShareWayWeixin :
        {
            [self simplyShareWithType:SSDKPlatformSubTypeWechatSession];
        }
            break;
        case WMShareWayWeixinTimeline :
        {
            [self simplyShareWithType:SSDKPlatformSubTypeWechatTimeline];
        }
            break;
        case WMShareWayQQ :
        {
            [self simplyShareWithType:SSDKPlatformSubTypeQQFriend];
        }
            break;
        case WMShareWayQQZone :
        {
            [self simplyShareWithType:SSDKPlatformSubTypeQZone];
        }
            break;
        case WMShareWaySina :
        {
            [self simplyShareWithType:SSDKPlatformTypeSinaWeibo];
        }
            break;
        case WMShareWayQRCode :
        {
            WMMyQRCodeViewController *qrCode = [[WMMyQRCodeViewController alloc] init];
            qrCode.QRCodeType = WMMyQRCodeTypeShare;
            qrCode.shareContentView = self;
                
            [self.navigationController pushViewController:qrCode animated:YES];
        }
            break;
        case WMShareWayCopyLink :
        {
            NSString *url = self.shareURL;
            if(url != nil)
            {
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = url;
                
                AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                [delegate alertMsg:@"复制成功"];
            }
        }
            break;
        case WMShareWaySendShortMsg :
        {
            [self sendShortMsg];
        }
            break;
    }
    
    if(self.didShareHandler)
    {
        self.didShareHandler(index);
    }
}


/**分享链接
 */
- (NSString*)shareURL
{
    if(![NSString isEmpty:_shareURL])
        return _shareURL;
    switch (self.shareType)
    {
        case WMShareTypeGoodH5 :
        {
            return self.goodInfo.shareURL;
        }
            break;
        case WMShareTypeIntegralSignIn :
        {
            return self.integralSignInInfo.shareURL;
        }
            break;
        case WMShareTypeFound :
        {
            return self.foundListInfo.URL;
        }
            break;
        case WMShareTypePromote :
        {
            return self.distributionInfo.shareURL;
        }
            break;
        case WMShareTypeCollege :
        {
            return self.collegeInfo.detailUrl;
        }
            break;
        case WMShareTypeCollectMoney :
        {
            return self.collectMoneyInfo.shareURL;
        }
            break;
        case WMShareTypeInviteRegister :
        {
            return nil;
        }
            break;
        case WMShareTypeAddPartner :
        {
            return [WMUserInfo sharedUserInfo].personCenterInfo.addPartnerURL;
        }
            break;
    }
    
    return nil;
}

- (NSString*)shareTitle
{
    NSString *title = @"";
    if(![NSString isEmpty:_shareTitle])
        title = _shareTitle;
    
    else
    {
        switch (self.shareType)
        {
            case WMShareTypeGoodH5 :
            {
                title = self.goodInfo.goodName;
            }
                break;
            case WMShareTypeIntegralSignIn :
            {
                title = appName();
            }
                break;
            case WMShareTypeFound :
            {
                title = self.foundListInfo.title;
            }
                break;
            case WMShareTypePromote :
            {
                title = appName();
            }
                break;
            case WMShareTypeCollege :
            {
                title = self.collegeInfo.title;
            }
                break;
            case WMShareTypeInviteRegister :
            {
                return appName();
            }
                break;
            case WMShareTypeCollectMoney :
            {
                return appName();
            }
                break;
            case WMShareTypeAddPartner :
            {
                switch (self.selectedShareWay)
                {
                    case WMShareWayQRCode :
                    {
                        return self.shareContent;
                    }
                        break;
                    default:
                    {
                        return appName();
                    }
                        break;
                }
            }
                break;
        }
    }
    
    title = [[title stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\r" withString:@""];

    return title;
}

- (NSString*)shareContent
{
    
    NSString *content = @"";
    if(![NSString isEmpty:_shareContent])
        content = _shareContent;
    else
    {
        switch (self.shareType)
        {
            case WMShareTypeGoodH5 :
            {
                content = self.goodInfo.brief;
            }
                break;
                
            case WMShareTypeIntegralSignIn :
            {
                content = @"这款应用真是太棒了";
            }
                break;
            case WMShareTypeFound :
            {
                content = self.foundListInfo.content;
            }
                break;
            case WMShareTypePromote :
            {
                content = @"这款应用真是太棒了";
            }
                break;
            case WMShareTypeCollege :
            {
                NSString *text = self.collegeInfo.detailInfo.detailContent;
                if([NSString isEmpty:text])
                    text = self.collegeInfo.introduction;
                
                if(text.length > 100)
                {
                    text = [text substringToIndex:100];
                }
                content = text;
            }
                break;
            case WMShareTypeCollectMoney :
            {
                return self.collectMoneyInfo.name;
            }
                break;
            case WMShareTypeInviteRegister :
            {
                return nil;
            }
                break;
            case WMShareTypeAddPartner :
            {
                NSString *name = [NSString isEmpty:[WMUserInfo sharedUserInfo].name] ? [WMUserInfo sharedUserInfo].account : [WMUserInfo sharedUserInfo].name;
                
                return [NSString stringWithFormat:@"%@邀请您成为会员", name];
            }
                break;
        }
    }
    
    
    content = [[content stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\r" withString:@""];

    return content;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  简单分享
 */
- (void)simplyShareWithType:(SSDKPlatformType) type
{
    if(type == SSDKPlatformSubTypeQZone || type == SSDKPlatformSubTypeQQFriend)
    {
        if(![TencentOAuth iphoneQQInstalled] && ![TencentOAuth iphoneQZoneInstalled])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"尚未安装QQ或QQ空间客户端，无法分享到QQ" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
            return;
        }
    }
    else if (type == SSDKPlatformSubTypeWechatSession || type == SSDKPlatformSubTypeWechatTimeline)
    {
        if(![WXApi isWXAppInstalled])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"尚未安装微信客户端，无法分享到微信" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
            
            return;
        }
    }
    
    
    /**
     * 在简单分享中，只要设置共有分享参数即可分享到任意的社交平台
     **/
    
    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.showNetworkActivity = YES;
    appDelegate.shareActionSheet = self;
    
    /**
     *  监听app状态
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    //WMUserInfo *userInfo = [WMUserInfo sharedUserInfo];
    
    CGSize imageSize = CGSizeMake(100, 100);
    switch (self.shareType)
    {
        case WMShareTypeGoodH5 :
        {
            NSString *url = self.goodInfo.imageURL;
            
            if([url isKindOfClass:[NSURL class]])
            {
                url = [(NSURL*)url absoluteString];
            }
            
            id image = [[SeaImageCacheTool sharedInstance] imageFromMemoryWithURL:url thumbnailSize:imageSize];
            if(image == nil)
            {
                image = [[SeaImageCacheTool sharedInstance] imageFromCacheWithURL:url thumbnailSize:imageSize];
            }

            NSString *text = self.shareContent;
            if(type == SSDKPlatformTypeSinaWeibo)
            {
                text = [NSString stringWithFormat:@"%@，点击查看%@", text, self.shareURL];
            }
            
            [shareParams SSDKSetupShareParamsByText:text
                                             images:image == nil ? url : image
                                                url:[NSURL URLWithString:self.shareURL]
                                              title:self.shareTitle
                                               type:type != SSDKPlatformTypeSinaWeibo ? SSDKContentTypeWebPage : SSDKContentTypeAuto];
            
        }
            break;
        case WMShareTypeIntegralSignIn :
        case WMShareTypePromote :
        {
            NSString *text = self.shareContent;
            if(type == SSDKPlatformTypeSinaWeibo)
            {
                text = [NSString stringWithFormat:@"%@，点击查看%@", text, self.shareURL];
            }
            [shareParams SSDKSetupShareParamsByText:text
                                             images:appIcon()
                                                url:[NSURL URLWithString:self.shareURL]
                                              title:self.shareTitle
                                               type:type != SSDKPlatformTypeSinaWeibo ? SSDKContentTypeWebPage : SSDKContentTypeAuto];
        }
            break;
        case WMShareTypeFound :
        {
            NSString *text = self.shareContent;

            if(type == SSDKPlatformTypeSinaWeibo)
            {
                text = [NSString stringWithFormat:@"%@，点击查看%@", text, self.shareURL];
            }

            NSString *url = self.foundListInfo.imageURL;

            if(!url)
            {
                url = self.foundListInfo.smallImageURL;
            }
            
            id image;
            if(url)
            {
                if([url isKindOfClass:[NSURL class]])
                {
                    url = [(NSURL*)url absoluteString];
                }
                
                image = [[SeaImageCacheTool sharedInstance] imageFromMemoryWithURL:url thumbnailSize:imageSize];
                if(image == nil)
                {
                    image = [[SeaImageCacheTool sharedInstance] imageFromCacheWithURL:url thumbnailSize:imageSize];
                }
            }
            else
            {
                image = appIcon();
            }

            [shareParams SSDKSetupShareParamsByText:text
                                             images:image == nil ? url : image
                                                url:[NSURL URLWithString:self.shareURL]
                                              title:self.shareTitle
                                               type:type != SSDKPlatformTypeSinaWeibo ? SSDKContentTypeWebPage : SSDKContentTypeAuto];
        }
            break;
        case WMShareTypeCollege :
        {
            NSString *url = self.collegeInfo.iamgeUrlString;
            if([url isKindOfClass:[NSURL class]])
            {
                url = [(NSURL*)url absoluteString];
            }
            else if ([NSString isEmpty:url])
            {
                url = [self.collegeInfo.detailInfo.images firstObject];
            }

            id image = [[SeaImageCacheTool sharedInstance] imageFromMemoryWithURL:url thumbnailSize:imageSize];
            if(image == nil)
            {
                image = [[SeaImageCacheTool sharedInstance] imageFromCacheWithURL:url thumbnailSize:imageSize];
            }

            [shareParams SSDKSetupShareParamsByText:self.shareContent
                                             images:image == nil ? url : image
                                                url:[NSURL URLWithString:self.shareURL]
                                              title:type == SSDKPlatformSubTypeWechatTimeline ? self.shareTitle : appName()
                                               type:type != SSDKPlatformTypeSinaWeibo ? SSDKContentTypeWebPage : SSDKContentTypeAuto];
        }
            break;
        case WMShareTypeInviteRegister :
        {
            [shareParams SSDKSetupShareParamsByText:type == SSDKPlatformTypeSinaWeibo ? appName() : nil
                                             images:self.inviteRegisterImage
                                                url:nil
                                              title:nil
                                               type:SSDKContentTypeAuto];
        }
            break;
        case WMShareTypeCollectMoney :
        {
            [shareParams SSDKSetupShareParamsByText:self.shareContent
                                             images:appIcon()
                                                url:[NSURL URLWithString:self.shareURL]
                                              title:self.shareTitle
                                               type:SSDKContentTypeAuto];
        }
            break;
        case WMShareTypeAddPartner :
        {
            [shareParams SSDKSetupShareParamsByText:self.shareContent
                                             images:appIcon()
                                                url:[NSURL URLWithString:self.shareURL]
                                              title:self.shareTitle
                                               type:SSDKContentTypeAuto];
        }
    }
    
    NSLog(@"%@", shareParams);
    
    //进行分享
    [ShareSDK share:type
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         
         appDelegate.showNetworkActivity = NO;
         appDelegate.shareActionSheet = nil;
         
         switch (state) {
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
//                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                     message:nil
//                                                                    delegate:nil
//                                                           cancelButtonTitle:@"确定"
//                                                           otherButtonTitles:nil];
//                 [alertView show];
                 
                 NSLog(@"%@", [NSString stringWithFormat:@"%@", error]);
                 break;
             }
             case SSDKResponseStateCancel:
             {
//                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
//                                                                     message:nil
//                                                                    delegate:nil
//                                                           cancelButtonTitle:@"确定"
//                                                           otherButtonTitles:nil];
//                 [alertView show];
                 break;
             }
             default:
                 break;
         }
         
     }];
}

#pragma mark- 通知

- (void)applicationDidBecomeActive:(NSNotification*) notification
{
    [AppDelegate instance].showNetworkActivity = NO;
    [AppDelegate instance].shareActionSheet = nil;
}

#pragma mark- 短信

//发送短信邀请
- (void)sendShortMsg
{
    if(![MFMessageComposeViewController canSendText])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"该设备不支持发送短信" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else
    {
        MFMessageComposeViewController *msgVC = [[MFMessageComposeViewController alloc] init];
        
        NSString *body = nil;
        switch (self.shareType)
        {
            case WMShareTypeFound :
            {
                body = [NSString stringWithFormat:@"%@，%@", self.shareTitle, self.shareURL];
            }
                break;
            case WMShareTypeGoodH5 :
            {
                body = [NSString stringWithFormat:@"%@，%@", self.shareTitle, self.shareURL];
            }
                break;
            default:
            {
                 body = [NSString stringWithFormat:@"%@，%@", self.shareContent, self.shareURL];
            }
                break;
        }
        
        AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        msgVC.messageComposeDelegate = delegate;
        msgVC.body = body;
        [[AppDelegate rootViewController] presentViewController:msgVC animated:YES completion:nil];
    }
}


@end

@interface WMShareActionSheet ()<UIAlertViewDelegate>

/**黑色半透明背景视图
 */
@property(nonatomic,strong) UIView *blackView;

/**用于点击的视图
 */
@property(nonatomic,strong) UIView *tapView;

/**白色背景内容视图
 */
@property(nonatomic,strong) UIView *contentView;

@end

@implementation WMShareActionSheet

- (id)init
{
    return [self initWithFrame:CGRectMake(0, 0, _width_, _height_)];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self initialization];
    }
    
    return self;
}


///取消分享
- (void)cancelShare
{
    _blackView.userInteractionEnabled = NO;
    [UIView animateWithDuration:_animatedDuration_ animations:^(void){
        
        _blackView.alpha = 0;
        _contentView.top = _height_;
    }completion:^(BOOL finish){
        
        [self removeFromSuperview];
    }];
}

/**显示
 */
- (void)show
{
    [[AppDelegate instance].window addSubview:self];
    [UIView animateWithDuration:_animatedDuration_ animations:^(void){
        
        _blackView.alpha = 1.0;
        _contentView.top = _height_ - _contentView.height;
    }];
}


///创建
- (void)initialization
{
    if(!_shareContentView)
    {
        _blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, _height_)];
        _blackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _blackView.alpha = 0;
        
        [self addSubview:_blackView];
        
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        
        __weak WMShareActionSheet *weakSelf = self;
        _shareContentView = [[WMShareActionSheetContentView alloc] initWithFrame:CGRectMake(0, 0, _width_, 0)];
        _shareContentView.didShareHandler = ^(NSInteger index){
            
            [weakSelf cancelShare];
        };
        [_contentView addSubview:_shareContentView];
        
        CGFloat margin = 15.0;
        CGFloat buttonHeight = 45.0;
        
        CGFloat contentHeight = _shareContentView.bottom + 20.0 + margin + buttonHeight;
        _contentView.frame = CGRectMake(0, _height_, self.width, contentHeight);
        [self addSubview:_contentView];
        
        //取消按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
      //  [btn setBackgroundColor:[UIColor colorFromHexadecimal:@"8F8F8F"]];
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(cancelShare) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(margin, contentHeight - margin - buttonHeight, self.width - margin * 2, buttonHeight);
        btn.layer.cornerRadius = 5.0;
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        btn.layer.borderWidth = 1.0;
        [_contentView addSubview:btn];
        
        _tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, _height_ - contentHeight)];
        _tapView.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelShare)];
        [_tapView addGestureRecognizer:tap];
        
        [self addSubview:_tapView];
    }
}


@end

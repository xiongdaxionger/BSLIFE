//
//  WMCollegeDetailViewController.m
//  WestMailDutyFee
//
//  Created by 罗海雄 on 15/10/19.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMCollegeDetailViewController.h"
#import "WMCollegeInfo.h"
#import "WMCollegeOperation.h"
#import "WMShareActionSheet.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/ImageIO.h>

@interface WMCollegeDetailViewController ()<SeaHttpRequestDelegate>

///网络请求
@property(nonatomic,strong) SeaHttpRequest *httpRequest;

///学院信息
@property(nonatomic,strong) WMCollegeInfo *info;

///已保存到相册的数量
@property(nonatomic,assign) int countDidSave;


@end

@implementation WMCollegeDetailViewController

/**通过学院信息初始化
 *@param info 学院信息
 *@return 一个实例
 */
- (id)initWithInfo:(WMCollegeInfo*) info
{
    self = [super initWithNibName:nil bundle:nil];
    if(self)
    {
        self.loadWebContentWhileViewDidLoad = NO;
        self.info = info;
        self.title = @"详情";
    }
    
    return self;
}

#pragma mark- http

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
    [self failToLoadData];
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{
    self.loading = NO;
    if(self.info.detailUrl)
    {
        WMCollegeDetailInfo *info = [[WMCollegeDetailInfo alloc] init];
        info.htmlDetail = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        self.info.detailInfo = info;
    }
    else
    {
        self.adjustScreenWhenLoadHtmlString = YES;
        self.info.detailInfo = [WMCollegeOperation collegeDetailFromData:data];
    }
  
    
   // NSLog(@"%@", self.info.detailInfo.htmlDetail);
    [self loadCollegeWebContent];
}

#pragma mark- 加载视图

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.backItem = YES;
    

//    self.URL = [NSURL URLWithString:self.info.detailUrl];
//    [self loadWebContent];
    if(!self.info.detailInfo)
    {
        self.httpRequest = [[SeaHttpRequest alloc] initWithDelegate:self];
        [self reloadDataFromNetwork];
    }
    else
    {
        [self loadCollegeWebContent];
    }
}

///加载学院详情
- (void)reloadDataFromNetwork
{
     self.loading = YES;
    if(self.info.detailUrl)
    {
        [self.httpRequest downloadWithURL:self.info.detailUrl];
    }
    else
    {
        [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMCollegeOperation collegeDetailParamWithInfo:self.info]];
    }
}

///加载学院web
- (void)loadCollegeWebContent
{
    self.htmlString = self.info.detailInfo.htmlDetail;
    if([self isMemberOfClass:[WMCollegeDetailViewController class]])
    {
        [self setBarItemsWithTitle:nil icon:[UIImage imageNamed:@"share_black"] action:@selector(share) position:SeaNavigationItemPositionRight];
    }
    [self loadWebContent];
}


#pragma mark- 分享

///分享
- (void)share
{
    [self oneKeyShare];
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"多图分享", @"一键分享", nil];
//    [actionSheet showInView:self.view];
}

///一件分享
- (void)oneKeyShare
{
    [self getHtmlText];
    WMShareActionSheet *share = [[WMShareActionSheet alloc] init];
    share.shareContentView.shareType = WMShareTypeCollege;
    share.shareContentView.collegeInfo = self.info;
    share.shareContentView.navigationController = self.navigationController;
    [share show];
}

///多图分享
- (void)multiImageShare
{
    if(![NSString isEmpty:self.info.detailInfo.detailContent])
    {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.info.detailInfo.detailContent;
    }
    
    ///下载图片保存相册
    if(self.info.detailInfo.images.count > 0 && self.countDidSave != self.info.detailInfo.images.count)
    {
        self.requesting = YES;
        self.showNetworkActivity = YES;
        self.countDidSave = 0;
        SeaImageCacheTool *tool = [SeaImageCacheTool sharedInstance];
        WeakSelf(self);
        
        NSArray *urls = weakSelf.info.detailInfo.images;
        for(NSString *url in urls)
        {
            [tool getImageWithURL:url thumbnailSize:CGSizeZero completion:^(UIImage *image, BOOL fromNetwork){
                
                if(image)
                {
                    [weakSelf saveToAlbumWithImage:image];
                }
            }target:nil];
        }
    }
    else
    {
        [self alertSharedMsg];
    }
}

///提示分享信息
- (void)alertSharedMsg
{
    NSString *msg = nil;
    if(self.countDidSave == 0)
    {
        msg = @"内容已复制到粘贴板";
    }
    else
    {
        msg = [NSString stringWithFormat:@"%d图片已保存到相册\n内容已复制到粘贴板", self.countDidSave];
    }
    
    [self alertMsg:msg];
    [self performSelector:@selector(openWeixin) withObject:nil afterDelay:1.0];
}

///打开微信
- (void)openWeixin
{
   // [WXApi openWXApp];
}

///解析html内容，获取图片和文本内容
- (void)parseHtml
{
    self.requesting = YES;
    self.showNetworkActivity = YES;
    
    WeakSelf(self);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){

        //NSString *html = weakSelf.info.detailInfo.htmlDetail;
       // weakSelf.info.detailInfo.images = [HtmlParseOperation analyticalImageFromHtmlString:html count:9];
        [weakSelf getHtmlText];
        [weakSelf multiImageShare];
    });
}

///获取文本内容
- (void)getHtmlText
{
    if(!self.info.detailInfo.detailContent)
    {
        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:[self.info.detailInfo.htmlDetail dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        self.info.detailInfo.detailContent = attrStr.string;
    }
}

#pragma mark- 保存图片

///保存图片到相册
- (void)saveToAlbumWithImage:(UIImage*) image
{
    ALAssetsLibrary *library = [SeaAlbumAssetsViewController sharedAssetsLibrary];
    WeakSelf(self);
    
    [library writeImageToSavedPhotosAlbum:image.CGImage metadata:nil completionBlock:^(NSURL *url, NSError *error){
       
        if(error)
        {
            NSLog(@"保存图片出错 %@", error);
        }
        weakSelf.countDidSave ++;
        if(weakSelf.countDidSave == weakSelf.info.detailInfo.images.count)
        {
            weakSelf.requesting = NO;
            weakSelf.showNetworkActivity = NO;
            [weakSelf alertSharedMsg];
        }
    }];
}

#pragma mark- UIActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0 :
        {
            if(!self.info.detailInfo.images)
            {
                [self parseHtml];
            }
            else
            {
                [self multiImageShare];
            }
        }
            break;
        case 1 :
        {
            [self oneKeyShare];
        }
            break;
        default:
            break;
    }
}

@end

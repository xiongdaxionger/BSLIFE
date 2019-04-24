//
//  WMShakeViewController.m
//  WanShoes
//
//  Created by 罗海雄 on 16/3/16.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "WMShakeViewController.h"
#import "WMShakingDialog.h"
#import "WMShakeResultCharacterDialog.h"
#import "WMShakeTomorrowDialog.h"
#import "WMShakeResultCouponsDialog.h"
#import "WMCouponsListViewController.h"
#import "WMShakeRuleViewController.h"
#import "WMShakeOperation.h"
#import "WMShakeInfo.h"
#import "WMShakeResultInfo.h"
#import "SeaSystemSound.h"
#import <CoreMotion/CoreMotion.h>
#import "WMShakeWinnerView.h"

@interface WMShakeViewController ()<SeaHttpRequestDelegate,CAAnimationDelegate>

///网络请求
@property(nonatomic,strong) SeaHttpRequest *httpRequest;

///是否需要监听摇动
@property(nonatomic,assign) BOOL needNotifyShake;

///人品加1弹窗
@property(nonatomic,strong) WMShakeResultCharacterDialog *characterDialog;

///正在摇弹窗
@property(nonatomic,strong) WMShakingDialog *shakingDialog;

///明日再战弹窗
@property(nonatomic,strong) WMShakeTomorrowDialog *tomorrowDialog;

///摇中优惠券弹窗
@property(nonatomic,strong) WMShakeResultCouponsDialog *couponsDialog;

///弹窗背景
@property(nonatomic,strong) UIView *dialogBackgroundView;

///摇一摇信息
@property(nonatomic,strong) WMShakeInfo *shakeInfo;

///摇一摇结果
@property(nonatomic,strong) WMShakeResultInfo *shakeResultInfo;

///是否需要处理摇一摇结果，用于动画结束之前已经获取摇一摇结果
@property(nonatomic,assign) BOOL needProcessShakeResult;

///是否正在进行摇一摇动画
@property(nonatomic,assign) BOOL shaking;

///加速器管理
@property(nonatomic,strong) CMMotionManager *motionManager;

///进入后台前是否允许摇一摇
@property(nonatomic,assign) BOOL enableShakeWhenEnterBackground;

///获奖名单 数组元素是 WMShakeWinnerInfo
@property(nonatomic,strong) NSMutableArray *winners;

///获奖名单总数
@property(nonatomic,assign) long long totalSize;

///获奖名单当前页码
@property(nonatomic,assign) int curPage;

@end

@implementation WMShakeViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

- (void)dealloc
{
   // [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:NO];
    [self.winner_view stopTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.logo_btn.hidden = YES;
    self.curPage = WMHttpPageIndexStartingValue;
    self.winners = [NSMutableArray array];
    self.view.backgroundColor = WMRedColor;
    self.title = @"摇一摇";
    self.backItem = YES;
    self.status_label.font = [UIFont fontWithName:MainFontName size:20.0];
    self.status_bg_view.layer.cornerRadius = 15.0;
    self.status_bg_view.layer.masksToBounds = YES;

    ///小屏设备调整UI位置
    if(is3_5Inch)
    {
        self.logo_btn_topLayoutConstraint.constant = 15.0;
        self.compass_imageView_widthLayoutConstraint.constant = 270.0;
        self.title_label.font = [UIFont boldSystemFontOfSize:40.0];
        self.subtitle_label.font = [UIFont boldSystemFontOfSize:20.0];
    }
    else
    {
        self.compass_imageView_widthLayoutConstraint.constant = MIN(_width_ - 20.0, 322.0);
    }

    ///设置锚点，使摇晃的中心位置变化
    self.person_imageView.layer.anchorPoint = CGPointMake(0.5, 1.0);
    ///由于设置了锚点，约束要重新设置
    self.person_imageView_centerYLayoutConstraint.constant = self.compass_imageView_widthLayoutConstraint.constant * 213.0 / 322.0 / 2.0;
    
    ///ipad 不支持
 //   [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
    
    self.motionManager = [[CMMotionManager alloc] init];//一般在viewDidLoad中进行
    self.motionManager.accelerometerUpdateInterval = .1;//加速仪更新频率，以秒为单位
    if(![self.motionManager isAccelerometerAvailable])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"该设备不支持摇一摇" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        self.motionManager = nil;
    }
  
    self.httpRequest = [[SeaHttpRequest alloc] initWithDelegate:self];
    [self reloadDataFromNetwork];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.needNotifyShake = self.shakeInfo != nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.needNotifyShake = NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillEnterForegroundNotification object:nil];
}

#pragma mark- 摇一摇

///收到通知,进入后台
- (void)applicationDidEnterBackground:(NSNotification *)notification
{
    ///关闭摇一摇监听
    self.enableShakeWhenEnterBackground = self.needNotifyShake;
    self.needNotifyShake = NO;
}

///收到通知，进入前台
- (void)applicationWillEnterForeground:(NSNotification*)notification
{
    ///要判断是否允许监听摇一摇
    self.needNotifyShake = self.enableShakeWhenEnterBackground;
}

- (void)setNeedNotifyShake:(BOOL)needNotifyShake
{
    if(_needNotifyShake != needNotifyShake)
    {
        _needNotifyShake = needNotifyShake;
        _needNotifyShake ? [self startAccelerometer] : [self.motionManager stopAccelerometerUpdates];
    }
}

///开始监听摇一摇
- (void)startAccelerometer
{
    if(!self.needNotifyShake)
        return;
    
    //以push的方式更新并在block中接收加速度
    [self.motionManager startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc]init]
                                             withHandler:^(CMAccelerometerData *accelerometerData, NSError *error)
     {
         [self outputAccelertionData:accelerometerData.acceleration];
         
         if (error) {
             NSLog(@"motion error:%@",error);
         }
     }];
}

///处理摇晃结果
- (void)outputAccelertionData:(CMAcceleration)acceleration
{
    //综合3个方向的加速度
    double accelerameter = sqrt( pow( acceleration.x , 2 ) + pow( acceleration.y , 2 )
                               + pow( acceleration.z , 2) );
    //当综合加速度大于2.3时，就激活效果（此数值根据需求可以调整，数据越小，用户摇动的动作就越小，越容易激活，反之加大难度，但不容易误触发）
    if (accelerameter > 2.3f)
    {
        //立即停止更新加速仪（很重要！）
        [self.motionManager stopAccelerometerUpdates];
        dispatch_async(dispatch_get_main_queue(), ^{

            [self deviceShake];
        });
    }
}

#pragma mark- http

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
    if([request.identifier isEqualToString:WMShakeInfoIdentifier])
    {
        [self failToLoadData];
        return;
    }
    
    if([request.identifier isEqualToString:WMShakeResultIdentifier])
    {
        self.shakeResultInfo = nil;
        self.shaking ? self.needProcessShakeResult = YES : [self processShakeResult];
        return;
    }
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{
    if([request.identifier isEqualToString:WMShakeInfoIdentifier])
    {
        self.winner_view.loading = NO;
        WMShakeInfo *shakeInfo = nil;
        long long totalSize = 0;
        NSArray *infos = [WMShakeOperation shakeInfoFromData:data totalSize:&totalSize info:self.shakeInfo == nil ? &shakeInfo : nil];
        
        if(infos)
        {
            self.totalSize = totalSize;
            [self.winners addObjectsFromArray:infos];
            
            if(self.loading)
            {
                self.shakeInfo = shakeInfo;
                self.loading = NO;
                [self setTimesToShake];
                self.needNotifyShake = YES;
                
                self.winner_view.winners = self.winners;
                if(self.winners.count < self.totalSize)
                {
                    WeakSelf(self);
                    ///加载下一页获奖名单
                    self.winner_view.willLoadNextWinnersHandler = ^(void){
                        
                        weakSelf.curPage ++;
                        [weakSelf loadShakeInfo];
                    };
                }
            }
            else
            {
                
                [self.winner_view.collectionView reloadData];
                if(self.winners.count >= self.totalSize)
                {
                    self.winner_view.willLoadNextWinnersHandler = nil;
                }
            }
        }
        else if(self.loading)
        {
            [self failToLoadData];
        }
        
        return;
    }
    
    if([request.identifier isEqualToString:WMShakeResultIdentifier])
    {
        WMShakeResultInfo *info = [WMShakeOperation shakeResultFromData:data];
        self.shakeResultInfo = info;
        
        if(info)
        {
            self.shaking ? self.needProcessShakeResult = YES : [self processShakeResult];
        }
        else
        {
            [self setShakingDialogStatus:WMShakingStatusHidden];
            self.shaking = NO;
            self.needProcessShakeResult = NO;
            self.needNotifyShake = YES;
        }
        
        return;
    }
}

///加载摇一摇信息
- (void)loadShakeInfo
{
    self.winner_view.loading = NO;
    self.httpRequest.identifier = WMShakeInfoIdentifier;
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMShakeOperation shakeInfoParamsWithPageIndex:self.curPage]];
}

///加载摇一摇结果
- (void)loadShakeResult
{
    if(self.httpRequest.requesting)
        self.curPage --;
    
    self.needProcessShakeResult = NO;
    self.httpRequest.identifier = WMShakeResultIdentifier;
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMShakeOperation shakeResultParams]];
}

- (void)reloadDataFromNetwork
{
    self.loading = YES;
    [self loadShakeInfo];
}

#pragma mark- 设备摇动

//设备摇动动画
- (void)deviceShake
{
    self.title_label.hidden = YES;
    self.subtitle_label.hidden = self.title_label.hidden;
    
    [self showShakingDialog];
    self.shaking = YES;
    [self loadShakeResult];
    ///
    CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    shake.fromValue = [NSNumber numberWithFloat:-M_PI/32];
    shake.toValue   = [NSNumber numberWithFloat:+M_PI/32];
    shake.duration = 0.1;
    shake.autoreverses = YES;
    shake.repeatCount = 6;
    shake.delegate = self;
    [self.person_imageView.layer addAnimation:shake forKey:@"shakeAnimation"];
    
    if(!self.music_btn.selected)
    {
        [SeaSystemSound systemSoundWithURL:[[NSBundle mainBundle] pathForResource:@"yao" ofType:@"mp3"]];
    }
}

///动画完成
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    self.shaking = NO;
    if(self.needProcessShakeResult)
    {
        [self processShakeResult];
    }
}

/////设备震动方法
//- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
//{
//    if(self.needNotifyShake && event.type == UIEventTypeMotion && event.subtype == UIEventSubtypeMotionShake)
//    {
//        [self deviceShake];
//    }
//}

///处理摇一摇结果
- (void)processShakeResult
{
    if(!self.shakeResultInfo)
    {
        self.needNotifyShake = YES;
        [self setShakingDialogStatus:WMShakingStatusFail];
        return;
    }
    
    switch (self.shakeResultInfo.result)
    {
        case WMShakeResultCoupons :
        {
            [self showCouponsDialog];
        }
            break;
        case WMShakeResultCharacterAdd :
        {
            [self showCharacterDialog];
        }
            break;
        case WMShakeResultOther :
        case WMShakeResultShakeEnd :
        {
            [self showTomorrowDialog];
        }
            break;
    }
    
    self.shakeInfo.timesToShake = self.shakeResultInfo.timesToShake;
    self.shakeInfo.isInfinite = self.shakeResultInfo.isInfinite;
    [self setTimesToShake];
}

///设置可摇次数
- (void)setTimesToShake
{
    self.status_label.text = [NSString stringWithFormat:@"今天还可摇%@次", self.shakeInfo.timesToShakeString];
}

#pragma mark- btn action

///播放音乐
- (IBAction)musicAction:(id)sender
{
    self.music_btn.selected = !self.music_btn.selected;
}

///规则
- (IBAction)ruleAction:(id)sender
{
    self.needNotifyShake = NO;
    WMShakeRuleViewController *rule = [[WMShakeRuleViewController alloc] init];
    rule.rule = self.shakeInfo.rule;
    
    WeakSelf(self);
    rule.dismissCompletionHandler = ^(void)
    {
        weakSelf.needNotifyShake = YES;
    };
    [rule showInViewController:self];
}

#pragma mark- dialog

///弹窗背景
- (UIView*)dialogBackgroundView
{
    if(!_dialogBackgroundView)
    {
        _dialogBackgroundView = [[UIView alloc] init];
        _dialogBackgroundView.backgroundColor = [UIColor clearColor];
        _dialogBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:_dialogBackgroundView];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_dialogBackgroundView);
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_dialogBackgroundView]-0-|" options:0 metrics:nil views:views];
        [self.view addConstraints:constraints];
        
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_dialogBackgroundView]-0-|" options:0 metrics:nil views:views];
        [self.view addConstraints:constraints];
    }
    
    return _dialogBackgroundView;
}

///显示正在摇弹窗
- (void)showShakingDialog
{
    self.needNotifyShake = NO;
    self.characterDialog.hidden = YES;
    
    if(!self.shakingDialog)
    {
        WMShakingDialog *dialog = [[WMShakingDialog alloc] init];
        [self.view addSubview:dialog];
        self.shakingDialog = dialog;
        
        NSDictionary *views = NSDictionaryOfVariableBindings(dialog, _compass_imageView);
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-30-[dialog]-30-|" options:0 metrics:nil views:views];
        [self.view addConstraints:constraints];
        
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_compass_imageView]-10-[dialog(50)]" options:0 metrics:nil views:views];
        [self.view addConstraints:constraints];
    }
    
    [self setShakingDialogStatus:WMShakingStatusLoading];
}

///设置正在摇弹窗
- (void)setShakingDialogStatus:(WMShakingStatus) status
{
    self.shakingDialog.status = status;
}

///显示人品加1
- (void)showCharacterDialog
{
    self.needNotifyShake = YES;
    [self setShakingDialogStatus:WMShakingStatusHidden];
    
    if(!self.characterDialog)
    {
        WMShakeResultCharacterDialog *dialog = [[WMShakeResultCharacterDialog alloc] init];
        [self.view addSubview:dialog];
        self.characterDialog = dialog;
        
        NSDictionary *views = NSDictionaryOfVariableBindings(dialog, _compass_imageView);
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-30-[dialog]-30-|" options:0 metrics:nil views:views];
        [self.view addConstraints:constraints];
        
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_compass_imageView]-10-[dialog(50)]" options:0 metrics:nil views:views];
        [self.view addConstraints:constraints];
    }
    else
    {
        self.characterDialog.hidden = NO;
    }
    
    self.characterDialog.info = self.shakeResultInfo;
}

///显示摇中弹窗
- (void)showCouponsDialog
{
    self.needNotifyShake = NO;
    [self setShakingDialogStatus:WMShakingStatusHidden];
    self.dialogBackgroundView.hidden = NO;
    
    if(!self.couponsDialog)
    {
        WeakSelf(self);
        WMShakeResultCouponsDialog *dialog = [[WMShakeResultCouponsDialog alloc] init];
        dialog.closeHandler = ^(void){
          
            weakSelf.needNotifyShake = YES;
            weakSelf.dialogBackgroundView.hidden = YES;
        };
        
        dialog.seeImmediatelyHandler = ^(void){
          
            WMCouponsListViewController *list = [[WMCouponsListViewController alloc] init];
            [weakSelf.navigationController pushViewController:list animated:YES];
        };
        
        [self.view addSubview:dialog];
        self.couponsDialog = dialog;
        
        NSDictionary *views = NSDictionaryOfVariableBindings(dialog);
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[dialog]-10-|" options:0 metrics:nil views:views];
        [self.view addConstraints:constraints];
        
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[dialog(265)]" options:0 metrics:nil views:views];
        [self.view addConstraints:constraints];
        
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:dialog attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:20];
        [self.view addConstraint:constraint];
    }
    else
    {
        self.couponsDialog.hidden = NO;
    }
    
    self.couponsDialog.info = self.shakeResultInfo;
}

///显示明日再战弹窗
- (void)showTomorrowDialog
{
    self.needNotifyShake = NO;
    [self setShakingDialogStatus:WMShakingStatusHidden];
    self.dialogBackgroundView.hidden = NO;
    
    if(!self.tomorrowDialog)
    {
        WeakSelf(self);
        WMShakeTomorrowDialog *dialog = [[WMShakeTomorrowDialog alloc] init];
        dialog.closeHandler = ^(void){
            
            weakSelf.needNotifyShake = YES;
            weakSelf.dialogBackgroundView.hidden = YES;
        };
        
        [self.view addSubview:dialog];
        self.tomorrowDialog = dialog;
        
        NSDictionary *views = NSDictionaryOfVariableBindings(dialog);
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[dialog]-10-|" options:0 metrics:nil views:views];
        [self.view addConstraints:constraints];
        
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[dialog(200)]-100-|" options:0 metrics:nil views:views];
        [self.view addConstraints:constraints];
    }
    else
    {
        self.tomorrowDialog.hidden = NO;
    }
    
    self.tomorrowDialog.info = self.shakeResultInfo;
}

@end

//
//  WMServerTimeOperation.m
//  WuMei
//
//  Created by 罗海雄 on 15/7/30.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "WMServerTimeOperation.h"
#import "WMHomeOperation.h"

@interface WMServerTimeOperation ()<SeaHttpRequestDelegate>

/**计时器
 */
@property(nonatomic,strong) NSTimer *timer;

/**进入后台的时间
 */
@property(nonatomic,copy) NSDate *dateForApplicationResignActive;

/**网络请求
 */
@property(nonatomic,strong) SeaHttpRequest *httpRequest;

@end

@implementation WMServerTimeOperation

- (id)init
{
    self = [super init];
    if(self)
    {
        self.time = [[NSDate date] timeIntervalSince1970];
        [self performSelector:@selector(startTimer) withObject:nil afterDelay:1.0];
        
        ///app状态监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark- 通知

- (void)applicationWillResignActive:(NSNotification*) notification
{
    self.dateForApplicationResignActive = [NSDate date];
}

- (void)applicationDidBecomeActive:(NSNotification*) notification
{
    self.time -= [self.dateForApplicationResignActive timeIntervalSinceNow];
}

/**单例
 */
+ (WMServerTimeOperation*)sharedInstance
{
    static dispatch_once_t once = 0;
    static WMServerTimeOperation *serverTimeOperation = nil;
    
    dispatch_once(&once, ^(void){
        
        serverTimeOperation = [[WMServerTimeOperation alloc] init];
    });
    
    return serverTimeOperation;
}

//启动计时器
- (void)startTimer
{
    if(!self.timer)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countAppend:) userInfo:nil repeats:YES];
        //必须添加这个，否则UIScrollView 拖动的时候计时器会停止运行
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        [self.timer fire];
    }
}

//结束计时器
- (void)stopTimer
{
    if(self.timer != nil && [self.timer isValid])
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)countAppend:(NSTimer*) timer
{
    self.time ++;
}

/**从字典中获取服务器时间
 */
+ (void)timeFromDictionary:(NSDictionary*) dic
{
    NSString *time = [dic sea_stringForKey:@"system_time"];
    //NSLog(@"system time %@", time);
    
    if(![NSString isEmpty:time])
    {
        WMServerTimeOperation *operation = [WMServerTimeOperation sharedInstance];
        operation.time = [time doubleValue];
    }
}

#pragma mark- http

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
    self.httpRequest = nil;
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{
    NSTimeInterval time = [WMHomeOperation serverTimeFromData:data];
    if(time != 0)
    {
        self.time = time;
    }
    
    self.httpRequest = nil;
}

///加载服务器时间
- (void)loadServerTime
{
    self.httpRequest = [[SeaHttpRequest alloc] initWithDelegate:self];
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMHomeOperation serverTimeParams]];
}

@end

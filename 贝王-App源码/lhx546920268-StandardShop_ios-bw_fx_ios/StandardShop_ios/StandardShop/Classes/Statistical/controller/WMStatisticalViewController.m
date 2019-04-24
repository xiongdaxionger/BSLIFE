//
//  WMStatisticalViewController.m
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/3.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMStatisticalViewController.h"
#import "WMStatisticalCountView.h"
#import "UUChart.h"
#import "WMStatisticalInfo.h"
#import "WMStatisticalBubbleView.h"
#import "WMStatisticalOperation.h"

@interface WMStatisticalViewController ()<SeaNetworkQueueDelegate,SeaMenuBarDelegate,UUChartDataSource>

///菜单
@property(nonatomic,strong) SeaMenuBar *menuBar;

///统计数量视图
@property(nonatomic,strong) WMStatisticalCountView *countView;

///统计折线视图
@property(nonatomic,strong) UUChart *chartView;

///统计详情气泡
@property(nonatomic,strong) WMStatisticalBubbleView *bubbleView;

///订单统计信息 数组元素是 WMStatisticalInfo
@property(nonatomic,strong) NSArray *orderInfos;

///收入统计信息 数组元素是 WMStatisticalInfo
@property(nonatomic,strong) NSArray *incomeInfos;

///统计信息
@property(nonatomic,strong) NSArray <WMStatisticalInfo*> *infos;

///请求队列
@property(nonatomic,strong) SeaNetworkQueue *queue;

@end

@implementation WMStatisticalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = _SeaViewControllerBackgroundColor_;
    self.backItem = YES;
    
    self.title = @"统计";
    self.queue = [[SeaNetworkQueue alloc] initWithDelegate:self];
    
    [self reloadDataFromNetwork];
}

///初始化
- (void)initialization
{
    self.loading = NO;
    ///菜单
    self.menuBar = [[SeaMenuBar alloc] initWithFrame:CGRectMake(0, 0, _width_, _SeaMenuBarHeight_) titles:[self reloadMenu] style:SeaMenuBarStyleItemWithRelateTitleInFullScreen];
    self.menuBar.selectedIndex = self.showedIndexPath.row;
    self.menuBar.delegate = self;
    self.menuBar.titleFont = [UIFont fontWithName:MainFontName size:16.0];
    self.menuBar.selectedColor = [UIColor blackColor];
    [self.view addSubview:self.menuBar];

    
    ///折线视图
    self.chartView = [[UUChart alloc] initwithUUChartDataFrame:CGRectMake(0, self.menuBar.bottom, _width_, 260.0)
                                                    withSource:self
                                                     withStyle:UUChartLineStyle];
    self.chartView.backgroundColor = [UIColor colorFromHexadecimal:@"F2F7FB"];
    [self.chartView showInView:self.view];
    
    ///统计数字
    self.countView = [[WMStatisticalCountView alloc] initWithFrame:CGRectMake(-_separatorLineWidth_, self.chartView.bottom, _width_ + _separatorLineWidth_ * 2, WMStatisticalCountViewHeight)];
    [self.view addSubview:self.countView];
    
    [self menuBar:self.menuBar didSelectItemAtIndex:self.menuBar.selectedIndex];
    
    ///气泡
    self.bubbleView = [[WMStatisticalBubbleView alloc] init];
    self.bubbleView.hidden = YES;
    [self.view addSubview:self.bubbleView];
}

#pragma mark- touch 


///刷新数据
- (void)reloadData
{
    if(!self.chartView)
    {
        [self initialization];
    }
    self.countView.info = [self currentInfo];
    [self.chartView strokeChart];
}

///刷新菜单
- (NSArray*)reloadMenu
{
    NSArray *infos = [self currentInfos];
    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:infos.count];
    
    for(WMStatisticalInfo *info in infos)
    {
        [titles addObject:info.menuTitle];
    }
    
    NSInteger selectedIndex = self.menuBar.selectedIndex;
    self.menuBar.titles = titles;
    if(selectedIndex < titles.count)
    {
        self.menuBar.selectedIndex = selectedIndex;
    }
    
    return titles;
}

#pragma mark- SeaMenuBar delegate

- (void)menuBar:(SeaMenuBar *)menu didSelectItemAtIndex:(NSInteger)index
{
    [self reloadData];
}

#pragma mark- http

- (void)networkQueue:(SeaNetworkQueue *)queue requestDidFailWithError:(NSInteger)error identifier:(NSString *)identifier
{
    
}

- (void)networkQueue:(SeaNetworkQueue *)queue requestDidFinishWithData:(NSData *)data identifier:(NSString *)identifier
{
    if([identifier isEqualToString:WMOrderStatisticalIdentifier])
    {
        self.orderInfos = [WMStatisticalOperation orderStatisticalResultFromData:data];

        return;
    }
    
    if([identifier isEqualToString:WMIncomeStatisticalIdentifier])
    {
        self.incomeInfos = [WMStatisticalOperation incomeStatisticalResultFromData:data];
        
        return;
    }
}

- (void)networkQueueDidFinish:(SeaNetworkQueue *)queue
{
    if(self.incomeInfos)
    {
        self.infos = self.incomeInfos;
//        self.infos = [NSMutableArray array];
//        for(NSInteger i = 0;i < self.incomeInfos.count && self.orderInfos.count; i++)
//        {
//            WMStatisticalInfo *incomInfo = [self.incomeInfos objectAtIndex:i];
//            WMStatisticalInfo *orderInfo = [self.orderInfos objectAtIndex:i];
//            
//            WMStatisticalInfo *info = [[WMStatisticalInfo alloc] init];
//            [self.infos addObject:info];
//            
//            info.menuTitle = incomInfo.menuTitle;
//            NSMutableArray *infos = [NSMutableArray array];
//            [infos addObjectsFromArray:orderInfo.infos];
//            [infos addObjectsFromArray:incomInfo.infos];
//            info.infos = infos;
//        }
        [self initialization];
    }
    else
    {
        [self failToLoadData];
    }
}


- (void)reloadDataFromNetwork
{
    self.loading = YES;
//    [self.queue addRequestWithURL:SeaNetworkRequestURL param:[WMStatisticalOperation orderStatisticalParam] identifier:WMOrderStatisticalIdentifier];
    [self.queue addRequestWithURL:SeaNetworkRequestURL param:[WMStatisticalOperation incomeStatisticalParam] identifier:WMIncomeStatisticalIdentifier];
    [self.queue startDownload];
}

#pragma mark - UUChart delegate

//横坐标标题数组
- (NSArray *)UUChart_xLableArray:(UUChart *)chart
{
    WMStatisticalInfo *info = [self currentInfo];
    
    WMStatisticalDataInfo *data = [info.infos firstObject];
    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:data.infos.count];
    
    for(WMStatisticalNodeInfo *node in data.infos)
    {
        [titles addObject:node.xTitle];
    }
    
    return titles;
}

//数值多重数组
- (NSArray *)UUChart_yValueArray:(UUChart *)chart
{
    WMStatisticalInfo *info = [self currentInfo];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:info.infos.count];
    
    for(WMStatisticalDataInfo *data in info.infos)
    {
        NSMutableArray *yValues = [NSMutableArray arrayWithCapacity:data.infos.count];
        for(WMStatisticalNodeInfo *node in data.infos)
        {
            [yValues addObject:node.yValue];
        }
        
        [array addObject:yValues];
    }
    
    return array;
}

//颜色数组
- (NSArray *)UUChart_ColorArray:(UUChart *)chart
{
    return @[WMStatisticalRed, WMStatisticalBlue, WMStatisticalGreen];
}


//判断显示横线条
- (BOOL)UUChart:(UUChart *)chart ShowHorizonLineAtIndex:(NSInteger)index
{
    return index == 4;
}

- (void)UUChart:(UUChart *)chart didEndTouchAtIndex:(NSInteger)index
{
    self.bubbleView.hidden = YES;
}

- (void)UUChart:(UUChart *)chart didTouchAtIndex:(NSInteger)index inPoint:(CGPoint) point
{
    self.bubbleView.hidden = NO;
    [self.bubbleView setStatisticalInfo:[self currentInfo] forIndex:index inPoint:point];
}

///当前数据源
- (NSArray*)currentInfos
{
    return self.infos;
}

///当前统计信息
- (WMStatisticalInfo*)currentInfo
{
   return [[self currentInfos] objectAtIndex:self.menuBar.selectedIndex];
}

@end

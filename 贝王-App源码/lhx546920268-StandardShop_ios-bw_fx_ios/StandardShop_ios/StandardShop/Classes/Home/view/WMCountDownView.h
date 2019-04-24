//
//  WMCountDownView.h
//  WuMei
//
//  Created by 罗海雄 on 15/7/18.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMCountDownView;

@protocol WMCountDownViewDelegate <NSObject>

/**倒计时结束
 */
- (void)countDownViewDidEnd:(WMCountDownView*) view;

@end

///倒计时精确
typedef NS_ENUM(NSInteger, WMCountDownAccurate)
{
    ///精确到小时
    WMCountDownAccurateHour = 0,
    
    ///精确到天
    WMCountDownAccurateDay,
};

///倒计时内容对其方式
typedef NS_ENUM(NSInteger, WMCountDownContentAlignment)
{
    ///左对其
    WMCountDownContentAlignmentLeft = 0,
    
    ///右对其
    WMCountDownContentAlignmentRight,

    ///居中对其 暂时未实现
    WMCountDownContentAlignmentCenter,
};

/**倒计时 必须在 dealloc 之前调用 stopTimer 方法
 * 如果是在UITableView 中使用，可以在
 * tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath 中调用 stopTimer
 * tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath 中调用 startTimer
 * 以上两个方法必须一起实现，否则计时器可能不会运行
 */
@interface WMCountDownView : UIView

/**内容对其方式 default is 'WMCountDownContentAlignmentRight'
 */
@property(nonatomic,assign) WMCountDownContentAlignment contentAlignment;

/**提示信息
 */
@property(nonatomic,strong) NSString *text;

/**图标
 */
@property(nonatomic,strong) UIImage *icon;

/**文字和图标按钮
 */
@property(nonatomic,readonly) UIButton *button;

/**精确时间段 default is 'WMCountDownAccurateHour'
 */
@property(nonatomic,readonly) WMCountDownAccurate accurate;

/**设置开始倒计时的时间 时间戳
 */
@property(nonatomic,assign) NSTimeInterval timeInterval;

/**是否已结束
 */
@property(nonatomic,readonly) BOOL end;

@property(nonatomic,weak) id<WMCountDownViewDelegate> delegate;

///点颜色 default is 'grayColor'
@property(strong,nonatomic) UIColor *pointTextColor;

///点字体 default is '12.0'
@property(nonatomic,strong) UIFont *pointFont;

/**数字背景颜色 默认 WMRedColor
 */
@property(nonatomic,strong) UIColor *numberBackgroundColor;

/**数字边框 default is '0'
 */
@property(nonatomic,assign) CGFloat numberBorderWidth;

/**数字边框颜色 default is 'nil'
 */
@property(nonatomic,strong) UIColor *numberBorderColor;

/**数字字体颜色 default is 'whiteColor'
 */
@property(nonatomic,strong) UIColor *numberTextColor;

/**数字大小 default is '18.0,15.0'
 */
@property(nonatomic,assign) CGSize numberSize;

/**数字字体 default is '12'
 */
@property(nonatomic,strong) UIFont *numberFont;
 
/**开始计时
 */
- (void)startTimer;

/**结束计时
 */
- (void)stopTimer;

/**结束
 */
- (void)timerEnd;

///初始化，在设置属性后调用
- (void)initlization;


@end

//
//  ConfirmOrderFooterView.m
//  WuMei
//
//  Created by qsit on 15/8/15.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "ConfirmOrderFooterView.h"

#import "MZTimerLabel.h"

@interface ConfirmOrderFooterView ()<MZTimerLabelDelegate>
/**倒计时文本
 */
@property (strong,nonatomic) MZTimerLabel *countTime;
@end

@implementation ConfirmOrderFooterView

- (instancetype)initWithFrame:(CGRect)frame timeInterval:(NSTimeInterval)time{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width_, _separatorLineWidth_)];
        
        lineView.backgroundColor = _separatorLineColor_;
        
        [self addSubview:lineView];
        
        UILabel *timeHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, (frame.size.height - 21) / 2.0, 34, 21)];
        
        timeHeaderLabel.font = [UIFont fontWithName:MainFontName size:15];
        
        timeHeaderLabel.textColor = [UIColor blackColor];
        
        timeHeaderLabel.textAlignment = NSTextAlignmentRight;
        
        timeHeaderLabel.text = @"请在";
        
        [self addSubview:timeHeaderLabel];
        
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, timeHeaderLabel.frame.origin.y, 58, 21)];
        
        timeLabel.textColor = WMPriceColor;
        
        timeLabel.textAlignment = NSTextAlignmentCenter;
        
        timeLabel.font = [UIFont fontWithName:MainFontName size:16];
        
        _countTime = [[MZTimerLabel alloc] initWithLabel:timeLabel andTimerType:MZTimerLabelTypeTimer];
        
        [_countTime setCountDownTime:time];
        
        _countTime.centerY = self.centerY;
        
        _countTime.timeFormat = @"mm:ss";
        
        [_countTime setDelegate:self];
        
        [self addSubview:timeLabel];
        
        UILabel *timeFooterLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, timeHeaderLabel.frame.origin.y, 130, 21)];
        
        timeFooterLabel.font = [UIFont fontWithName:MainFontName size:15];
        
        timeFooterLabel.textColor = [UIColor blackColor];
        
        timeFooterLabel.text = @"分钟内完成该支付";
        
        timeFooterLabel.textAlignment = NSTextAlignmentLeft;
        
        [self addSubview:timeFooterLabel];
        
    }
    return self;
}
- (void)start{
    [_countTime start];
}
- (void)stop{
    [_countTime pause];
}
- (void)timerLabel:(MZTimerLabel *)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime{
    if (_timeOut) {
        _timeOut();
    }
}

@end

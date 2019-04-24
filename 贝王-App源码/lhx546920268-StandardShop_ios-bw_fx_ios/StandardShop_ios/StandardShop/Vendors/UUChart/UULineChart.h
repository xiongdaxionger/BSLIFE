//
//  UULineChart.h
//  UUChartDemo
//
//  Created by shake on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "UUColor.h"

#define chartMargin     0
#define xLabelMargin    0
#define yLabelMargin    0
#define UULabelHeight    30
#define UUYLabelwidth     0
#define UUTagLabelwidth     0


@class UULineChart;

@protocol UULineChartDelegate <NSObject>

@optional
///触摸某个位置
- (void)lineChart:(UULineChart*) chart didTouchAtIndex:(NSInteger) index;

///取消触摸
- (void)lineChart:(UULineChart *)chart didEndTouchAtIndex:(NSInteger)index;

@end

@interface UULineChart : UIView

@property (strong, nonatomic) NSArray * xLabels;

@property (strong, nonatomic) NSArray * yLabels;

@property (strong, nonatomic) NSArray * yValues;

@property (nonatomic, strong) NSArray * colors;

@property (nonatomic, assign) UIEdgeInsets contentInset;

@property (nonatomic, readonly) UIView *indicatorLine;

@property (nonatomic) CGFloat xLabelWidth;
@property (nonatomic) CGFloat yValueMin;
@property (nonatomic) CGFloat yValueMax;

@property (nonatomic, assign) CGRange markRange;

@property (nonatomic, assign) CGRange chooseRange;

@property (nonatomic, assign) BOOL showRange;

@property (nonatomic, retain) NSMutableArray *ShowHorizonLine;
@property (nonatomic, retain) NSMutableArray *ShowMaxMinArray;

@property (nonatomic, weak) id<UULineChartDelegate> delegate;

-(void)strokeChart;

- (NSArray *)chartLabelsForX;

@end

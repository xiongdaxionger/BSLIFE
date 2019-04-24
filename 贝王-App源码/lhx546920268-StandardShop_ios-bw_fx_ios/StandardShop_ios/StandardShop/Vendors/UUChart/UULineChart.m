//
//  UULineChart.m
//  UUChartDemo
//
//  Created by shake on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UULineChart.h"
#import "UUColor.h"
#import "UUChartLabel.h"


@implementation UULineChart {
    NSHashTable *_chartLabelsForX;
    NSMutableArray *_yLabelArray;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
        _contentInset = UIEdgeInsetsMake(10.0, 20.0, 0, 20.0);
        _yLabelArray = [NSMutableArray array];
    }
    return self;
}

-(void)setYValues:(NSArray *)yValues
{
    _yValues = yValues;
    [self setYLabels:yValues];
}

-(void)setYLabels:(NSArray *)yLabels
{
    NSInteger max = 0;
    NSInteger min = 1000000000;

    for (NSArray * ary in yLabels) {
        for (NSString *valueString in ary) {
            NSInteger value = [valueString integerValue];
            if (value > max) {
                max = value;
            }
            if (value < min) {
                min = value;
            }
        }
    }
    if (max < 5) {
        max = 5;
    }
    if (self.showRange) {
        _yValueMin = min;
    }else{
        _yValueMin = 0;
    }
    _yValueMax = (int)max;
    
    if (_chooseRange.max!=_chooseRange.min) {
        _yValueMax = _chooseRange.max;
        _yValueMin = _chooseRange.min;
    }

    float level = (_yValueMax-_yValueMin) /4.0;
    CGFloat chartCavanHeight = self.frame.size.height - UULabelHeight;
    CGFloat levelHeight = chartCavanHeight /4.0;

    for (int i=0; i<5; i++) {
        UUChartLabel * label = [[UUChartLabel alloc] initWithFrame:CGRectMake(0.0,chartCavanHeight-i*levelHeight+5, UUYLabelwidth, UULabelHeight)];
		label.text = [NSString stringWithFormat:@"%d",(int)(level * i+_yValueMin)];
		[self addSubview:label];
    }
    if ([super respondsToSelector:@selector(setMarkRange:)]) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(UUYLabelwidth, (1-(_markRange.max-_yValueMin)/(_yValueMax-_yValueMin))*chartCavanHeight+UULabelHeight, self.frame.size.width-UUYLabelwidth, (_markRange.max-_markRange.min)/(_yValueMax-_yValueMin)*chartCavanHeight)];
        view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1.0];
        [self addSubview:view];
    }

    //画横线
    for (int i=0; i<5; i++) {
        if ([_ShowHorizonLine[i] integerValue]>0) {
            
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(UUYLabelwidth,0+i*levelHeight)];
            [path addLineToPoint:CGPointMake(self.frame.size.width,0+i*levelHeight)];
            [path closePath];
            shapeLayer.path = path.CGPath;
            shapeLayer.strokeColor = [[[UIColor whiteColor] colorWithAlphaComponent:1.0] CGColor];
            shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
            shapeLayer.lineWidth = 1;
            [self.layer addSublayer:shapeLayer];
        }
    }
}

-(void)setXLabels:(NSArray *)xLabels
{
    if( !_chartLabelsForX ){
        _chartLabelsForX = [NSHashTable weakObjectsHashTable];
    }
    
    _xLabels = xLabels;
    CGFloat num = 0;
    if (xLabels.count>=20) {
        num=20.0;
    }else if (xLabels.count<=1){
        num=1.0;
    }else{
        num = xLabels.count;
    }
    
    if(num >= 6)
    {
        _contentInset.left = 15.0;
        _contentInset.right = 20.0;
    }
    else
    {
        _contentInset.left = 25.0;
        _contentInset.right = 30.0;
    }
    
    _xLabelWidth = (self.frame.size.width - _contentInset.left - _contentInset.right) / MAX(1, (num - 1));
    
    [_yLabelArray removeAllObjects];
    for (int i=0; i<xLabels.count; i++) {
        
        CGFloat x = i * _xLabelWidth + _contentInset.left / 2.0;
 
        NSString *labelText = xLabels[i];
        UUChartLabel * label = [[UUChartLabel alloc] initWithFrame:CGRectMake(x, self.frame.size.height - UULabelHeight, _xLabelWidth, UULabelHeight)];
        label.text = labelText;
        
//        CGFloat textWidth = [labelText stringSizeWithFont:label.font contraintWith:_xLabelWidth].width;
//        if(x + textWidth > self.width)
//        {
//            label.left = self.width - textWidth;
//        }
        
        [self addSubview:label];
        
        [_chartLabelsForX addObject:label];
       
    }
    
    //画竖线
    for (int i=0; i<xLabels.count; i++) {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(_contentInset.left + i*_xLabelWidth,0)];
        [path addLineToPoint:CGPointMake(_contentInset.left+i*_xLabelWidth,self.frame.size.height- UULabelHeight)];
        [path closePath];
        shapeLayer.path = path.CGPath;
        shapeLayer.strokeColor = [[[UIColor whiteColor] colorWithAlphaComponent:1.0] CGColor];
        shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
        shapeLayer.lineWidth = 1;
        [self.layer addSublayer:shapeLayer];
        
        [_yLabelArray addObject:[NSValue valueWithCGRect:CGRectMake(_contentInset.left + i*_xLabelWidth, 0, 1, self.frame.size.height- UULabelHeight)]];
    }
}

-(void)setColors:(NSArray *)colors
{
	_colors = colors;
}

- (void)setMarkRange:(CGRange)markRange
{
    _markRange = markRange;
}

- (void)setChooseRange:(CGRange)chooseRange
{
    _chooseRange = chooseRange;
}

- (void)setShowHorizonLine:(NSMutableArray *)ShowHorizonLine
{
    _ShowHorizonLine = ShowHorizonLine;
}


-(void)strokeChart
{
    self.userInteractionEnabled = _yValues.count > 0;
    for (int i=0; i<_yValues.count; i++) {
        NSArray *childAry = _yValues[i];
        if (childAry.count==0) {
            return;
        }
        //获取最大最小位置
        CGFloat max = [childAry[0] floatValue];
        CGFloat min = [childAry[0] floatValue];
        NSInteger max_i = 0;
        NSInteger min_i = 0;
        
        for (int j=0; j<childAry.count; j++){
            CGFloat num = [childAry[j] floatValue];
            if (max<=num){
                max = num;
                max_i = j;
            }
            if (min>=num){
                min = num;
                min_i = j;
            }
        }
        
        //划线
        CAShapeLayer *_chartLine = [CAShapeLayer layer];
        _chartLine.lineCap = kCALineCapRound;
        _chartLine.lineJoin = kCALineJoinBevel;
        _chartLine.fillColor   = [[UIColor whiteColor] CGColor];
        _chartLine.lineWidth   = 2.0;
        _chartLine.strokeEnd   = 0.0;
        [self.layer addSublayer:_chartLine];
        
        UIBezierPath *progressline = [UIBezierPath bezierPath];
        CGFloat firstValue = [[childAry objectAtIndex:0] floatValue];
        CGFloat xPosition = _contentInset.left;//(UUYLabelwidth + _xLabelWidth/2.0);
        CGFloat chartCavanHeight = self.frame.size.height - UULabelHeight - _contentInset.top;
        
        float grade = ((float)firstValue-_yValueMin) / ((float)_yValueMax-_yValueMin);
       
        //第一个点
        BOOL isShowMaxAndMinPoint = YES;
        if (self.ShowMaxMinArray) {
            if ([self.ShowMaxMinArray[i] intValue]>0) {
                isShowMaxAndMinPoint = (max_i==0 || min_i==0)?NO:YES;
            }else{
                isShowMaxAndMinPoint = YES;
            }
        }
        
        CGPoint point = CGPointMake(xPosition, chartCavanHeight - grade * chartCavanHeight + _contentInset.top);
        [self addPoint:point
                 index:i
                isShow:isShowMaxAndMinPoint
                 value:firstValue];

        
        [progressline moveToPoint:point];
        [progressline setLineWidth:2.0];
        [progressline setLineCapStyle:kCGLineCapRound];
        [progressline setLineJoinStyle:kCGLineJoinRound];
        NSInteger index = 0;
        for (NSString * valueString in childAry) {
            
            float grade =([valueString floatValue]-_yValueMin) / ((float)_yValueMax-_yValueMin);
            if (index != 0) {
                
                CGPoint point = CGPointMake(xPosition+index*_xLabelWidth, chartCavanHeight - grade * chartCavanHeight + _contentInset.top);
                [progressline addLineToPoint:point];
                
                BOOL isShowMaxAndMinPoint = YES;
                if (self.ShowMaxMinArray) {
                    if ([self.ShowMaxMinArray[i] intValue]>0) {
                        isShowMaxAndMinPoint = (max_i==index || min_i==index)?NO:YES;
                    }else{
                        isShowMaxAndMinPoint = YES;
                    }
                }
                [progressline moveToPoint:point];
                [self addPoint:point
                         index:i
                        isShow:isShowMaxAndMinPoint
                         value:[valueString floatValue]];
                
//                [progressline stroke];
            }
            index += 1;
        }
        
        _chartLine.path = progressline.CGPath;
        if ([[_colors objectAtIndex:i] CGColor]) {
            _chartLine.strokeColor = [[_colors objectAtIndex:i] CGColor];
        }else{
            _chartLine.strokeColor = [UUGreen CGColor];
        }
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = childAry.count*0.4;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        pathAnimation.autoreverses = NO;
        [_chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        
        _chartLine.strokeEnd = 1.0;
    }
}

- (void)addPoint:(CGPoint)point index:(NSInteger)index isShow:(BOOL)isHollow value:(CGFloat)value
{
    isHollow = NO;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(3, 3, 7, 7)];
    view.center = point;
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = view.width / 2.0;
    view.layer.borderWidth = 2;
    view.layer.borderColor = [[_colors objectAtIndex:index] CGColor]?[[_colors objectAtIndex:index] CGColor]:UUGreen.CGColor;
    
    if (isHollow) {
        view.backgroundColor = [UIColor whiteColor];
    }else{
        view.backgroundColor = [_colors objectAtIndex:index]?[_colors objectAtIndex:index]:UUGreen;
//        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(point.x-UUTagLabelwidth/2.0, point.y-UULabelHeight*2, UUTagLabelwidth, UULabelHeight)];
//        label.font = [UIFont systemFontOfSize:10];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.textColor = view.backgroundColor;
//        label.text = [NSString stringWithFormat:@"%d",(int)value];
//        [self addSubview:label];
    }
    
    [self addSubview:view];
}

- (NSArray *)chartLabelsForX
{
    return [_chartLabelsForX allObjects];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!self.indicatorLine)
    {
        CGRect frame = [[_yLabelArray firstObject] CGRectValue];
        _indicatorLine = [[UIView alloc] initWithFrame:frame];
        _indicatorLine.backgroundColor = [UIColor colorFromHexadecimal:@"F343558"];
        _indicatorLine.userInteractionEnabled = NO;
        [self addSubview:_indicatorLine];
    }
    
    _indicatorLine.hidden = NO;
    [self bringSubviewToFront:_indicatorLine];
    [self touch:[touches anyObject] isCancel:NO];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touch:[touches anyObject] isCancel:NO];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    _indicatorLine.hidden = YES;
    [self touch:[touches anyObject] isCancel:YES];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    _indicatorLine.hidden = YES;
    [self touch:[touches anyObject] isCancel:YES];
}

- (void)touch:(UITouch*) touch isCancel:(BOOL) isCancel
{
    CGPoint point = [touch locationInView:self];
    NSInteger index = _yLabelArray.count - 1;
    for(NSInteger i = 0;i < _yLabelArray.count;i ++)
    {
        CGRect frame = [[_yLabelArray objectAtIndex:i] CGRectValue];
        if(point.x <= frame.origin.x + 1.0)
        {
            index = i;
            if(i != 0)
            {
                CGRect previousFrame = [[_yLabelArray objectAtIndex:i - 1] CGRectValue];
                if(point.x <= frame.origin.x + 1.0 + (frame.origin.x - previousFrame.origin.x) / 2.0)
                {
                    index = i - 1;
                }
            }
            
            break;
        }
    }
    
    _indicatorLine.frame = [[_yLabelArray objectAtIndex:index] CGRectValue];
    
    if(isCancel && [self.delegate respondsToSelector:@selector(lineChart:didEndTouchAtIndex:)])
    {
        [self.delegate lineChart:self didEndTouchAtIndex:index];
    }
    else if ([self.delegate respondsToSelector:@selector(lineChart:didTouchAtIndex:)])
    {
        [self.delegate lineChart:self didTouchAtIndex:index];
    }
}

@end

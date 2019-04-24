//
//  WMStatisticalBubbleView.m
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/4.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMStatisticalBubbleView.h"
#import "WMStatisticalInfo.h"

//箭头大小
#define _arrowSize_ 8.0

@interface WMStatisticalBubbleView ()

//箭头位置
@property(nonatomic,assign) CGPoint arrowPoint;

///内容
@property(nonatomic,strong) UILabel *contentLabel;

///时间
@property(nonatomic,strong) UILabel *timeLabel;

@end

@implementation WMStatisticalBubbleView

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, _width_, 60.0 + _arrowSize_)];
    if(self)
    {
        UIFont *contentFont = [UIFont fontWithName:MainFontName size:15.0];
        UIFont *timeFont = [UIFont fontWithName:MainFontName size:13.0];
        
        CGFloat margin = 10.0;
        CGFloat interval = (self.height - _arrowSize_ - contentFont.lineHeight - timeFont.lineHeight) / 3.0;
        
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, interval, self.width - margin * 2, contentFont.lineHeight)];
        self.contentLabel.font = contentFont;
        self.contentLabel.textAlignment = NSTextAlignmentCenter;
        self.contentLabel.textColor = [UIColor blackColor];
        self.contentLabel.adjustsFontSizeToFitWidth = YES;
        self.contentLabel.text = @"完税商品 29403.00   保税商品 29434.00   自营商品 2244.00";
        [self addSubview:self.contentLabel];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.contentLabel.left, self.contentLabel.bottom + interval, self.contentLabel.width, timeFont.lineHeight)];
        self.timeLabel.font = timeFont;
        self.timeLabel.textColor = [UIColor grayColor];
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        self.timeLabel.text = @"2015年4-6月";
        [self addSubview:self.timeLabel];
        self.opaque = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    //    //设置位置
    CGPoint arrowPoint1;
    CGPoint arrowPoint2;
    CGRect rectangular;
    CGFloat lineWidth = _separatorLineWidth_;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //设置绘制属性
    CGFloat radius = _arrowSize_ / cos(M_PI / 3.0) / 2.0; //尖角圆弧
    CGContextSetStrokeColorWithColor(context, _separatorLineColor_.CGColor);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    
    arrowPoint1 = CGPointMake(self.arrowPoint.x - _arrowSize_ * 0.5, self.arrowPoint.y - _arrowSize_);
    arrowPoint2 = CGPointMake(self.arrowPoint.x + _arrowSize_ * 0.5, self.arrowPoint.y - _arrowSize_);
    rectangular = CGRectMake(-lineWidth, -lineWidth, self.bounds.size.width + lineWidth * 2.0, self.bounds.size.height - _arrowSize_ - lineWidth);
    
    CGFloat rectangularBottom = rectangular.size.height + rectangular.origin.y;///矩形 height + y
    CGFloat rectangularRight = rectangular.origin.x + rectangular.size.width; ///矩形 width + x
    
    
    //绘制尖角 左边
    CGContextMoveToPoint(context, _arrowPoint.x, _arrowPoint.y - lineWidth);
    CGContextAddLineToPoint(context, _arrowPoint.x - radius / 4.0, _arrowPoint.y - radius / 2.0);
    CGContextAddArcToPoint(context, arrowPoint1.x, arrowPoint1.y, arrowPoint1.x - radius / 2.0, arrowPoint1.y, radius);

    //向左边连接
    CGContextAddLineToPoint(context, rectangular.origin.x, rectangularBottom);
    
    //向左上角连接
    CGContextAddLineToPoint(context, rectangular.origin.x, rectangular.origin.y);
    
    //向右上角连接
    CGContextAddLineToPoint(context, rectangularRight, rectangular.origin.y);
    
    //向右下角连接
    CGContextAddLineToPoint(context, rectangularRight, rectangularBottom);
    
    //向尖角右边
    CGContextAddLineToPoint(context, arrowPoint2.x + radius / 2.0, rectangularBottom);
    
    
    //绘制尖角右边
    CGContextAddArcToPoint(context, arrowPoint2.x, arrowPoint2.y, _arrowPoint.x + radius / 4.0, _arrowPoint.y - radius / 2.0, radius);
    CGContextAddLineToPoint(context, _arrowPoint.x, _arrowPoint.y - lineWidth);
    
   
   
    
    CGContextDrawPath(context, kCGPathFillStroke);
}

/**设置统计信息
 *@param WMStatisticalInfo
 *@param index 点下标
 *@param point 尖角位置
 */
- (void)setStatisticalInfo:(WMStatisticalInfo*) info forIndex:(NSInteger) index inPoint:(CGPoint) point
{
    point.y = self.height;
    if(!CGPointEqualToPoint(self.arrowPoint, point))
    {
        WMStatisticalDataInfo *dataInfo = [info.infos firstObject];
        WMStatisticalNodeInfo *nodeInfo = [dataInfo.infos objectAtIndex:index];
        
        self.timeLabel.text = [NSString stringWithFormat:@"%@ %@", nodeInfo.time, nodeInfo.xTitle];
        
        NSMutableString *string = [NSMutableString string];
        NSString *space = @"    ";
        
        for(WMStatisticalDataInfo *info1 in info.infos)
        {
            WMStatisticalNodeInfo *node = [info1.infos objectAtIndex:index];
            [string appendFormat:@"%@ %@%@", info1.sumTitle, node.yValue, space];
        }
        
        [string removeLastStringWithString:space];
        
        self.contentLabel.text = string;
        self.arrowPoint = point;
        [self setNeedsDisplay];
    }
}

@end

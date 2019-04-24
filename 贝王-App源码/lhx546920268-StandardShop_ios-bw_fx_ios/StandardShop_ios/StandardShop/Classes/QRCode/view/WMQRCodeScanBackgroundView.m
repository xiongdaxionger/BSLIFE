//
//  WMQRCodeScanBackgroundView.m
//  WestMailDutyFee
//
//  Created by 罗海雄 on 15/8/26.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMQRCodeScanBackgroundView.h"

/**边角位置
 */
typedef NS_ENUM(NSInteger, WMQRCodeScanCornerPosition)
{
    WMQRCodeScanCornerPositionUpperLeft = 0, ///左上
    WMQRCodeScanCornerPositionLowerLeft = 1, ///左下
    WMQRCodeScanCornerPositionUpperRight = 2, ///右上
    WMQRCodeScanCornerPositionLowerRight = 3, ///右下
};


@implementation WMQRCodeScanView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, WMQRCodeCornerLineWith);
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    
    [self drawCornerInContext:ctx wihtPosition:WMQRCodeScanCornerPositionUpperLeft];
    [self drawCornerInContext:ctx wihtPosition:WMQRCodeScanCornerPositionLowerLeft];
    [self drawCornerInContext:ctx wihtPosition:WMQRCodeScanCornerPositionUpperRight];
    [self drawCornerInContext:ctx wihtPosition:WMQRCodeScanCornerPositionLowerRight];
    
    CGContextStrokePath(ctx);
    
    CGContextSetLineWidth(ctx, 1.0);
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithWhite:1.0 alpha:0.7].CGColor);
    CGFloat right = rect.size.width - WMQRCodeCornerLineWith;
    CGFloat bottom = rect.size.height - WMQRCodeCornerLineWith;
    
    CGContextMoveToPoint(ctx, WMQRCodeCornerLineWith, WMQRCodeCornerLineWith);
    CGContextAddLineToPoint(ctx, WMQRCodeCornerLineWith, bottom);
    CGContextAddLineToPoint(ctx, right, bottom);
    CGContextAddLineToPoint(ctx, right, WMQRCodeCornerLineWith);
    CGContextAddLineToPoint(ctx, WMQRCodeCornerLineWith, WMQRCodeCornerLineWith);
    
    CGContextStrokePath(ctx);
}

/**绘制扫描区域边角
 */
- (void)drawCornerInContext:(CGContextRef) ctx wihtPosition:(WMQRCodeScanCornerPosition) position
{
    CGSize size = CGSizeMake(20, 20);
    CGPoint point = CGPointZero;
    
    switch (position)
    {
        case WMQRCodeScanCornerPositionUpperLeft :
        {
            size.width += point.x;
            size.height += point.y;
            
            CGContextMoveToPoint(ctx, point.x, size.height);
            CGContextAddLineToPoint(ctx, point.x, point.y);
            CGContextAddLineToPoint(ctx, size.width, point.y);
        }
            break;
        case WMQRCodeScanCornerPositionLowerLeft :
        {
            point.y += self.height - size.height;
            size.height += point.y;
            size.width += point.x;
            
            CGContextMoveToPoint(ctx, point.x, point.y);
            CGContextAddLineToPoint(ctx, point.x, size.height);
            CGContextAddLineToPoint(ctx, size.width, size.height);
        }
            break;
        case WMQRCodeScanCornerPositionUpperRight :
        {
            point.x += self.width - size.width;
            size.height += point.y;
            size.width += point.x;
            
            CGContextMoveToPoint(ctx, point.x, point.y);
            CGContextAddLineToPoint(ctx, size.width, point.y);
            CGContextAddLineToPoint(ctx, size.width, size.height);
        }
            break;
        case WMQRCodeScanCornerPositionLowerRight :
        {
            point.y += self.height - size.height;
            point.x += self.width - size.width;
            
            size.height += point.y;
            size.width += point.x;
            
            CGContextMoveToPoint(ctx, point.x, size.height);
            CGContextAddLineToPoint(ctx, size.width, size.height);
            CGContextAddLineToPoint(ctx, size.width, point.y);
        }
            break;
    }
}

@end



@interface WMQRCodeScanBackgroundView ()

/**扫描动画视图
 */
@property(nonatomic,strong) UIImageView *animationView;

/**二维码信息解析时的指示器
 */
@property(nonatomic,strong) UIActivityIndicatorView *actView;


/**提示信息
 */
@property(nonatomic,strong) UILabel *msgLabel;

/**部分控制图层，不被扫描的部分会覆盖黑色半透明
 */
@property (nonatomic, strong) UIView *overlayView;

/**扫描框
 */
@property (nonatomic,strong) WMQRCodeScanView *scanView;

@end

@implementation WMQRCodeScanBackgroundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        
        self.overlayView = [[UIView alloc] initWithFrame:self.bounds];
        self.overlayView.alpha = .5f;
        self.overlayView.backgroundColor = [UIColor blackColor];
        self.overlayView.userInteractionEnabled = NO;
        self.overlayView.opaque = NO;
        [self addSubview:self.overlayView];
        
        //扫描框大小
        CGFloat size = WMQRCodeScanBackgroundViewScanSize;
        _scanBoxRect = CGRectMake((frame.size.width - size) / 2.0, MIN((frame.size.height - size) / 2.0, 100.0f / 568.0f * _height_), size, size);
        _scanBoxSize = _scanBoxRect.size;
        
        _scanView = [[WMQRCodeScanView alloc] initWithFrame:CGRectMake(_scanBoxRect.origin.x - WMQRCodeCornerLineWith, _scanBoxRect.origin.y - WMQRCodeCornerLineWith, _scanBoxRect.size.width + WMQRCodeCornerLineWith * 2, _scanBoxRect.size.height + WMQRCodeCornerLineWith * 2)];
        [self addSubview:_scanView];
        
        _animationView = [[UIImageView alloc] initWithFrame:CGRectMake(self.scanBoxRect.origin.x, self.scanBoxRect.origin.y, size, 1.0)];
        _animationView.backgroundColor = [UIColor colorFromHexadecimal:@"#00a0e9"];
        _animationView.hidden = YES;
        [self addSubview:_animationView];
        
        _actView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _actView.center = CGPointMake(self.scanBoxRect.size.width / 2.0 + self.scanBoxRect.origin.x, self.scanBoxRect.origin.y + self.scanBoxRect.size.height / 2.0);
        [self addSubview:_actView];
        
        [_actView startAnimating];
        
        //绘制扫描区域
        [self overlayClipping];
        
        _msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.scanBoxRect.origin.y + self.scanBoxRect.size.height, self.width, 40.0)];
        _msgLabel.text = @"请将码放入框内，即可自动扫描";
        _msgLabel.font = [UIFont fontWithName:MainFontName size:15.0];
        _msgLabel.textColor = [UIColor whiteColor];
        _msgLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_msgLabel];
    }
    
    return self;
}

/**开始扫描动画
 */
- (void)startScanAnimate
{
    [_actView stopAnimating];
    self.backgroundColor = [UIColor clearColor];
    _animationView.hidden = NO;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.y"];
   // animation.autoreverses = YES;
    animation.removedOnCompletion = NO;
    animation.repeatCount = HUGE_VALF;
    animation.duration = 1.5;
    animation.fromValue = [NSNumber numberWithFloat:self.scanBoxRect.origin.y];
    animation.toValue = [NSNumber numberWithFloat:self.scanBoxRect.origin.y + self.scanBoxRect.size.height - _animationView.height];

    [_animationView.layer addAnimation:animation forKey:@"poitionAnimation"];
}

- (void)setScanBoxSize:(CGSize)scanBoxSize
{
    if(!CGSizeEqualToSize(_scanBoxSize, scanBoxSize))
    {
        _scanBoxSize = scanBoxSize;
        _scanBoxRect.size = _scanBoxSize;
        
        [UIView animateWithDuration:0.25 animations:^(void){
            
            _scanView.frame = CGRectMake(_scanBoxRect.origin.x - WMQRCodeCornerLineWith, _scanBoxRect.origin.y - WMQRCodeCornerLineWith, _scanBoxRect.size.width + WMQRCodeCornerLineWith * 2, _scanBoxRect.size.height + WMQRCodeCornerLineWith * 2);
            [self overlayClipping];
        }];
    }
}

/**停止扫描动画
 */
- (void)stopScanAnimate
{
    [_actView startAnimating];
    self.backgroundColor = [UIColor blackColor];
     _animationView.hidden = YES;
    [_animationView.layer removeAllAnimations];
}

//绘制裁剪区分图层
- (void)overlayClipping
{
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    CGMutablePathRef path = CGPathCreateMutable();
    
    //左边
    CGPathAddRect(path, nil, CGRectMake(0, 0,
                                        self.scanBoxRect.origin.x,
                                        self.overlayView.height));
    //右边
    CGFloat right = self.scanBoxRect.origin.x + self.scanBoxRect.size.width;
    CGPathAddRect(path, nil, CGRectMake(right,
                                        0,
                                        self.overlayView.width - right,
                                        self.overlayView.height));
    //上面
    CGPathAddRect(path, nil, CGRectMake(0, 0,
                                        self.overlayView.width,
                                        self.scanBoxRect.origin.y));
    //下面
    CGFloat bottom = self.scanBoxRect.origin.y + self.scanBoxRect.size.height;
    CGPathAddRect(path, nil, CGRectMake(0,
                                        bottom,
                                        self.overlayView.width,
                                        self.overlayView.height - bottom));
    maskLayer.path = path;
    self.overlayView.layer.mask = maskLayer;
    CGPathRelease(path);
}



@end

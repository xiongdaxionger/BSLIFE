//
//  WMCountDownView.m
//  WuMei
//
//  Created by 罗海雄 on 15/7/18.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "WMCountDownView.h"
#import "WMServerTimeOperation.h"

///起始tag
#define WMCountDownViewStartTag 1000
#define WMCountDownViewPointStartTag 1200

@interface WMCountDownView ()

//提示信息
@property(nonatomic,strong) UIButton *button;

//计时器
@property(nonatomic,strong) NSTimer *timer;

///计时结束
@property(nonatomic,strong) UILabel *endLabel;

///最后一个label
@property(nonatomic,readonly) UILabel *lastNumberLabel;
@property(nonatomic,readonly) UILabel *lastPointLabel;

@end

@implementation WMCountDownView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self initBaseInfo];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self initBaseInfo];
    }
    
    return self;
}

///初始化基本信息
- (void)initBaseInfo
{
    _accurate = WMCountDownAccurateHour;
    _pointTextColor = [UIColor grayColor];
    _numberBackgroundColor = WMRedColor;
    _numberTextColor = [UIColor whiteColor];
    _numberBorderWidth = 0;
    _numberBorderColor = nil;
    _numberFont = [UIFont fontWithName:MainNumberFontName size:12.0];
    _pointFont = [UIFont fontWithName:MainNumberFontName size:12.0];
    _numberSize = CGSizeMake(18.0, 15.0);
}

///初始化
- (void)initlization
{
    self.backgroundColor = [UIColor clearColor];
    //时钟图标和提示文字
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.enabled = NO;
    _button.adjustsImageWhenDisabled = NO;
    _button.translatesAutoresizingMaskIntoConstraints = NO;
    _button.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_button setTitleColor:MainGrayColor forState:UIControlStateNormal];
    _button.titleLabel.font = [UIFont fontWithName:MainFontName size:11.0];
    [_button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self addSubview:_button];
 
    NSDictionary *views = NSDictionaryOfVariableBindings(_button);
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:_button attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    constraint.priority = UILayoutPriorityDefaultHigh;
    [self addConstraint:constraint];
    
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_button]-0-|" options:0 metrics:nil views:views];
    [self addConstraints:constraints];
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_button(0)]" options:0 metrics:nil views:views];
    [self addConstraints:constraints];
    
    int count = 3;
    CGFloat width_n = self.numberSize.width;
    CGFloat width_p = 8.0;
    CGFloat height = self.numberSize.height;
    
    switch (_accurate)
    {
        case WMCountDownAccurateDay :
        {
            count = 4;
        }
            break;
        case WMCountDownAccurateHour :
        {
            count = 3;
        }
            break;
        default:
            break;
    }
    

    ///前一个视图
    UIView *previousView = _button;
    
    for(int i = 0;i < count;i ++)
    {
        ///数字
        UILabel *numberLabel = [self numberLabel];
        numberLabel.tag = WMCountDownViewStartTag + i;
        [self addSubview:numberLabel];
        
        
        views = NSDictionaryOfVariableBindings(previousView,numberLabel);
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[previousView]-0-[numberLabel(%f)]", width_n] options:0 metrics:nil views:views];
        [self addConstraints:constraints];
        
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[numberLabel(%f)]", height] options:0 metrics:nil views:views];
        [self addConstraints:constraints];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:numberLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:previousView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
        previousView = numberLabel;
        
        if(i < count - 1)
        {
            ///冒号点
            UILabel *pointLabel = [self pointLabel];
            [self addSubview:pointLabel];
            
            views = NSDictionaryOfVariableBindings(previousView,pointLabel);
            constraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[previousView]-0-[pointLabel(%f)]", width_p] options:0 metrics:nil views:views];
            [self addConstraints:constraints];
            
            constraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[pointLabel(%f)]", height] options:0 metrics:nil views:views];
            [self addConstraints:constraints];
            
            [self addConstraint:[NSLayoutConstraint constraintWithItem:pointLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:previousView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
            
            previousView = pointLabel;
            pointLabel.tag = WMCountDownViewPointStartTag + i;
        }
    }
    
    UILabel *label = [self lastNumberLabel];
    constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:label attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    constraint.priority = UILayoutPriorityDefaultLow;
    [self addConstraint:constraint];
}

- (void)setContentAlignment:(WMCountDownContentAlignment)contentAlignment
{
    if(_contentAlignment != contentAlignment)
    {
        _contentAlignment = contentAlignment;
        switch (_contentAlignment)
        {
            case WMCountDownContentAlignmentCenter :
            {
                
            }
                break;
            case WMCountDownContentAlignmentLeft :
            {
                self.lastNumberLabel.sea_rightLayoutConstraint.priority = UILayoutPriorityDefaultLow;
                self.button.sea_leftLayoutConstraint.priority = UILayoutPriorityDefaultHigh;
            }
                break;
            case WMCountDownContentAlignmentRight :
            {
                self.lastNumberLabel.sea_rightLayoutConstraint.priority = UILayoutPriorityDefaultHigh;
                self.button.sea_leftLayoutConstraint.priority = UILayoutPriorityDefaultLow;
            }
                break;
        }
    }
}

///数字label
- (UILabel*)numberLabel
{
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = _numberBackgroundColor;
    label.textColor = _numberTextColor;
    label.layer.cornerRadius = 3.0;
    label.layer.borderColor = _numberBorderColor.CGColor;
    label.layer.borderWidth = _numberBorderWidth;
    label.layer.masksToBounds = YES;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = _numberFont;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    
    return label;
}

///点label
- (UILabel*)pointLabel
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = _pointTextColor;
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = _pointFont;
    label.text = @":";
    label.translatesAutoresizingMaskIntoConstraints = NO;
    
    return label;
}

///设置图标
- (void)setIcon:(UIImage *)icon
{
    if(_icon != icon)
    {
        _icon = icon;
        [self.button setImage:icon forState:UIControlStateNormal];
        CGFloat width = [_text stringSizeWithFont:self.button.titleLabel.font contraintWith:_width_].width + icon.size.width + 2.0;
        self.button.sea_widthLayoutConstraint.constant = width;
    }
}

/**提示信息
 */
- (void)setText:(NSString *)text
{
    if(_text != text)
    {
        _text = text;
        [self.button setTitle:_text forState:UIControlStateNormal];
        CGFloat width = [_text stringSizeWithFont:self.button.titleLabel.font contraintWith:_width_].width + [self.button imageForState:UIControlStateNormal].size.width + 2.0;
        self.button.sea_widthLayoutConstraint.constant = width;
    }
}

#pragma mark- 计时器

/**开始计时
 */
- (void)startTimer;
{
    if(!self.timer)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
        
        //必须添加这个，否则UIScrollView 拖动的时候计时器会停止运行
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        
        
        [self.timer fire];
    }
}

/**结束计时
 */
- (void)stopTimer
{
    if(self.timer && [self.timer isValid])
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}

//倒计时
- (void)countDown:(id) sender
{
    if(self.timeInterval != 0)
    {
        [self setTimeHidden:NO];

        long long timeInterval = self.timeInterval - [[WMServerTimeOperation sharedInstance] time];
        
        if(timeInterval > 0)
        {
            long long result = timeInterval / 60;
            int second = (int)(timeInterval % 60);
            int minute = (int) result % 60;
            int hour = _accurate == WMCountDownAccurateHour ? (int)(result / 60) : (int)(result / 60 % 24);
            int day = (int)(result / (24 * 60));
            
            if(day == 0 || _accurate == WMCountDownAccurateHour)
            {
                [self labelForIndex:2].text = [NSString stringWithFormat:@"%02d",second];
                [self labelForIndex:1].text = [NSString stringWithFormat:@"%02d",minute];
                [self labelForIndex:0].text = [NSString stringWithFormat:@"%02d",hour];
                [self labelForIndex:3].hidden = YES;
                [self labelForIndex:3].sea_widthLayoutConstraint.constant = 0;
                [self pointLabelForIndex:2].sea_widthLayoutConstraint.constant = 0;
                [self pointLabelForIndex:2].hidden = YES;
            }
            else
            {
                [self labelForIndex:3].text = [NSString stringWithFormat:@"%02d",second];
                [self labelForIndex:2].text = [NSString stringWithFormat:@"%02d",minute];
                [self labelForIndex:1].text = [NSString stringWithFormat:@"%02d",hour];
                [self labelForIndex:0].text = [NSString stringWithFormat:@"%02d",day];
                [self labelForIndex:3].hidden = NO;
                [self pointLabelForIndex:2].hidden = NO;
                [self labelForIndex:3].sea_widthLayoutConstraint.constant = self.numberSize.width;
                [self pointLabelForIndex:2].sea_widthLayoutConstraint.constant = 15.0;
            }
            
            if(hour > 99 || day > 99)
            {
                [self labelForIndex:0].sea_widthLayoutConstraint.constant = self.numberSize.width + 10.0;
            }
            else
            {
                [self labelForIndex:0].sea_widthLayoutConstraint.constant = self.numberSize.width;
            }
        }
        else
        {
            self.timeInterval = 0;
            if([self.delegate respondsToSelector:@selector(countDownViewDidEnd:)])
            {
                [self.delegate countDownViewDidEnd:self];
            }
            else
            {
                [self timerEnd];
            }
        }
    }
    else
    {
        [self timerEnd];
    }
}

- (UILabel*)lastNumberLabel
{
    return [self labelForIndex:_accurate == WMCountDownAccurateDay ? 3 : 2];
}

- (UILabel*)lastPointLabel
{
    return [self pointLabelForIndex:2];
}

///获取对应的label
- (UILabel*)labelForIndex:(NSInteger) index
{
    return (UILabel*)[self viewWithTag:WMCountDownViewStartTag + index];
}

///获取对应的label
- (UILabel*)pointLabelForIndex:(NSInteger) index
{
    return (UILabel*)[self viewWithTag:WMCountDownViewPointStartTag + index];
}

- (BOOL)end
{
    return self.timeInterval == 0;
}

/**结束
 */
- (void)timerEnd
{
    [self stopTimer];
    if(!self.endLabel)
    {
        self.endLabel = [[UILabel alloc] init];
        self.endLabel.textColor = [self.button titleColorForState:UIControlStateNormal];
        self.endLabel.font = self.button.titleLabel.font;
        self.endLabel.text = @"活动已结束";
        
        self.endLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.endLabel];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_endLabel);
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_endLabel]-0-|" options:0 metrics:nil views:views];
        [self addConstraints:constraints];
        
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_endLabel]-0-|" options:0 metrics:nil views:views];
        [self addConstraints:constraints];
    }
    
    switch (self.contentAlignment)
    {
        case WMCountDownContentAlignmentLeft :
        {
            self.endLabel.textAlignment = NSTextAlignmentLeft;
        }
            break;
        case WMCountDownContentAlignmentRight :
        {
            self.endLabel.textAlignment = NSTextAlignmentRight;
        }
            break;
        case WMCountDownContentAlignmentCenter :
        {
            self.endLabel.textAlignment = NSTextAlignmentCenter;
        }
            break;
    }
    
    [self setTimeHidden:YES];
}

///显示倒计时
- (void)setTimeHidden:(BOOL) hidden
{
    if(self.button.hidden == hidden)
        return;
    
    self.endLabel.hidden = !hidden;
    self.button.hidden = hidden;
    
    int count = 3;
    switch (_accurate)
    {
        case WMCountDownAccurateDay :
        {
            count = 4;
        }
            break;
        case WMCountDownAccurateHour :
        {
            count = 3;
        }
            break;
        default:
            break;
    }
    
    for(int i = 0;i < count; i ++)
    {
        UILabel *label = [self labelForIndex:i];
        label.hidden = hidden;
        label = [self pointLabelForIndex:i];
        label.hidden = hidden;
    }
}

@end

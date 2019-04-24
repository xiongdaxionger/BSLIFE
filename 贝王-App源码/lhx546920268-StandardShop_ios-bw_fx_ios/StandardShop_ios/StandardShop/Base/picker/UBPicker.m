//
//  UBPicker.m

//

#import "UBPicker.h"
#import "WMBalanceOperation.h"
#import "WMShippingTimeInfo.h"
#import "SeaHttpRequest.h"

static NSTimeInterval oneYear = 24 * 60 * 60 * 365;

@interface UBPicker ()<SeaHttpRequestDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

//父视图
@property(nonatomic,weak) UIView *mySuperView;

//选择器上方的视图
@property(nonatomic,strong) UIView *topView;

//完成按钮
@property(nonatomic,strong) UIButton *finishButton;

//取消按钮
@property(nonatomic,strong) UIButton *cancelButton;

//菜单
@property(nonatomic,strong) UIView *menu;

//内容
@property(nonatomic,strong) UIView *contentView;

//网络请求
@property(nonatomic,strong) SeaHttpRequest *httpRequest;

//加载指示器
@property(nonatomic,strong) UIActivityIndicatorView *indicatorView;

//重新加载
@property(nonatomic,strong) UIButton *reloadButton;

//首次加载
@property (assign,nonatomic) BOOL isFirstLoad;

//选中
@property (assign,nonatomic) NSInteger selectRow;

@end

@implementation UBPicker

/**构造方法
 *@param superView 选择器父视图
 *@param style 选择器类型
 */
- (id)initWithSuperView:(UIView *)superView style:(UBPickerStyle)style
{
    CGFloat height = _UBPickerHeight_;
    self = [super initWithFrame:CGRectMake(0, _height_, superView.width, height)];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.mySuperView = superView;
                
        //菜单
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(-_separatorLineWidth_, 0, self.width + _separatorLineWidth_ * 2, 35.0)];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.borderWidth = _separatorLineWidth_;
        view.layer.borderColor = _separatorLineColor_.CGColor;
      
        self.menu = view;
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, height)];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        
        [_contentView addSubview:self.menu];
        
        CGFloat buttonWidth = 70.0;
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(buttonWidth, 0, self.menu.width - buttonWidth * 2, self.menu.height)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setTextColor:[UIColor blackColor]];
        [_titleLabel setFont:[UIFont fontWithName:MainFontName size:15.0]];
        [self.menu addSubview:_titleLabel];
        
        //完成
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(self.width - buttonWidth, 0, buttonWidth, _titleLabel.height)];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:@"完成" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(finish:) forControlEvents:UIControlEventTouchUpInside];
        [self.menu addSubview:btn];
        self.finishButton = btn;
        
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(0, 0, buttonWidth, _titleLabel.height)];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
        [self.menu addSubview:btn];
        self.cancelButton = btn;
        
        [self setCloseWhenTouchMargin:YES];
        
        self.httpRequest = [[SeaHttpRequest alloc] initWithDelegate:self];
        
        self.isFirstLoad = YES;
        
        self.selectRow = 0;
        
        if(style == UBPickerStyleBlank)
        {
            [self loadBlankInfo];
        }
        else{
            
            [self reloadDataWithStyle:style];
        }
    
        
    }
    return self;
}


//加载银行信息
- (void)loadBlankInfo
{
    
    [self addLoadingView];
    
    self.httpRequest.identifier = WMGetBankInfoIden;

    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMBalanceOperation blankListParams]];
}

- (void)addLoadingView{
    
    self.reloadButton.hidden = YES;
    if(!self.indicatorView)
    {
        self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.indicatorView.center = CGPointMake(self.contentView.width / 2.0, self.menu.bottom + (self.contentView.height - self.menu.bottom) / 2.0);
        [_contentView addSubview:self.indicatorView];
    }
    
    [_contentView bringSubviewToFront:self.indicatorView];
    
    [self.indicatorView startAnimating];
}

//加载失败
- (void)failToLoad
{
    if(!self.reloadButton)
    {
        CGFloat buttonWidth = 70.0;
        CGFloat buttonHeight = 30.0;
        _reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _reloadButton.layer.cornerRadius = 5.0;
        _reloadButton.layer.masksToBounds = YES;
        _reloadButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _reloadButton.layer.borderWidth = 1.0;
        _reloadButton.titleLabel.font = [UIFont fontWithName:MainFontName size:13.0];
        _reloadButton.frame = CGRectMake((self.contentView.width - buttonWidth) / 2.0, self.menu.bottom + (self.contentView.height - self.menu.bottom - buttonHeight) / 2.0, buttonWidth, buttonHeight);
        [_reloadButton setTitle:@"重新加载" forState:UIControlStateNormal];
        [_reloadButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_reloadButton addTarget:self action:@selector(loadBlankInfo) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_reloadButton];
    }
    
    [self.indicatorView stopAnimating];
    _reloadButton.hidden = NO;
}

#pragma mark- htpp

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
    [self failToLoad];
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{
    [self.indicatorView stopAnimating];
    
    if ([request.identifier isEqualToString:WMGetBankInfoIden]){
        
        self.infos = [WMBalanceOperation blankListFromData:data];
        
        if(self.infos.count > 0)
        {
            [self reloadDataWithStyle:UBPickerStyleBlank];
        }
        else
        {
            [self failToLoad];
        }
    }
}

#pragma mark- set property

- (void)setCloseWhenTouchMargin:(BOOL)closeWhenTouchMargin
{
    if(_closeWhenTouchMargin != closeWhenTouchMargin)
    {
        _closeWhenTouchMargin = closeWhenTouchMargin;
        if(!self.topView)
        {
            UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.mySuperView.width, self.mySuperView.height - _UBPickerHeight_)];
            topView.backgroundColor = [UIColor clearColor];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
            [topView addGestureRecognizer:tap];
            
            [self addSubview:topView];
            self.topView = topView;
        }
        
        if(_closeWhenTouchMargin)
        {
            self.topView.hidden = NO;
            self.height = self.mySuperView.height;
            self.contentView.top = self.topView.bottom;
            self.datePicker.top = self.menu.bottom;
        }
        else
        {
            self.topView.hidden = YES;
            self.contentView.top = 0;
            self.datePicker.top = self.menu.bottom;
        }
    }
}

#pragma mark- dealloc

- (void)dealloc
{
    
}

#pragma mark- publick method

/**呼出选择器
 *@param animated 是否动画
 *@param completion 出现后调用
 */
- (void)showWithAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    if([self.delegate respondsToSelector:@selector(pickerWillAppear:)])
    {
        [self.delegate pickerWillAppear:self];
    }
    
    if(self.superview == nil)
    {
        [self.mySuperView addSubview:self];
    }
    
    CGRect frame = CGRectMake(self.left, self.mySuperView.height - self.height, self.width, self.height);
    
    if(animated)
    {
        [UIView animateWithDuration:0.25 animations:^(void){
            self.frame = frame;
        }completion:^(BOOL finish){
            
            if(completion)
                completion();
            if([self.delegate respondsToSelector:@selector(pickerDidAppear:)])
            {
                [self.delegate pickerDidAppear:self];
            }
        }];
    }
    else
    {
        self.frame = frame;
        if(completion)
            completion();
        if([self.delegate respondsToSelector:@selector(pickerDidAppear:)])
        {
            [self.delegate pickerDidAppear:self];
        }
    }
}

/**隐藏选择器
 *@param animated 是否动画
 *@param completion 隐藏后调用
 */
- (void)dismissWithAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    if([self.delegate respondsToSelector:@selector(pickerWillDismiss:)])
    {
        [self.delegate pickerWillDismiss:self];
    }
    CGRect frame = CGRectMake(self.left, _height_, self.width, self.height);
    if(animated)
    {
        [UIView animateWithDuration:0.25 animations:^(void){
            self.frame = frame;
        }completion:^(BOOL finish){
            
            if(completion)
                completion();
            if([self.delegate respondsToSelector:@selector(pickerDidDismiss:)])
            {
                [self.delegate pickerDidDismiss:self];
            }
        }];
    }
    else
    {
        self.frame = frame;
        if(completion)
            completion();
        if([self.delegate respondsToSelector:@selector(pickerDidDismiss:)])
        {
            [self.delegate pickerDidDismiss:self];
        }
    }
}

//加载数据
- (void)reloadDataWithStyle:(UBPickerStyle)style
{
    _style = style;

    NSDate *date = nil;
    switch (style)
    {
        case UBPickerStyleBirthDay :
        {
            if(!self.datePicker)
            {
                _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.menu.bottom, self.width, _contentView.height - self.menu.height)];
                _datePicker.backgroundColor = [UIColor whiteColor];
                [_contentView addSubview:_datePicker];
            }

            _titleLabel.text = @"出生日期";
            self.datePicker.datePickerMode = UIDatePickerModeDate;
            self.datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:- oneYear];
            date = [NSDate dateWithTimeIntervalSinceNow:- oneYear * 20];
        }
            break;
        case UBPickerStyleBlank :
        {
            _titleLabel.text = @"银行";
        }
            break;
        case UBPickerStyleLogistics :
        {
            _titleLabel.text = @"物流公司";
        }
            break;
        case UBPickerStyleInvioce:
        {
            _titleLabel.text = @"发票内容";
        }
            break;
        case UBPickerStyleStoreSelfTime:
        {
            _titleLabel.text = @"自提时间";
        }
            break;
        case UBPickerStyleOrderCancelReason:
        {
            _titleLabel.text = @"取消订单原因";
        }
            break;
        case UBPickerStyleShippingTime:
        {
            _titleLabel.text = @"配送时间";
        }
            break;
    }

    if(self.datePicker)
    {
        if(date)
        {
            [self.datePicker setDate:date animated:NO];
        }
    }
    else
    {
        _picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.menu.bottom, self.width, _contentView.height - self.menu.height)];
        _picker.delegate = self;
        _picker.dataSource = self;
        [_contentView addSubview:_picker];
    }
}

#pragma mark- private method

//完成
- (void)finish:(UIButton*) button
{
    NSDictionary *dic = nil;
    switch (self.style)
    {
        case UBPickerStyleBirthDay :
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"YYYY-MM-dd"];
            [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/BeiJing"]];
            
            NSString *date = [formatter stringFromDate:self.datePicker.date];
            dic = [NSDictionary dictionaryWithObject:date forKey:[NSNumber numberWithInteger:self.style]];
        }
            break;
        case UBPickerStyleBlank :
        {
            NSString *str = [self.infos objectAtIndex:[_picker selectedRowInComponent:0]];
            dic = [NSDictionary dictionaryWithObjectsAndKeys:str, [NSNumber numberWithInteger:self.style], nil];
        }
            break;
        case UBPickerStyleLogistics :
        {
            NSString *str = [self.infos objectAtIndex:[_picker selectedRowInComponent:0]];
            
            dic = @{@"content":str};
//            NSString *idStr = [self.shippingIDArr objectAtIndex:[_picker selectedRowInComponent:0]];
//            dic = [NSDictionary dictionaryWithObjectsAndKeys:str, [NSNumber numberWithInteger:self.style], idStr,@"id",nil];
        }
            break;
        case UBPickerStyleInvioce:
        {
            NSString *content = [self.infos objectAtIndex:[_picker selectedRowInComponent:0]];
            
            dic = @{@"content":content};
        }
            break;
        case UBPickerStyleOrderCancelReason:
        {
                     
            dic = @{@"index":@([_picker selectedRowInComponent:0])};
        }
            break;
        case UBPickerStyleStoreSelfTime:
        {
            dic = [_infos objectAtIndex:[_picker selectedRowInComponent:0]];
        }
            break;
        case UBPickerStyleShippingTime:
        {
            WMShippingTimeInfo *info = [self.shippingTimeInfosArr objectAtIndex:self.selectRow];
            
            switch (info.type) {
                case ShippingTimeTypeSpecial:
                {
                    WMSpecialTimeZoneInfo *specialTimeInfo = [info.specialShippingTimeZones objectAtIndex:[self.picker selectedRowInComponent:1]];
                    
                    dic = @{@"timeValue":info.shippingTimeValue,@"time":specialTimeInfo.specialTime,@"timeZone":[specialTimeInfo.specialTimeZones objectAtIndex:[self.picker selectedRowInComponent:2]]};
                }
                    break;
                case ShippingTimeTypeNormal:
                {
                    NSDictionary *timeZoneDict = [info.shippingTimeZones objectAtIndex:[self.picker selectedRowInComponent:1]];
                    
                    dic = @{@"timeValue":info.shippingTimeValue,@"timeZone":[timeZoneDict sea_stringForKey:@"value"]};
                }
                    break;
                default:
                    break;
            }
        }
            break;
    }
    
    if([self.delegate respondsToSelector:@selector(picker:didFinisedWithConditions:)])
    {
        [self.delegate picker:self didFinisedWithConditions:dic];
    }
    [self dismiss:nil];
}

//取消
- (void)dismiss:(id) sender
{
    [self dismissWithAnimated:YES completion:^(void){
        [self removeFromSuperview];
    }];
}

#pragma mark- UIPickerView delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.style == UBPickerStyleShippingTime) {
        
        if (self.isFirstLoad) {
            
            WMShippingTimeInfo *info = [self.shippingTimeInfosArr objectAtIndex:0];
            
            switch (info.type) {
                case ShippingTimeTypeNormal:
                    return 2;
                    break;
                case ShippingTimeTypeSpecial:
                    return 3;
                    break;
                default:
                    break;
            }
        }
        else{
            
            WMShippingTimeInfo *info = [self.shippingTimeInfosArr objectAtIndex:self.selectRow];
            
            switch (info.type) {
                case ShippingTimeTypeNormal:
                    return 2;
                    break;
                case ShippingTimeTypeSpecial:
                    return 3;
                    break;
                default:
                    break;
            }
        }
    }
    else{
        
        return 1;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.style == UBPickerStyleShippingTime) {
        
        WMShippingTimeInfo *info = [self.shippingTimeInfosArr objectAtIndex:self.selectRow];

        if (!component) {
            
            return self.shippingTimeInfosArr.count;
        }
        else if(component == 1){
            
            switch (info.type) {
                case ShippingTimeTypeNormal:
                    return info.shippingTimeZones.count;
                    break;
                case ShippingTimeTypeSpecial:
                    return info.specialShippingTimeZones.count;
                default:
                    break;
            }
        }
        else{
                        
            WMSpecialTimeZoneInfo *specialTimeInfo = [info.specialShippingTimeZones objectAtIndex:[pickerView selectedRowInComponent:1]];
            
            return specialTimeInfo.specialTimeZones.count;
        }
    }
    else{
        
        return _infos.count;
    }
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (self.style) {
        case UBPickerStyleShippingTime:
        {
            WMShippingTimeInfo *selectInfo = [self.shippingTimeInfosArr objectAtIndex:self.selectRow];

            if (!component) {
                
                WMShippingTimeInfo *info = [self.shippingTimeInfosArr objectAtIndex:row];
                
                return info.shippingTimeName;
            }
            else if(component == 1){
                
                switch (selectInfo.type) {
                    case ShippingTimeTypeNormal:
                    {
                        NSDictionary *timeDict = [selectInfo.shippingTimeZones objectAtIndex:row];
                        
                        return [timeDict sea_stringForKey:@"name"];
                    }
                        break;
                    case ShippingTimeTypeSpecial:
                    {
                        WMSpecialTimeZoneInfo *timeInfo = [selectInfo.specialShippingTimeZones objectAtIndex:row];
                        
                        return timeInfo.specialTime;
                    }
                        break;
                    default:
                        break;
                }
            }
            else{
                
                WMSpecialTimeZoneInfo *specialTimeInfo = [selectInfo.specialShippingTimeZones objectAtIndex:[pickerView selectedRowInComponent:1]];

                return [specialTimeInfo.specialTimeZones objectAtIndex:row];
            }
        }
            break;
        default:
        {
            return [_infos objectAtIndex:row];
        }
            break;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (self.style == UBPickerStyleShippingTime) {
        
        self.isFirstLoad = NO;
        
        if (!component) {
            
            self.selectRow = row;
            
            [pickerView selectRow:0 inComponent:1 animated:NO];
            
            [pickerView reloadAllComponents];
        }
        else{
            
            WMShippingTimeInfo *timeInfo = [self.shippingTimeInfosArr objectAtIndex:self.selectRow];
            
            if (timeInfo.type == ShippingTimeTypeSpecial) {
                
                [pickerView reloadComponent:2];
            }
        }
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel* pickerLabel = (UILabel*)view;
    
    if (!pickerLabel){
        
        pickerLabel = [[UILabel alloc] init];
        
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    }

    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    
    return pickerLabel;
}









@end

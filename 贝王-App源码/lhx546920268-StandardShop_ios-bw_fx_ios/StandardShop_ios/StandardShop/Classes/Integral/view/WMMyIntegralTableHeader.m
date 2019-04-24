//
//  WMMyIntegralTableHeader.m
//  StandardShop
//
//  Created by 罗海雄 on 16/7/8.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMMyIntegralTableHeader.h"
#import "WMIntegralInfo.h"
#import "WMIntegralSignInViewController.h"

@implementation WMMyIntegralTableHeader

- (instancetype)init
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"WMMyIntegralTableHeader" owner:nil options:nil] lastObject];
    self.frame = CGRectMake(0, 0, _width_, 160.0);

    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.backgroundColor = WMRedColor;
    self.use_btn.titleLabel.font = [UIFont fontWithName:MainFontName size:15.0];
    [self.use_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.title_label.font = [UIFont fontWithName:MainFontName size:17.0];
    self.integral_label.font = [UIFont fontWithName:MainNumberFontName size:40.0];
    self.integral_label.adjustsFontSizeToFitWidth = YES;
    self.freeze_label.font = [UIFont fontWithName:MainFontName size:15.0];
}

- (void)setInfo:(WMIntegralInfo *)info
{
    if(_info != info)
    {
        _info = info;

        self.integral_label.text = info.availableIntegral;

        NSMutableString *string = [NSMutableString string];
        if(info.consumptionFreezeName)
        {
            [string appendString:info.consumptionFreezeName];
            [string appendFormat:@"：%@积分", info.consumptionFreezeIntegral];
        }

        if(info.obtainFreezeName)
        {
            if(info.consumptionFreezeName)
            {
                [string appendString:@"    "];
            }
            [string appendString:info.obtainFreezeName];
            [string appendFormat:@"：%@积分", info.obtainFreezeIntegral];
        }
        
        self.use_btn.hidden = [NSString isEmpty:_info.useTitle];
        [self.use_btn setTitle:_info.useTitle forState:UIControlStateNormal];

        self.freeze_label.text = string;
    }
}

///使用积分
- (IBAction)useAction:(id)sender
{
    ///判断上一个界面是否是签到界面
    UIViewController *vc = self.navigationController.presentingViewController;
    if([vc isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *nav = (UINavigationController*)vc;
        vc = [nav.viewControllers lastObject];
    }
    
    if([vc isKindOfClass:[WMIntegralSignInViewController class]])
    {
        vc = [self.navigationController.viewControllers lastObject];
        [vc back];
    }
    else
    {
        WMIntegralSignInViewController *integral = [[WMIntegralSignInViewController alloc] init];
        [SeaPresentTransitionDelegate pushViewController:integral useNavigationBar:YES parentedViewConttroller:self.navigationController];
    }
}

@end

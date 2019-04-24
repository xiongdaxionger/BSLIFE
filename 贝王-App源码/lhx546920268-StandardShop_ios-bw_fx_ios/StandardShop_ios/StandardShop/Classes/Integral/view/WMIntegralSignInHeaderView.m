//
//  WMIntegralSignInHeaderView.m
//  WanShoes
//
//  Created by 罗海雄 on 16/3/18.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "WMIntegralSignInHeaderView.h"
#import "WMMyIntegralViewController.h"
#import "WMShareActionSheet.h"
#import "WMIntegralSignInInfo.h"

@implementation WMIntegralSignInHeaderView

- (void)awakeFromNib {

    [super awakeFromNib];
    self.day_detail_label.font = [UIFont fontWithName:MainFontName size:15.0];
    self.msg_label.font = [UIFont fontWithName:MainFontName size:12.0];
    
    self.rule_title_label.textColor = WMRedColor;
    self.rule_title_label.font = _width_ == 320 ? [UIFont fontWithName:MainFontName size:16.0] : [UIFont fontWithName:MainFontName size:18.0];
    self.rule_subtitle_label.font = [UIFont fontWithName:MainFontName size:10.0];
    self.rule_subtitle_label.textColor = self.rule_title_label.textColor;
    
    self.rule_subtitle_label.text = @"首次签到+1\n连续签到7日+5\n连续签到15日+10\n连续签到30日+30\n";
    [self.share_btn setTitleColor:self.rule_subtitle_label.textColor forState:UIControlStateNormal];
    self.share_btn.titleLabel.font = [UIFont fontWithName:MainFontName size:15.0];
    [self.my_integral_btn setTitleColor:self.rule_subtitle_label.textColor forState:UIControlStateNormal];
    self.my_integral_btn.titleLabel.font = [UIFont fontWithName:MainFontName size:15.0];
    
    self.title_btn.tintColor = self.rule_title_label.textColor;
    [self.title_btn setTitleColor:self.title_btn.tintColor forState:UIControlStateNormal];
    self.title_btn.titleLabel.font = [UIFont fontWithName:MainFontName size:15.0];
    self.good_header_bg_view.hidden = YES;
    
    self.integral_money_imageView.userInteractionEnabled = YES;
    [self.integral_money_imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareAction:)]];
    
    self.integral_pig_imageView.userInteractionEnabled = YES;
    [self.integral_pig_imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myIntegralAction:)]];
}

///分享
- (IBAction)shareAction:(id)sender
{
    WMShareActionSheet *share = [[WMShareActionSheet alloc] init];
    share.shareContentView.shareType = WMShareTypeIntegralSignIn;
    share.shareContentView.navigationController = self.navigationController;
    share.shareContentView.integralSignInInfo = self.info;
    [share show];
}

///我的积分
- (IBAction)myIntegralAction:(id)sender
{
    ///判断上一个界面是否是我的积分界面
    UIViewController *vc = self.navigationController.presentingViewController;
    if([vc isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *nav = (UINavigationController*)vc;
        vc = [nav.viewControllers lastObject];
    }
    
    if([vc isKindOfClass:[WMMyIntegralViewController class]])
    {
        vc = [self.navigationController.viewControllers lastObject];
        [vc back];
    }
    else
    {
        WMMyIntegralViewController *myIntegral = [[WMMyIntegralViewController alloc] init];
        [SeaPresentTransitionDelegate pushViewController:myIntegral useNavigationBar:YES parentedViewConttroller:self.navigationController];
    }
}

- (void)setInfo:(WMIntegralSignInInfo *)info
{
    if(_info != info)
    {
        _info = info;
        
        [self.bg_imageVIew sea_setImageWithURL:_info.topImageURL];
        
        switch (_info.result)
        {
            case WMIntegralSignInResultActivityEnd :
            {
                self.day_detail_label.text = _info.message;
                self.msg_label.text = _info.message;
            }
                break;
            default:
            {
                self.day_detail_label.text = _info.continuousSignInDay;
                
                NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"连续签到%@天 +%@", _info.signInNearDay, _info.signInNearIntegral]];
                [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexadecimal:@"FFF100"] range:NSMakeRange(4, _info.signInNearDay.length)];
                [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexadecimal:@"FFF100"] range:NSMakeRange(text.length - _info.signInNearIntegral.length, _info.signInNearIntegral.length)];
                
                self.msg_label.attributedText = text;
                
            }
                break;
        }
        
        self.rule_subtitle_label.text = _info.rule;
    }
}

@end

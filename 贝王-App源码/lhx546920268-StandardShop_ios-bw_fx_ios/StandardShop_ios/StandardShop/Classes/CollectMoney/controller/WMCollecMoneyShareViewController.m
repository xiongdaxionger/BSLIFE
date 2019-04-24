//
//  WMCollecMoneyShareViewController.m
//  WestMailDutyFee
//
//  Created by 罗海雄 on 15/9/10.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMCollecMoneyShareViewController.h"
#import "WMShareActionSheet.h"
#import "WMCollectMoneyInfo.h"

@interface WMCollecMoneyShareViewController ()

@end

@implementation WMCollecMoneyShareViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.backItem = YES;
    self.title = @"收钱";
    self.view.backgroundColor = _SeaViewControllerBackgroundColor_;
    
    
    self.title_label.textColor = WMPriceColor;
    self.name_content_label.text = self.collectMoneyInfo.name;
    
    UIFont *font = self.share_content_view.titleFont;
    self.share_title_label.font = font;
    
    font = [UIFont fontWithName:MainFontName size:17.0];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"金额（元）：%@", self.collectMoneyInfo.amount]];
    [text addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, text.length)];
    [text addAttribute:NSForegroundColorAttributeName value:self.title_label.textColor range:[text.string rangeOfString:self.collectMoneyInfo.amount]];
    self.amount_label.attributedText = text;
    
    
    self.title_label.font = font;
    self.name_title_label.font = font;
    self.name_content_label.font = font;
    
    self.share_content_view.shareType = WMShareTypeCollectMoney;
    self.share_content_view.navigationController = self.navigationController;
    self.share_content_view.collectMoneyInfo = self.collectMoneyInfo;
    
    CGSize size = [self.collectMoneyInfo.name stringSizeWithFont:self.share_title_label.font contraintWith:_width_ - 10.0 - self.name_content_label.left];
    
    self.top_bgView_heightConstraint.constant = self.share_content_view.bottom + size.height;
    
    [self setBarItemsWithTitle:@"完成" icon:nil action:@selector(finish) position:SeaNavigationItemPositionRight];
    
}

//完成
- (void)finish
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end

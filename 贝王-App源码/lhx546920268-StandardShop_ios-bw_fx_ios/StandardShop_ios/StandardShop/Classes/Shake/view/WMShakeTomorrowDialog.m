//
//  WMShakeTomorrowDialog.m
//  WanShoes
//
//  Created by 罗海雄 on 16/3/17.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "WMShakeTomorrowDialog.h"

@implementation WMShakeTomorrowDialog

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.msg_label.font = [UIFont fontWithName:MainFontName size:15.0];
    self.tomorrow_btn.titleLabel.font = [UIFont fontWithName:MainFontName size:17.0];
    self.tomorrow_btn.layer.cornerRadius = 3.0;
    self.tomorrow_btn.layer.masksToBounds = YES;
    self.tomorrow_btn.layer.borderWidth = 2.0;
    self.tomorrow_btn.layer.borderColor = self.layer.borderColor;
    self.close_btn.backgroundColor = [UIColor colorWithCGColor:self.layer.borderColor];
    [self.close_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.message = @"客官，您今日已经玩够1次啦！古人说，凡事都要有节制哦！";
}

///关闭弹窗
- (IBAction)closeAction:(id)sender
{
    self.hidden = YES;
    !self.closeHandler ?: self.closeHandler();
}

- (IBAction)tomorrowAction:(id)sender
{
    self.hidden = YES;
    !self.closeHandler ?: self.closeHandler();
}

- (void)setMessage:(NSString *)message
{
    if(message == nil)
    {
        message = @"";
    }
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:message];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 10.0;
    style.alignment = NSTextAlignmentCenter;
    
    [text addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
    
    self.msg_label.attributedText = text;
}

- (void)setInfo:(WMShakeResultInfo *)info
{
    [super setInfo:info];
    self.message = info.message;
    
    switch (info.result)
    {
        case WMShakeResultShakeEnd :
        {
            [self.tomorrow_btn setTitle:@"明日再战" forState:UIControlStateNormal];
        }
            break;
        default:
        {
            [self.tomorrow_btn setTitle:@"确定" forState:UIControlStateNormal];
        }
            break;
    }
}

@end

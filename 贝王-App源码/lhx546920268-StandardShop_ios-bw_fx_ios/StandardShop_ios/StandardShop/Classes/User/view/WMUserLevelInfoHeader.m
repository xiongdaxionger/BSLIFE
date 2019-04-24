//
//  WMUserLevelInfoHeader.m
//  StandardShop
//
//  Created by 罗海雄 on 16/6/30.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMUserLevelInfoHeader.h"
#import "WMUserInfo.h"

@implementation WMUserLevelInfoHeader

- (instancetype)init
{
    WMUserLevelInfoHeader *view = [[[NSBundle mainBundle] loadNibNamed:@"WMUserLevelInfoHeader" owner:nil options:nil] lastObject];
    view.frame = CGRectMake(0, 0, _width_, 142.0);

    return view;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorFromHexadecimal:@"FF4444"];
    self.head_imageView.layer.cornerRadius = 63.0 / 2.0;
    self.head_imageView.layer.masksToBounds = YES;
    self.head_imageView.layer.borderWidth = 3.0;
    self.head_imageView.layer.borderColor = [UIColor colorFromHexadecimal:@"FF8F8F"].CGColor;

    self.name_label.font = [UIFont fontWithName:MainFontName size:16.0];

    self.level_label.font = [UIFont fontWithName:MainFontName size:13.0];
    self.level_label.textColor = [UIColor whiteColor];
    self.level_bgView.layer.cornerRadius = self.level_label.font.lineHeight / 2.0;
    self.level_bgView.backgroundColor = [UIColor colorFromHexadecimal:@"FF8F8F"];
    self.level_bgView.layer.masksToBounds = YES;
    self.levelup_msg_label.adjustsFontSizeToFitWidth = YES;

    self.level_progress_label.font = [UIFont fontWithName:MainFontName size:13.0];
    self.levelup_msg_label.font = [UIFont fontWithName:MainFontName size:13.0];
    self.levelup_msg_label.adjustsFontSizeToFitWidth = YES;

    self.level_progressView.trackColor = [UIColor clearColor];
    self.level_progressView.progressColor = [UIColor colorFromHexadecimal:@"FFF600" alpha:1.0];
    self.level_progressView.layer.borderColor = self.level_progressView.progressColor.CGColor;
    self.level_progressView.layer.borderWidth = 1.0;
    self.level_progressView.hideAfterFinish = NO;

    WMUserInfo *info = [WMUserInfo sharedUserInfo];
    self.name_label.text = info.displayName;
    [self.head_imageView sea_setImageWithURL:info.headImageURL];
    self.level_label.text = info.level;

    long long levelupExperience = [info.levelupExperience longLongValue];
    
    if(levelupExperience > 0)
    {
        long long curExperience = [info.experience longLongValue];
        
        float progress = (double)curExperience / (double)levelupExperience;
        if(progress < 0.01)
            progress = 0.01;
        
        self.level_progressView.progress = progress;

        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ / %@", info.experience, info.levelupExperience]];
        [string  addAttribute:NSForegroundColorAttributeName value:self.level_progressView.progressColor range:[string.string rangeOfString:info.experience]];
        
        self.level_progress_label.attributedText = string;
        if(info.nextLevel && curExperience < levelupExperience)
        {
            self.levelup_msg_label.text = [NSString stringWithFormat:@"即将晋升：%@", info.nextLevel];
        }
        else
        {
            self.levelup_msg_label.text = nil;
        }
        
        ///最大宽度
        CGFloat maxWidth = _width_ - 20.0 * 2 - 63.0 - 15.0 - 5.0;
        CGFloat experienceWidth = [self.level_progress_label.text stringSizeWithFont:self.level_progress_label.font contraintWith:maxWidth].width + 1.0;
        CGFloat levelWidth = [self.levelup_msg_label.text stringSizeWithFont:self.levelup_msg_label.font contraintWith:maxWidth].width + 1.0;
        
        ///宽度不够，内容信息换行
        if(experienceWidth + levelWidth > maxWidth)
        {
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.level_progress_label attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:MIN(maxWidth, experienceWidth)]];
            
            self.levelup_msg_label_leftLayoutConstraint.constant = - MIN(maxWidth, experienceWidth);
            self.levelup_msg_label_centerYLayoutConstraint.constant = self.level_progress_label.font.lineHeight / 2.0 + 10.0;
            self.levelup_msg_label.textAlignment = NSTextAlignmentLeft;
        }
    }
    else
    {
        self.level_progressView.progress = 1.0;
    }
}


@end

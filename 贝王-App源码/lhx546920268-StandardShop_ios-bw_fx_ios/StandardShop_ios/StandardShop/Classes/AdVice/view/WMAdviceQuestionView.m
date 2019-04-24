//
//  WMAdviceQuestionView.m
//  StandardShop
//
//  Created by mac on 16/6/3.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMAdviceQuestionView.h"

#import "WMAdviceQuestionInfo.h"
@implementation WMAdviceQuestionView

/**初始化
 */
- (instancetype)initWithInfo:(WMAdviceQuestionInfo *)info{
    
    self = [super init];
    
    if (self) {
        
        self.backgroundColor = _SeaViewControllerBackgroundColor_;
        
        CGFloat margin = 8.0;
        
        CGFloat timeWidth = 145.0;
        
        CGFloat labelHeight = 21.0;
        
        UIFont *font = [UIFont fontWithName:MainFontName size:15.0];
        
        UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, margin, _width_ - timeWidth - 3 * margin, labelHeight)];
        
        phoneLabel.font = font;
        
        phoneLabel.text = info.adviceUserName;
        
        phoneLabel.textAlignment = NSTextAlignmentLeft;
        
        [self addSubview:phoneLabel];
        
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_width_ - timeWidth - margin, margin, timeWidth, labelHeight)];
        
        timeLabel.font = [UIFont fontWithName:MainFontName size:11.0];
        
        timeLabel.text = info.adviceTime;
        
        timeLabel.textColor = [UIColor grayColor];
                
        timeLabel.textAlignment = NSTextAlignmentRight;
        
        [self addSubview:timeLabel];
        
        UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, phoneLabel.bottom + margin, labelHeight, labelHeight)];
        
        typeLabel.layer.cornerRadius = 3.0;
        
        typeLabel.layer.masksToBounds = YES;
        
        typeLabel.backgroundColor = WMPriceColor;
        
        typeLabel.textColor = [UIColor whiteColor];
        
        typeLabel.textAlignment = NSTextAlignmentCenter;
        
        typeLabel.font = font;
        
        typeLabel.text = @"Q";
        
        [self addSubview:typeLabel];
        
        CGFloat contentHeight = [info returnContentHeightCanReply:NO];
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(typeLabel.right + margin, phoneLabel.bottom + margin, _width_ - 45, contentHeight)];
        
        contentLabel.text = info.adviceContent;
        
        contentLabel.numberOfLines = 0;
        
        contentLabel.font = font;
        
        [self addSubview:contentLabel];
        
        self.height = contentLabel.bottom + margin;
    }
    
    return self;
}












@end

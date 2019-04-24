//
//  WMShakeResultCharacterDialog.m
//  WanShoes
//
//  Created by 罗海雄 on 16/3/16.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "WMShakeResultCharacterDialog.h"

@implementation WMShakeResultCharacterDialog

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.text_label.font = [UIFont fontWithName:MainFontName size:15.0];
   // self.text_label.textColor = WMRedColor;
}

- (void)setInfo:(WMShakeResultInfo *)info
{
    [super setInfo:info];
    self.text_label.text = info.message;
}

@end

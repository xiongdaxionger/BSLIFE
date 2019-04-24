//
//  SettingPageCustomViewCell.m
//  WuMei
//
//  Created by qsit on 15/7/30.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//
#define kTitleKey @"titleKey"
#define kContentKey @"contentKey"
#import "WMSettingPageCell.h"
#import "UITableViewCell+addLineForCell.h"
@implementation WMSettingPageCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    
    _settingCustomLabel.font = [UIFont fontWithName:MainFontName size:15];
    
    _settingCustomLabel.textColor = [UIColor colorFromHexadecimal:@"333333"];
    
    _settingCustomContentLabel.font = [UIFont fontWithName:MainFontName size:15];
    
    _settingCustomContentLabel.textColor = WMRedColor;
}


- (void)configureCellWithModel:(id)model{

    NSString *titleStr = [model objectForKey:kTitleKey];
    
    _settingCustomLabel.text = titleStr;
    
    id content = [model objectForKey:kContentKey];
    
    if ([content isKindOfClass:[NSString class]]) {
        
        _settingCustomContentLabel.hidden = NO;
        
        _settingCustomContentLabel.text = content;
        
        self.accessoryView = nil;
    }
    else{
        
        if ([titleStr isEqualToString:@"清除缓存"]) {
            
            _settingCustomContentLabel.hidden = NO;
            
            NSString *cache = [NSString stringWithFormat:@"%@",content];
            
            _settingCustomContentLabel.text = [NSString stringWithFormat:@"%.2fM",cache.doubleValue];
            
        }
        else{
            _settingCustomContentLabel.hidden = YES;
            
        }
        
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_gray"]];
    }
}

@end

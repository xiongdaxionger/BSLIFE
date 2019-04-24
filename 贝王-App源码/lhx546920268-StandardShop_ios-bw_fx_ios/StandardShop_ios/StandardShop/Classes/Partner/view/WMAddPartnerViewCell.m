//
//  AddCustomerTableViewCell.m
//  WestMailDutyFee
//
//  Created by mac on 15/8/26.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMAddPartnerViewCell.h"

@implementation WMAddPartnerViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [_icon_imageView.layer setCornerRadius:_icon_imageView.height / 2.0];
    [_icon_imageView.layer setMasksToBounds:YES];
    
    
    _title_label.textColor = [UIColor blackColor];
    _title_label.font = [UIFont fontWithName:MainFontName size:16.0];
    
    _intro_label.font = [UIFont fontWithName:MainFontName size:14.0];
    _intro_label.numberOfLines = 0;
}


- (void)setDic:(NSDictionary *)dic
{
    if (_dic != dic)
    {
        _dic = dic;
        _icon_imageView.image = [UIImage imageNamed:[dic sea_stringForKey:@"imagename"]];
        
        [_title_label setText:[NSString stringWithFormat:@"%@",[dic sea_stringForKey:@"invite"]]];
        [_intro_label setText:[NSString stringWithFormat:@"%@",[dic sea_stringForKey:@"content"]]];
    }
}
@end

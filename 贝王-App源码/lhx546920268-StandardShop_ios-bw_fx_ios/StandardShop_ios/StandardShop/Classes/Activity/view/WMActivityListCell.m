//
//  WMActivityListCell.m
//  StandardShop
//
//  Created by 罗海雄 on 16/6/30.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMActivityListCell.h"
#import "WMActivityInfo.h"
#import "WMCustomerServiceInfo.h"

@implementation WMActivityListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.title_label.font = [UIFont fontWithName:MainFontName size:13.0];
    
    self.bottom_line.sea_heightLayoutConstraint.constant = _separatorLineWidth_;
    self.right_line.sea_widthLayoutConstraint.constant = _separatorLineWidth_;
    self.bottom_line.backgroundColor = _separatorLineColor_;
    self.right_line.backgroundColor = _separatorLineColor_;
    self.icon_imageView.sea_originContentMode = UIViewContentModeScaleAspectFit;
}

- (void)setInfo:(WMActivityInfo *)info
{
    _info = info;
    [self.icon_imageView sea_setImageWithURL:_info.imageURL];
    self.title_label.text = _info.name;
    self.icon_imageView.hidden = _info == nil;
    self.title_label.hidden = _info == nil;
}

- (void)setCustomerInfo:(WMCustomerServiceInfo *)customerInfo{
    self.icon_imageView.contentMode = UIViewContentModeCenter;
    _customerInfo = customerInfo;
    self.icon_imageView.image = [UIImage imageNamed:_customerInfo.imageName];
    self.title_label.text = _customerInfo.name;
    self.icon_imageView.hidden = _customerInfo == nil;
    self.title_label.hidden = _customerInfo == nil;
}

- (void)setIndex:(NSInteger)index
{
    if(_index != index)
    {
        _index = index;
        
        if((_index + 1) % WMActivityListCellCountPerRow == 0)
        {
            self.right_line.hidden = YES;
        }
        else
        {
            self.right_line.hidden = NO;
        }
    }
}

@end

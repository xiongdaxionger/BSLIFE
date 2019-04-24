//
//  WMImageCodeViewCell.m
//  StandardShop
//
//  Created by mac on 16/7/1.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMImageCodeViewCell.h"
#import "WMImageVerificationCodeView.h"

@implementation WMImageCodeViewCell

- (void)awakeFromNib {

    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _imageCodeView.textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8.0, _imageCodeView.height)];
}

@end

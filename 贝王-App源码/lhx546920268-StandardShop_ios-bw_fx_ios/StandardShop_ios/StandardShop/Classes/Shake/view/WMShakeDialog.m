//
//  WMShakeDialog.m
//  WanShoes
//
//  Created by 罗海雄 on 16/3/16.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMShakeDialog.h"

@implementation WMShakeDialog

- (instancetype)init
{
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.borderColor = [UIColor colorFromHexadecimal:@"BB1316"].CGColor;
    self.layer.borderWidth = 5.0;
    self.layer.cornerRadius = 5.0;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor colorFromHexadecimal:@"e53b52"];
}

@end

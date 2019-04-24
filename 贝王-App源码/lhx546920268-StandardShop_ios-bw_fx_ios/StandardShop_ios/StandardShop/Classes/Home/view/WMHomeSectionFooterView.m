//
//  WMHomeSectionFooterView.m
//  StandardShop
//
//  Created by 罗海雄 on 16/11/18.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMHomeSectionFooterView.h"

@implementation WMHomeSectionFooterView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.line.backgroundColor = _separatorLineColor_;
}

@end

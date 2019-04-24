//
//  WMPartIntroInfo.m
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/3.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMPartnerIntroInfo.h"

@implementation WMPartnerIntroInfo

- (id)init
{
    self = [super init];
    if(self)
    {
        self.contentHeight = WMPartnerIntroCellFont.lineHeight;
    }
    
    return self;
}

- (void)setTitle:(NSString *)title
{
    if(![_title isEqualToString:title])
    {
        _title = title;
        self.titleWidth = [_title stringSizeWithFont:WMPartnerIntroCellFont contraintWith:_width_ - WMPartnerIntroCellMargin * 2 - WMPartnerIntroCellControlInterval].width;
    }
}

- (void)setContent:(NSString *)content
{
    if(![_content isEqualToString:content])
    {
        _content = content;
        
        UIFont *font = WMPartnerIntroCellFont;
        CGFloat height = [_content stringSizeWithFont:font contraintWith:_width_ - WMPartnerIntroCellMargin * 2 - WMPartnerIntroCellControlInterval - _titleWidth].height;
        
        self.contentHeight = MAX(height, font.lineHeight);
    }
}

/**构造方法
 */
+ (instancetype)infoWithTitle:(NSString*) title content:(NSString*) content
{
    WMPartnerIntroInfo *info = [[WMPartnerIntroInfo alloc] init];
    info.title = title;
    info.content = content;
    
    return info;
}

@end

//
//  WMMessageTimeSectionHeader.m
//  StandardShop
//
//  Created by 罗海雄 on 16/7/15.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMMessageTimeSectionHeader.h"

@implementation WMMessageTimeSectionHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if(self)
    {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _width_, WMMessageTimeSectionHeaderHeight)];
        _timeLabel.textColor = [UIColor grayColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = [UIFont fontWithName:MainFontName size:13.0];
        [self.contentView addSubview:_timeLabel];

        self.contentView.backgroundColor = [UIColor clearColor];
    }

    return self;
}
@end

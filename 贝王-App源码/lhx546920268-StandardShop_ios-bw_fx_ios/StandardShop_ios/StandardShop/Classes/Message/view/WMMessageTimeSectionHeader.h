//
//  WMMessageTimeSectionHeader.h
//  StandardShop
//
//  Created by 罗海雄 on 16/7/15.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

///消息时间
#define WMMessageTimeSectionHeaderHeight 45.0

///消息时间
@interface WMMessageTimeSectionHeader : UITableViewHeaderFooterView

///时间
@property(nonatomic,readonly) UILabel *timeLabel;

@end

//
//  WMMessageWealthEarningsListCell.h
//  StandardShop
//
//  Created by 罗海雄 on 16/7/18.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMMessageInfo;

///边距
#define WMMessageWealthEarningsListCellMargin 10.0

///财富 收益消息
@interface WMMessageWealthEarningsListCell : UITableViewCell

///标题
@property (weak, nonatomic) IBOutlet UILabel *title_label;

///副标题
@property (weak, nonatomic) IBOutlet UILabel *subtitle_label;

///消息
@property (strong, nonatomic) WMMessageInfo *info;

///行高
+ (CGFloat)rowHeightForInfo:(WMMessageInfo*) info;


@end

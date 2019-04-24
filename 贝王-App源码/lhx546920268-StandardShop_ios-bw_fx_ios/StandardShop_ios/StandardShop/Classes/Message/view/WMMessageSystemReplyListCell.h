//
//  WMMessageSystemReplyListCell.h
//  StandardShop
//
//  Created by 罗海雄 on 16/8/1.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMMessageSystemInfo;

///系统回复
@interface WMMessageSystemReplyListCell : UITableViewCell

///标签
@property (weak, nonatomic) IBOutlet UILabel *mark_label;

///标题
@property (weak, nonatomic) IBOutlet UILabel *title_label;

///时间
@property (weak, nonatomic) IBOutlet UILabel *time_label;

///内容
@property (weak, nonatomic) IBOutlet UILabel *content_label;

///消息内容
@property (strong, nonatomic) WMMessageSystemInfo *info;

///行高
+ (CGFloat)rowHeightForInfo:(WMMessageSystemInfo*) info;

@end

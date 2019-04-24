//
//  WuliuTableViewCell.h
//  WuMei
//
//  Created by mac on 15/7/29.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMLogisticsDetailInfo;

///内容边距
#define WMLogisticsListCellMargin 41.0

///物流列表
@interface WMLogisticsListCell : UITableViewCell

///左边底部线条
@property (weak, nonatomic) IBOutlet UIView *left_bottom_line;

///高亮红点、普通灰点
@property (weak, nonatomic) IBOutlet UIImageView *point_imageView;

///内容
@property (weak, nonatomic) IBOutlet UILabel *content_label;

///时间
@property (weak, nonatomic) IBOutlet UILabel *time_label;

///左边顶部线条
@property (weak, nonatomic) IBOutlet UIView *left_top_line;

///物流信息
@property(nonatomic,strong) WMLogisticsDetailInfo *info;

///通过物流信息获取cell高度
+ (CGFloat)rowHeightWithInfo:(WMLogisticsDetailInfo*) info;

@end

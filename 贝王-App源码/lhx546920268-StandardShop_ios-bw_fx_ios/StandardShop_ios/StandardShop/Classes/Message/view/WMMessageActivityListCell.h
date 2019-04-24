//
//  WMMessageActivityListCell.h
//  StandardShop
//
//  Created by 罗海雄 on 16/7/15.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

///边界
#define WMMessageActivityListCellMargin 10.0

@class WMMessageActivityInfo;

///活动消息
@interface WMMessageActivityListCell : UITableViewCell

///标题
@property (weak, nonatomic) IBOutlet UILabel *title_label;

///图片
@property (weak, nonatomic) IBOutlet UIImageView *b_imageView;

///活动结束
@property (weak, nonatomic) IBOutlet UILabel *end_label;

///简介
@property (weak, nonatomic) IBOutlet UILabel *intro_label;

///分割线
@property (weak, nonatomic) IBOutlet UIView *line;

///查看详情
@property (weak, nonatomic) IBOutlet UILabel *detail_label;

///箭头
@property (weak, nonatomic) IBOutlet UIImageView *arrow_imageView;

///活动消息
@property (strong, nonatomic) WMMessageActivityInfo *info;

///行高
+ (CGFloat)rowHeightForInfo:(WMMessageActivityInfo*) info;

@end

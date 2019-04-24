//
//  WMMessageNoticeListCell.h
//  StandardShop
//
//  Created by 罗海雄 on 16/7/15.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMMessageNoticeInfo;

///商城公告消息列表
@interface WMMessageNoticeListCell : UITableViewCell

///标题
@property (weak, nonatomic) IBOutlet UILabel *title_label;

///副标题
@property (weak, nonatomic) IBOutlet UILabel *subtitle_label;

///箭头
@property (weak, nonatomic) IBOutlet UIImageView *arrow_imageView;

///图标
@property (weak, nonatomic) IBOutlet UIImageView *icon_imageView;

///红点
@property (weak, nonatomic) IBOutlet UIView *red_point;

///消息
@property (strong, nonatomic) WMMessageNoticeInfo *info;

@end

//
//  WMMessageOrderListCell.h
//  StandardShop
//
//  Created by 罗海雄 on 16/7/15.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMMessageOrderInfo;

///边距
#define WMMessageOrderListCellMargin 10.0

///行高
#define WMMessageOrderListCellHeight 111.0

///订单消息列表
@interface WMMessageOrderListCell : UITableViewCell

///标题
@property (weak, nonatomic) IBOutlet UILabel *title_label;

///物流
@property (weak, nonatomic) IBOutlet UILabel *logistics_label;

///商品图片
@property (weak, nonatomic) IBOutlet UIImageView *good_imageView;

///简介
@property (weak, nonatomic) IBOutlet UILabel *intro_label;

///订单消息
@property (strong, nonatomic) WMMessageOrderInfo *info;

@end

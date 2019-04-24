//
//  WMMessageSystemGoodListCell.h
//  StandardShop
//
//  Created by 罗海雄 on 16/7/15.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMGoodInfo;

///行高
#define WMMessageSystemGoodListCellHeight 95.0

///系统消息商品列表
@interface WMMessageSystemGoodListCell : UITableViewCell

///商品图片
@property (weak, nonatomic) IBOutlet UIImageView *good_imageView;

///商品名称
@property (weak, nonatomic) IBOutlet UILabel *name_label;

///箭头
@property (weak, nonatomic) IBOutlet UIImageView *arrow_imageView;

///商品信息
@property (strong, nonatomic) WMGoodInfo *info;

@end

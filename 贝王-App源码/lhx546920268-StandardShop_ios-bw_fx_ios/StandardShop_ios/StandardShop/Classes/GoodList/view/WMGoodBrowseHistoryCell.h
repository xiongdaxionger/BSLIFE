//
//  WMGoodBrowseHistoryCell.h
//  StandardShop
//
//  Created by 罗海雄 on 16/6/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

///行高
#define WMGoodBrowseHistoryCellHeight 114.0

@class WMGoodInfo;

///商品浏览记录cell
@interface WMGoodBrowseHistoryCell : UITableViewCell

///商品图片
@property (weak, nonatomic) IBOutlet UIImageView *good_imageView;

///商品名称
@property (weak, nonatomic) IBOutlet UILabel *name_label;

///价格
@property (weak, nonatomic) IBOutlet UILabel *price_label;

///商品信息
@property (strong, nonatomic) WMGoodInfo *info;

@end

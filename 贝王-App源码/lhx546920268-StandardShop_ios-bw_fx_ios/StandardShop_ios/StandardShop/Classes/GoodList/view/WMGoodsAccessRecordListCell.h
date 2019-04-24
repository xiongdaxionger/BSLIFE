//
//  WMGoodsAccessRecordListCell.h
//  StandardShop
//
//  Created by 罗海雄 on 2017/11/24.
//  Copyright © 2017年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMGoodsAccessRecordInfo;

///存取记录
@interface WMGoodsAccessRecordListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goods_imageView;
@property (weak, nonatomic) IBOutlet UILabel *goods_name_label;
@property (weak, nonatomic) IBOutlet UILabel *store_name_label;
@property (weak, nonatomic) IBOutlet UILabel *time_label;
@property (weak, nonatomic) IBOutlet UILabel *count_label;

///存取信息
@property(nonatomic, strong) WMGoodsAccessRecordInfo *info;

@end

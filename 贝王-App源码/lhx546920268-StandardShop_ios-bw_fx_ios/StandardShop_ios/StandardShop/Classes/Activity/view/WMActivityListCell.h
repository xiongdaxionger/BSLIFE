//
//  WMActivityListCell.h
//  StandardShop
//
//  Created by 罗海雄 on 16/6/30.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

///边距
#define WMActivityListCellMargin 0

///每行数量
#define WMActivityListCellCountPerRow 3

///行高
#define WMActivityListCellSize CGSizeMake((_width_ - WMActivityListCellMargin * 2) / WMActivityListCellCountPerRow, (_width_ - WMActivityListCellMargin * 2) / WMActivityListCellCountPerRow)

@class WMActivityInfo;
@class WMCustomerServiceInfo;

///活动列表cell
@interface WMActivityListCell : UICollectionViewCell

///图标
@property (weak, nonatomic) IBOutlet UIImageView *icon_imageView;

///标题
@property (weak, nonatomic) IBOutlet UILabel *title_label;


///右边线条
@property (weak, nonatomic) IBOutlet UIView *right_line;

///底部线条
@property (weak, nonatomic) IBOutlet UIView *bottom_line;

///信息
@property(nonatomic,strong) WMActivityInfo *info;

///客服信息
@property(nonatomic,strong) WMCustomerServiceInfo *customerInfo;

///下标
@property(nonatomic,assign) NSInteger index;

@end

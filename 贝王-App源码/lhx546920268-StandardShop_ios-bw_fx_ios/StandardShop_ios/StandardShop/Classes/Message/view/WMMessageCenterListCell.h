//
//  WMMessageCenterListCell.h
//  StandardShop
//
//  Created by 罗海雄 on 16/7/15.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMMessageCenterInfo;

///边距
#define WMMessageCenterListCellMargin 0

///每行数量
#define WMMessageCenterListCellCountPerRow 3

///行高
#define WMMessageCenterListCellSize CGSizeMake((_width_ - WMMessageCenterListCellMargin * 2) / WMMessageCenterListCellCountPerRow, (_width_ - WMMessageCenterListCellMargin * 2) / WMMessageCenterListCellCountPerRow)


///消息中心列表
@interface WMMessageCenterListCell : UICollectionViewCell

///图标
@property (weak, nonatomic) IBOutlet UIImageView *icon_imageView;

///红点
@property (weak, nonatomic) IBOutlet UIView *red_point;

///标题
@property (weak, nonatomic) IBOutlet UILabel *title_label;

///右边线条
@property (weak, nonatomic) IBOutlet UIView *right_line;

///底部线条
@property (weak, nonatomic) IBOutlet UIView *bottom_line;

///消息中心信息
@property(nonatomic,strong) WMMessageCenterInfo *info;

///下标
@property(nonatomic,assign) NSInteger index;

@end

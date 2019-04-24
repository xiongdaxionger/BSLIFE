//
//  WMMeListCell.h
//  WanShoes
//
//  Created by 罗海雄 on 16/3/14.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WMMeListCellHeight 45.0

///个人中心列表
@interface WMMeListCell : UITableViewCell

///图标
@property (weak, nonatomic) IBOutlet UIImageView *icon_imageView;

///标题
@property (weak, nonatomic) IBOutlet UILabel *title_label;

///内容
@property (weak, nonatomic) IBOutlet UILabel *content_label;

///箭头
@property (weak, nonatomic) IBOutlet UIImageView *arrow;

@end

///个人中心列表，没有图标
@interface WMMeListNoIconCell : UITableViewCell

///标题
@property (readonly, nonatomic) UILabel *title_label;

///箭头
@property (readonly, nonatomic) UIImageView *arrow;

@end

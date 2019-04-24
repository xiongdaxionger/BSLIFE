//
//  WMBalanceListCell.h
//  StandardShop
//
//  Created by 罗海雄 on 16/7/5.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMBalanceListInfo;

///大小
#define WMBalanceListCellSize CGSizeMake(_width_ / 2, 80.0)

///余额列表
@interface WMBalanceListCell : UICollectionViewCell

///标题
@property (weak, nonatomic) IBOutlet UILabel *title_label;

///问号按钮
@property (weak, nonatomic) IBOutlet UIButton *question_btn;

///金额
@property (weak, nonatomic) IBOutlet UILabel *amount_label;

///余额列表信息
@property(nonatomic,strong) WMBalanceListInfo *info;

@end

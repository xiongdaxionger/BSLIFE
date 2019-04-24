//
//  WMGoodCommentScoreSelectCell.h
//  StandardShop
//
//  Created by 罗海雄 on 16/6/29.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMGoodCommentScoreView, WMGoodCommentScoreInfo;

///高度
#define WMGoodCommentScoreSelectCellHeight 45.0

///商品评价，评分选择，静态cell可通过init方法初始化
@interface WMGoodCommentScoreSelectCell : UITableViewCell

///标题
@property(nonatomic,readonly) UILabel *titleLabel;

///评分选择
@property(nonatomic,readonly) WMGoodCommentScoreView *scoreView;

///关联的评分项
@property(nonatomic,strong) WMGoodCommentScoreInfo *info;

@end

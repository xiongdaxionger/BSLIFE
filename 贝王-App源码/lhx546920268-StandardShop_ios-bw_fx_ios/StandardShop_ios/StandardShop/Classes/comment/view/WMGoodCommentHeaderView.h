//
//  WMGoodCommentHeaderView.h
//  StandardShop
//
//  Created by 罗海雄 on 16/6/1.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMGoodCommentOverallInfo,WMGoodCommentScoreProgressView;

///商品评论列表表头
@interface WMGoodCommentHeaderView : UIView

///总评标题
@property (weak, nonatomic) IBOutlet UILabel *total_title_label;

///总评比例
@property (weak, nonatomic) IBOutlet WMGoodCommentScoreProgressView *total_proressView;

///总评评分
@property (weak, nonatomic) IBOutlet UILabel *total_score_label;

///商品包装标题
@property (weak, nonatomic) IBOutlet UILabel *package_title_label;

///送货速度标题
@property (weak, nonatomic) IBOutlet UILabel *logistics_title_label;

///商品质量标题
@property (weak, nonatomic) IBOutlet UILabel *quality_title_label;

///商品包装比例
@property (weak, nonatomic) IBOutlet WMGoodCommentScoreProgressView *package_progressView;

///送货速度比例
@property (weak, nonatomic) IBOutlet WMGoodCommentScoreProgressView *logistics_progressView;

///商品质量比例
@property (weak, nonatomic) IBOutlet WMGoodCommentScoreProgressView *quality_progressView;

///商品包装评分
@property (weak, nonatomic) IBOutlet UILabel *package_score_label;

///送货速度评分
@property (weak, nonatomic) IBOutlet UILabel *logistics_score_label;

///商品质量评分

@property (weak, nonatomic) IBOutlet UILabel *quality_score_label;

///分割线
@property (weak, nonatomic) IBOutlet UIView *line;


///总评信息
@property (strong, nonatomic) WMGoodCommentOverallInfo *info;

@end

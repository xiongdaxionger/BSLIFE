//
//  WMGoodCommentListCell.h
//  StandardShop
//
//  Created by 罗海雄 on 16/6/2.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMGridImageView,WMGoodCommentScoreView,WMGoodCommentInfo;

@class WMGoodCommentListCell;

///商品评论代理
@protocol WMGoodCommentListCellDelegate <NSObject>

///评论回复收缩状态改变
- (void)goodCommentListCellExpandStateDidChange:(WMGoodCommentListCell*) cell;

///回复评论
- (void)goodCommentListCellDidReply:(WMGoodCommentListCell*) cell;

@end

///商品评论列表
@interface WMGoodCommentListCell : UITableViewCell

///头像
@property (weak, nonatomic) IBOutlet UIImageView *head_imageView;

///昵称
@property (weak, nonatomic) IBOutlet UILabel *name_label;

///时间
@property (weak, nonatomic) IBOutlet UILabel *time_label;

///用户等级背景
@property (weak, nonatomic) IBOutlet UIView *level_bg_view;

///用户等级
@property (weak, nonatomic) IBOutlet UILabel *level_label;

///评分
@property (weak, nonatomic) IBOutlet WMGoodCommentScoreView *score_view;

///内容
@property (weak, nonatomic) IBOutlet UILabel *content_label;

///内容高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *content_heightLayoutConstraint;

///回复内容
@property (weak, nonatomic) IBOutlet UILabel *reply_content_label;

///回复内容高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reply_content_heightLayoutConstraint;

///回复内容顶部约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reply_content_topLayoutConstraint;

///图片
@property (weak, nonatomic) IBOutlet WMGridImageView *grid_imageView;

///图片高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *grid_imageView_heightLayoutConstraint;

///更多按钮
@property (weak, nonatomic) IBOutlet UIButton *more_btn;

///回复按钮
@property (weak, nonatomic) IBOutlet UIButton *reply_btn;

///评论信息
@property (strong, nonatomic) WMGoodCommentInfo *info;

@property (weak, nonatomic) id<WMGoodCommentListCellDelegate> delegate;


///获取行高
+ (CGFloat)rowHeightForInfo:(WMGoodCommentInfo*) info;

@end

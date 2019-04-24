//
//  WMFoundCommentListCell.h
//  WanShoes
//
//  Created by 罗海雄 on 16/3/23.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMFoundCommentInfo,WMFoundCommentListCell;

///评论列表代理
@protocol WMFoundCommentListCellDelegate <NSObject>

///点击头像
- (void)foundCommentListCellHeaderImageDidTap:(WMFoundCommentListCell*) cell;

@end

///发现评论列表cell
@interface WMFoundCommentListCell : UITableViewCell

///头像
@property (weak, nonatomic) IBOutlet UIImageView *head_imageView;

///昵称
@property (weak, nonatomic) IBOutlet UILabel *name_label;

///时间
@property (weak, nonatomic) IBOutlet UILabel *time_label;

///评论内容
@property (weak, nonatomic) IBOutlet UILabel *content_label;

///等级背景
@property (weak, nonatomic) IBOutlet UIView *level_bgView;

///等级
@property (weak, nonatomic) IBOutlet UILabel *level_label;

///评论信息
@property (strong, nonatomic) WMFoundCommentInfo *info;

@property (weak, nonatomic) id<WMFoundCommentListCellDelegate> delegate;

///通过评论信息计算行高
+ (CGFloat)rowHeightWithInfo:(WMFoundCommentInfo*) info;

@end

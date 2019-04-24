//
//  WMFoundHomePostListCell.h
//  SuYan
//
//  Created by 罗海雄 on 16/4/29.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMFoundListInfo;

///边距
#define WMFoundHomePostListCellMargin 10.0

///大小
#define WMFoundHomePostListCellSize CGSizeMake(_width_, 75.0)

@class WMFoundHomePostListCell;

///发现首页列表代理
@protocol WMFoundHomePostListCellDelegate <NSObject>

///点赞
- (void)foundHomePostListCellDidPraise:(WMFoundHomePostListCell*) cell;

///评论
- (void)foundHomePostListCellDidComment:(WMFoundHomePostListCell*) cell;

@end

///发现首页贴列表
@interface WMFoundHomePostListCell : UICollectionViewCell

///图片
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

///栏目名称
@property (weak, nonatomic) IBOutlet UILabel *name_label;

///栏目名称宽度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *name_widthLayoutConstraint;

///标题内容
@property (weak, nonatomic) IBOutlet UILabel *title_label;

///点赞按钮
@property (weak, nonatomic) IBOutlet UIButton *praise_btn;

///评论按钮
@property (weak, nonatomic) IBOutlet UIButton *comment_btn;


///信息
@property (strong, nonatomic) WMFoundListInfo *info;

@property (weak, nonatomic) id<WMFoundHomePostListCellDelegate> delegate;

@end

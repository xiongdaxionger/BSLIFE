//
//  WMFoundCommentBottomView.h
//  WanShoes
//
//  Created by 罗海雄 on 16/3/23.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

//高度
#define WMFoundCommentBottomViewHeight 45.0

@class WMFoundCommentBottomView,WMFoundListInfo;

@protocol WMFoundCommentBottomViewDelegate <NSObject>

/**添加评论
 */
- (void)foundCommentBottomViewDidComment:(WMFoundCommentBottomView*) view;

/**点赞
 */
- (void)foundCommentBottomViewDidPraise:(WMFoundCommentBottomView*) view;

/**分享
 */
- (void)foundCommentBottomViewDidShare:(WMFoundCommentBottomView*) view;

@end

///发现评论视图
@interface WMFoundCommentBottomView : UIView

///分割线
@property (weak, nonatomic) IBOutlet UIView *line;

///点赞按钮
@property (weak, nonatomic) IBOutlet UIButton *praise_btn;

///评论按钮
@property (weak, nonatomic) IBOutlet UIButton *comment_btn;

///分享按钮
@property (weak, nonatomic) IBOutlet UIButton *share_btn;

///发现信息
@property (strong, nonatomic) WMFoundListInfo *info;

@property(nonatomic,weak) id<WMFoundCommentBottomViewDelegate> delegate;


@end

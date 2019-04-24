//
//  WMFoundFooterView.h
//  WanShoes
//
//  Created by 罗海雄 on 16/3/22.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "WMFoundBaseCell.h"

///高度
#define WMFoundFooterViewHeight 50 + WMFoundBaseCellMargin * 2.0

@class WMFoundListInfo, WMFoundFooterContentView;

@class WMFoundFooterView;

///发现底部视图代理
@protocol WMFoundFooterViewDelegate <NSObject>

///点赞
- (void)foundFooterViewDidPraise:(WMFoundFooterView*) view;

///评论
- (void)foundFooterViewDidComment:(WMFoundFooterView*)  view;

@end

///发现列表点赞，评论底部
@interface WMFoundFooterView : UITableViewHeaderFooterView

///内容
@property (readonly, nonatomic) WMFoundFooterContentView *footerContentView;

///发现列表信息
@property (strong, nonatomic) WMFoundListInfo *info;

///所属区域
@property (nonatomic,assign) NSInteger section;

@property (weak, nonatomic) id<WMFoundFooterViewDelegate> delegate;

@end

///发现列表底部内容
@interface WMFoundFooterContentView : UIView

///时间
@property (weak, nonatomic) IBOutlet UILabel *time_label;

///名称
@property (weak, nonatomic) IBOutlet UILabel *name_label;

///点赞按钮
@property (weak, nonatomic) IBOutlet UIButton *praise_btn;

///评论按钮
@property (weak, nonatomic) IBOutlet UIButton *comment_btn;

@end

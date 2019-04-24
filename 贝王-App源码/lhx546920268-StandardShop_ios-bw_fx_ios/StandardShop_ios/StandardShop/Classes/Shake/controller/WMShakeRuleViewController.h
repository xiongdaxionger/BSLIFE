//
//  WMShakeRuleViewController.h
//  WanShoes
//
//  Created by 罗海雄 on 16/3/17.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "SeaDialogViewController.h"

///摇一摇活动规则
@interface WMShakeRuleViewController : SeaDialogViewController<UIGestureRecognizerDelegate>

///白色背景
@property (weak, nonatomic) IBOutlet UIView *white_bg_view;

///标题
@property (weak, nonatomic) IBOutlet UILabel *title_label;

///关闭按钮
@property (weak, nonatomic) IBOutlet UIButton *close_btn;

///内容
@property (weak, nonatomic) IBOutlet UITextView *content_textView;

///加载指示器
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *act_view;

///重新加载按钮
@property (weak, nonatomic) IBOutlet UIButton *reload_btn;

///摇一摇规则
@property (copy, nonatomic) NSString *rule;

@end

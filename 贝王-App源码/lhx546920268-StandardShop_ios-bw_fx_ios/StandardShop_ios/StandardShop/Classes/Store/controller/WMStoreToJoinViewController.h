//
//  WMStoreToJoinViewController.h
//  SuYan
//
//  Created by 罗海雄 on 16/4/15.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "SeaScrollViewController.h"

///门店合作加盟
@interface WMStoreToJoinViewController : SeaScrollViewController

///背景滚动视图
@property (weak, nonatomic) IBOutlet UIScrollView *bg_scrollView;

///顶部图片
@property (weak, nonatomic) IBOutlet UIImageView *top_imageView;

///输入框白色背景
@property (weak, nonatomic) IBOutlet UIView *bg_view;

///名称
@property (weak, nonatomic) IBOutlet UITextField *name_textField;

///手机号
@property (weak, nonatomic) IBOutlet UITextField *phone_number_textField;

///城市
@property (weak, nonatomic) IBOutlet UITextField *city_textField;

///提交按钮
@property (weak, nonatomic) IBOutlet UIButton *submit_btn;

///提示信息
@property (weak, nonatomic) IBOutlet UILabel *msg_label;


@end

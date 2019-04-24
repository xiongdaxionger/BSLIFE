//
//  WMShakeResultCouponsDialog.h
//  WanShoes
//
//  Created by 罗海雄 on 16/3/16.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "WMShakeDialog.h"

///摇到优惠券弹窗
@interface WMShakeResultCouponsDialog : WMShakeDialog

///标题
@property (weak, nonatomic) IBOutlet UILabel *title_label;

///优惠券背景
@property (weak, nonatomic) IBOutlet UIImageView *coupons_bg_imageView;

///金额
@property (weak, nonatomic) IBOutlet UILabel *amount_label;

///券名称
@property (weak, nonatomic) IBOutlet UILabel *name_label;

///时间
@property (weak, nonatomic) IBOutlet UILabel *time_label;

///副标题
@property (weak, nonatomic) IBOutlet UILabel *subtitle_label;

///立即查看
@property (weak, nonatomic) IBOutlet UIButton *see_btn;

///关闭按钮
@property (weak, nonatomic) IBOutlet UIButton *close_btn;

///立即查看回调
@property (copy, nonatomic) void(^seeImmediatelyHandler)(void);

@end

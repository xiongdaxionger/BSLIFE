//
//  WMStoreDetailBottomView.h
//  StandardShop
//
//  Created by Hank on 2018/6/12.
//  Copyright © 2018年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

///门店详情底部视图
@interface WMStoreDetailBottomView : UIView

///门店logo
@property (weak, nonatomic) IBOutlet UIImageView *shopLogo;

///门店名称
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;

///营业时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

///联系电话
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;

///电话按钮
@property (weak, nonatomic) IBOutlet UIButton *mobileButton;

@end

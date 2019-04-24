//
//  WMMeBindPhoneCell.h
//  StandardShop
//
//  Created by 罗海雄 on 16/9/1.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

///大小
#define WMMeBindPhoneCellSize CGSizeMake(_width_, 45.0)

///绑定手机号
@interface WMMeBindPhoneCell : UICollectionViewCell

///标题
@property (readonly, nonatomic) UILabel *title_label;

///箭头
@property (readonly, nonatomic) UIImageView *arrow;

@end

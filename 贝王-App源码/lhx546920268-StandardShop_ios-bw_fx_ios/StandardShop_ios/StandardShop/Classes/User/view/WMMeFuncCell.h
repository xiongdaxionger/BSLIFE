//
//  WMMeFuncCell.h
//  StandardShop
//
//  Created by 罗海雄 on 16/8/31.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMMeListInfo;

///按钮位置
typedef NS_ENUM(NSInteger, WMMeFuncCellPosition)
{
    ///左边
    WMMeFuncCellPositionLeft,
    
    ///右边
    WMMeFuncCellPositionRight,
    
    ///中间
    WMMeFuncCellPositionMiddle,
    
    ///最底部 不显示分割线
    WMMeFuncCellPositionBottom,
};

///我，功能列表
@interface WMMeFuncCell : UICollectionViewCell

///分割线
@property (readonly, nonatomic) UIView *line;

///标题
@property (readonly, nonatomic) UILabel *title_label;

///信息
@property (strong, nonatomic) WMMeListInfo *info;

///按钮位置
@property (assign, nonatomic) WMMeFuncCellPosition position;

///通过位置获取position
+ (WMMeFuncCellPosition)positionFromIndex:(NSInteger) index itemCount:(NSInteger) itemCount;

///按钮大小
+ (CGSize)sizeForIndex:(NSInteger) index;

@end

///我，功能列表，有图标
@interface WMMeFuncIconCell : WMMeFuncCell

///图标
@property (readonly, nonatomic) UIImageView *imageView;

@end

///我功能列表，没图标
@interface WMMeFuncTextCell : WMMeFuncCell

///文本
@property (readonly, nonatomic) UILabel *textLabel;

@end

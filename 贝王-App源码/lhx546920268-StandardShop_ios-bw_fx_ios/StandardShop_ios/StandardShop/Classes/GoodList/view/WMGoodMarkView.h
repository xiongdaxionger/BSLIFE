//
//  WMGoodMarkView.h
//  StandardShop
//
//  Created by 罗海雄 on 16/6/3.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

///标记视图
@interface WMGoodMarkCell : UILabel


@end

///商品促销、限购等标识
@interface WMGoodMarkView : UIView

///可见的视图，数组元素是 WMGoodMarkCell，建议一个viewController 只有一个，用来复用的
@property(nonatomic,strong) NSMutableSet *visibleCells;

///留在复用的视图，数组元素是 WMGoodMarkCell，建议一个viewController 只有一个，用来复用的
@property(nonatomic,strong) NSMutableSet *reusedCells;

///要显示的图片，数组元素是标识内容 WMGoodMarkInfo，如果和以前的marks不一样，会调用reloadData
@property(nonatomic,strong) NSArray *marks;

///最大宽度 default is 'CGFloat_MAX'
@property(nonatomic,assign) CGFloat maxWidth;

///刷新数据
- (void)reloadData;


@end

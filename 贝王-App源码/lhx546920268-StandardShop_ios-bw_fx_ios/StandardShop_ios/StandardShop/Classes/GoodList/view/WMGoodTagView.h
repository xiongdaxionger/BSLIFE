//
//  WMGoodTagView.h
//  StandardShop
//
//  Created by 罗海雄 on 16/6/3.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMGoodTagInfo.h"

@interface WMGoodTagCell : UIView

///标签信息
@property(nonatomic,strong) WMGoodTagInfo *info;

///标签位置
@property(nonatomic,assign) WMGoodTagPosition position;

@end

///文本标签视图
@interface WMGoodTagTextCell : WMGoodTagCell

///标题
@property(nonatomic,readonly) UILabel *textLabel;

///填充颜色
@property(nonatomic,strong) UIColor *fillColor;

@end

///图片标签视图
@interface WMGoodTagImageCell : WMGoodTagCell

///图片
@property(nonatomic,readonly) UIImageView *imageView;

@end

///商品标签视图，放在商品图片上的
@interface WMGoodTagView : UIView

///可见的视图，数组元素是 WMGoodTagCell，建议一个viewController 只有一个，用来复用的
@property(nonatomic,strong) NSMutableDictionary *visibleCells;

///留在复用的视图，数组元素是 WMGoodTagCell，建议一个viewController 只有一个，用来复用的
@property(nonatomic,strong) NSMutableDictionary *reusedCells;

///要显示的图片，数组元素是标识内容 WMGoodTagInfo，如果和以前的tags不一样，会调用reloadData
@property(nonatomic,strong) NSArray *tags;

///刷新数据
- (void)reloadData;

@end

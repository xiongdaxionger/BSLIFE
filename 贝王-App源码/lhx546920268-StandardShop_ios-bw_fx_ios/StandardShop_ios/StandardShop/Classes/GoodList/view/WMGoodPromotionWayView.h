//
//  WMGoodPromotionWayView.h
//  StandardShop
//
//  Created by 罗海雄 on 16/6/3.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

///商品促销方式按钮
@interface WMGoodPromotionWayCell : UICollectionViewCell

///标题
@property(nonatomic,readonly) UIButton *title_btn;

///选中
@property(nonatomic,assign) BOOL sea_selected;

@end

///商品促销方式菜单
@interface WMGoodPromotionWayView : UIView

///选中某个回调
@property(nonatomic,copy) void(^selectHandler)(void);

/**构造方法
 *@param frame 位置大小
 *@param infos 数组元素是 WMGoodPromotionWayInfo
 *@return 一个实例
 */
- (instancetype)initWithFrame:(CGRect)frame infos:(NSArray*) infos;

@end

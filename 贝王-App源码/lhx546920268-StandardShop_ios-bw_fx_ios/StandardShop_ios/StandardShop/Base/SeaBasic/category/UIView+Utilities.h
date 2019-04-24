//
//  UIView+Utilities.h

//

#import <UIKit/UIKit.h>

@interface UIView (Utilities)

/** get and set frame.origin.y
*/
@property (nonatomic) CGFloat top;

/** get and set (frame.origin.y + frame.size.height)
 */
@property (nonatomic) CGFloat bottom;

/** get and set (frame.origin.x + frame.size.width)
 */
@property (nonatomic) CGFloat right;

/** get and set frame.origin.x
 */
@property (nonatomic) CGFloat left;

/** get and set frame.size.width
 */
@property (nonatomic) CGFloat width;

/** get and set frame.size.height
 */
@property (nonatomic) CGFloat height;

/** get and set center.x
 */
@property (nonatomic) CGFloat centerX;

/** get and set center.y
 */
@property (nonatomic) CGFloat centerY;

#pragma mark- 约束 constraint

/** 获取高度约束 返回当前优先级最高的
 */
@property (nonatomic,readonly) NSLayoutConstraint *sea_heightLayoutConstraint;

/** 获取宽度约束 返回当前优先级最高的
 */
@property (nonatomic,readonly) NSLayoutConstraint *sea_widthLayoutConstraint;

/** 获取左边距约束 返回当前优先级最高的
 */
@property (nonatomic,readonly) NSLayoutConstraint *sea_leftLayoutConstraint;

/** 获取右边距约束 返回当前优先级最高的
 */
@property (nonatomic,readonly) NSLayoutConstraint *sea_rightLayoutConstraint;

/** 获取顶部距约束 返回当前优先级最高的
 */
@property (nonatomic,readonly) NSLayoutConstraint *sea_topLayoutConstraint;

/** 获取底部距约束 返回当前优先级最高的
 */
@property (nonatomic,readonly) NSLayoutConstraint *sea_bottomLayoutConstraint;

/**通过约束类型获取对应的约束
 *@param attribute 约束类型
 *@return 如果存在，则返回优先级最高的约束，否则返回nil
 */
- (NSLayoutConstraint*)sea_layoutConstraintForAttribute:(NSLayoutAttribute) attribute;

#pragma mark- 虚线 dash

/** 虚线边框图层
 */
@property (nonatomic, strong) CAShapeLayer *dashBorderLayer;

/**设置边框颜色、圆角、边框粗细
 */
- (void)makeBorderWidth:(CGFloat)width Color:(UIColor *)color CornerRadius:(CGFloat)cornerRadius;

/*添加虚线边框 圆角会根据 视图的圆角来确定
 *@param width 线条宽度
 *@param lineColor 线条颜色
 *@param dashesLength 虚线间隔宽度
 *@param dashesInterval 虚线每段宽度
 */
- (void)addDashBorderWidth:(CGFloat) width lineColor:(UIColor*) lineColor dashesLength:(CGFloat) dashesLength dashesInterval:(CGFloat) dashesInterval;

@end

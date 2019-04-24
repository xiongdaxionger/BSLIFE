//
//  WMNavigationBarRedPointButton.h
//  StandardShop
//
//  Created by 罗海雄 on 16/6/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

///导航栏带红点的图标
@interface WMNavigationBarRedPointButton : UIButton

///红点
@property(nonatomic,readonly) UIView *redPoint;

/**构造方法
 *@param image 图标
 *@return 返回一个实例
 */
- (instancetype)initWithImage:(UIImage*) image;

@end

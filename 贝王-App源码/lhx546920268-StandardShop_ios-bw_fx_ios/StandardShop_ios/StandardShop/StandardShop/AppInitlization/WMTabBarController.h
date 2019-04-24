//
//  TabBarController.h
//  ydtctz
//
//  Created by 小宝 on 1/2/12.
//  Copyright (c) 2012 Bosermobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMTabBarController : UITabBarController<UITabBarControllerDelegate>

///初始化
+ (void)initialization;

///停止所有计时器任务
- (void)stopAllTimer;


/**打开秒杀
 */
- (void)openSecondKill;

/**
 *  打开某个商品详情
 * @param Id 商品id
 */
- (void)openGoodDetailWithId:(NSString *)Id title:(NSString *)title;

/**打开某个分类
 */
- (void)openCategoryWithID:(NSString *)Id title:(NSString *)title;

/**打开某个品牌
 */
- (void)openBrandWithId:(NSString *)Id title:(NSString *)title;

/**
 *  打开某篇学院文章
 * @param Id 文章id
 */
- (void)openCollegeWithId:(NSString*)Id title:(NSString *)title;

/**打开领券中心
 */
- (void)openActivityCoupon;

/**打开自定义链接
 */
- (void)openCustomLink:(NSString *)link title:(NSString *)title;





@end

//
//  WMGoodDetailSettingInfo.h
//  StandardShop
//
//  Created by mac on 16/6/6.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

//加入购物车按钮跳转类型
typedef NS_ENUM(NSInteger, BuyTargetType){
    
    //加入成功后跳转购物车
    BuyTargetTypePushShopCar = 1,
    
    //不跳转不提示
    BuyTargetTypeDoNothing = 2,
    
    //不跳转只提示
    BuyTargetTypeShowTip = 3,
};

/**商品详情的设置信息
 */
@interface WMGoodDetailSettingInfo : NSObject
/**商品是否开启评论显示
 */
@property (assign,nonatomic) BOOL goodDetailShowComment;
/**商品是否开启咨询显示
 */
@property (assign,nonatomic) BOOL goodDetailShowAdvice;
/**商品是否开启评论评分显示
 */
@property (assign,nonatomic) BOOL goodDetailShowCommentPoint;
/**加入购物车按钮的跳转方式
 */
@property (assign,nonatomic) BuyTargetType type;
/**是否显示消费记录
 */
@property (assign,nonatomic) BOOL goodDetailShowConsume;
/**初始化
 */
+ (instancetype)returnGoodDetailSettingInfoWithDict:(NSDictionary *)dict;











@end

//
//  WMHomeAdInfo.h
//  WuMei
//
//  Created by 罗海雄 on 15/7/18.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import <Foundation/Foundation.h>

///广告类型
typedef NS_ENUM(NSInteger, WMHomeAdType)
{
    ///未知
    WMHomeAdTypeNotknow,
    
    ///商品
    WMHomeAdTypeGood = 1,
    
    ///文章
    WMHomeAdTypeArticle,
    
    ///商品分类商品列表
    WMHomeAdTypeCategoryGoodList,
    
    ///商品虚拟分类商品列表
    WMHomeAdTypeVirtualCategoryGoodList,
    
    ///分类列表
    WMHomeAdTypeCategoryList,
    
    ///品牌
    WMHomeAdTypeBrand,
    
    ///摇一摇
    WMHomeAdTypeShake,
    
    ///秒杀专区
    WMHomeAdTypeSecondKill,
    
    ///签到
    WMHomeAdTypeSignin,
    
    ///自定义链接
    WMHomeAdTypeCustom,
    
    ///充值界面
    WMHomeAdTypeTopup,
    
    ///预售商品列表
    WMHomeAdTypePresellGoodList,
    
    ///领券中心
    WMHomeAdTypeDrawCoupons,
};

/**首页广告信息
 */
@interface WMHomeAdInfo : NSObject

/**广告图片
 */
@property(nonatomic,copy) NSString *imageURL;

/**对应的id
 */
@property(nonatomic,copy) NSString *Id;

/**文字
 */
@property(nonatomic,copy) NSString *text;

/**内容
 */
@property(nonatomic,copy) NSString *content;

/**广告大小
 */
@property(nonatomic,assign) CGSize itemSize;

/**广告类型 0 商品，1 文章，2商品分类，3商品虚拟分类
 */
@property(nonatomic,assign) WMHomeAdType adType;

/**获取对应的品牌controller
 *@return 如果是可识别的广告，则返回对应的viewController ,否则返回nil
 */
- (UIViewController*)viewController;

/**通过字典创建
 */
+ (instancetype)infoFromDictionary:(NSDictionary*) dic;

@end

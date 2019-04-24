//
//  WMHomeInfo.h
//  MoblieFX
//
//  Created by 罗海雄 on 15/11/16.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import "WMCategoryInfo.h"
#import "WMHomeAdInfo.h"
#import "WMSecondKillInfo.h"

///首页信息类型
typedef NS_ENUM(NSInteger, WMHomeInfoType)
{
    ///不能识别的首页数据
    WMHomeInfoTypeNotknow = -1,
    
    ///轮播广告 数组元素是 WMHomeAdInfo
    WMHomeInfoTypeFlashAd = 0,
    
    ///首页专辑分类 数组元素是 WMHomeAdInfo
    WMHomeInfoTypeHomeCatgory,
    
    ///快报 数组元素是 WMHomeAdInfo
    WMHomeInfoTypeLetters,
    
    ///商品秒杀 数组元素是 WMHomeSecondKillInfo
    WMHomeInfoTypeGoodSecondKill,
    
    ///图片广告 数组元素是 WMHomeAdInfo
    WMHomeInfoTypeImageAd,

    ///商品列表 数组元素是 WMGoodInfo
    WMHomeInfoTypeGoodList,
};


/**首页信息，对应首页的每个section
 */
@interface WMHomeInfo : NSObject

///首页信息类型，不同的类型 header 和 infos里面的数组元素 也不同
@property(nonatomic,assign) WMHomeInfoType type;

///cell信息，数组元素为 WMGoodInfo，WMHomeAdInfo，WMHomeSecondKillInfo
@property(nonatomic,strong) NSMutableArray *infos;

///对应section中cell的数量
@property(nonatomic,readonly) NSInteger numberOfCells;

///section标题
@property(nonatomic,copy) NSString *title;

///是否显示标题
@property(nonatomic,assign) BOOL shouldDisplayTitle;

///标题对齐方式
@property(nonatomic,assign) NSTextAlignment titleAlignment;

///section标题颜色
@property(nonatomic,strong) UIColor *titleColor;

///secton背景颜色
@property(nonatomic,strong) UIColor *backgroundColor;

///是否显示section分割线
@property(nonatomic,assign) BOOL shouldDisplaySeparator;

///是否显示section底部
@property(nonatomic,assign) BOOL shouldDisplayFooter;

///是否显示线条
@property(nonatomic,assign) BOOL showLine;

///大小
@property(nonatomic,assign) CGSize size;

///item上下间距
@property (nonatomic,assign) CGFloat minimumLineSpacing;

///item左右间距
@property (nonatomic,assign) CGFloat minimumInteritemSpacing;

///通过字典创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic;

@end

/**首页秒杀信息
 */
@interface WMHomeSecondKillInfo : NSObject

/**场次id
 */
@property(nonatomic,copy) NSString *Id;

/**秒杀图标
 */
@property(nonatomic,copy) NSString *imageURL;

///副标题颜色
@property(nonatomic,strong) UIColor *subTitleColor;

///副标题
@property(nonatomic,copy) NSString *subtitle;

/**开始时间
 */
@property(nonatomic,assign) NSTimeInterval beginTime;

/**结束时间
 */
@property(nonatomic,assign) NSTimeInterval endTime;

/**秒杀是否已经开始
 */
@property(nonatomic,readonly) BOOL isSecondKillBegan;

/**秒杀是否已结束
 */
@property(nonatomic,readonly) BOOL isSecondKillEnded;

///秒杀商品信息 数组元素是 WMGoodInfo
@property(nonatomic,strong) NSMutableArray *infos;

@end



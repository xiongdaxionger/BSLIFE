//
//  WMMeInfo.h
//  StandardShop
//
//  Created by 罗海雄 on 16/8/31.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

///个人中心信息类型
typedef NS_ENUM(NSInteger,WMMeInfoType)
{
    ///登录头部
    WMMeInfoTypeLogin = 0,
    
    ///绑定手机号
    WMMeInfoTypeBindPhone,
    
    ///订单
    WMMeInfoTypeOrder,
    
    ///资产
    WMMeInfoTypeAssets,
    
    ///功能
    WMMeInfoTypeFunc,
    
    ///商品
    WMMeInfoTypeGoodList,
};

///个人中心信息
@interface WMMeInfo : NSObject

///类型
@property(nonatomic,assign) WMMeInfoType type;

///是否需要底部分割线
@property(nonatomic,assign) BOOL bottomLine;

///底部分割线高度
@property(nonatomic,assign) CGFloat bottomLineHeight;

///是否需要顶部分割线
@property(nonatomic,assign) BOOL topLine;

///顶部分割线高度
@property(nonatomic,assign) BOOL topLineHeight;

///数据信息
@property(nonatomic,strong) NSMutableArray *infos;

///item数量
@property(nonatomic,readonly) NSInteger items;

///标题
@property(nonatomic,copy) NSString *title;

///获取个人中数据 数组元素是 WMMeInfo
+ (NSMutableArray*)meInfos;

///通过类型初始化
+ (instancetype)infoWithType:(WMMeInfoType) type;

@end

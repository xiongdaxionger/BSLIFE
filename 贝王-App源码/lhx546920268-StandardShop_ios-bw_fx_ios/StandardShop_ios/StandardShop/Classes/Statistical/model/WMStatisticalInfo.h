//
//  WMStatisticalInfo.h
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/3.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

///红蓝绿
#define WMStatisticalRed [UIColor colorFromHexadecimal:@"F343558"]
#define WMStatisticalBlue [UIColor colorFromHexadecimal:@"0F92ED"]
#define WMStatisticalGreen [UIColor colorFromHexadecimal:@"17B308"]

///统计类型
typedef NS_ENUM(NSInteger, WMStatisticalType)
{
    ///订单
    WMStatisticalTypeOrder = 0,
    
    ///收入
    WMStatisticalTypeEarn,
};

@class WMStatisticalDataInfo;

/**统计节点信息
 */
@interface WMStatisticalNodeInfo : NSObject

///x 轴标题
@property(nonatomic,copy) NSString *xTitle;

///y 轴数据
@property(nonatomic,copy) NSString *yValue;

///时间
@property(nonatomic,copy) NSString *time;

///统计数据信息
@property(nonatomic,weak) WMStatisticalDataInfo *dataInfo;

///从字典中创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic;

@end

/**统计数据信息
 */
@interface WMStatisticalDataInfo : NSObject

///统计总数标题
@property(nonatomic,copy) NSString *sumTitle;

///统计总数
@property(nonatomic,copy) NSString *sum;

///统计节点信息数组元素是 WMStatisticalNodeInfo
@property(nonatomic,strong) NSArray *infos;

///从字典中创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic;

@end

/**统计信息
 */
@interface WMStatisticalInfo : NSObject

///统计类型
@property(nonatomic,assign) WMStatisticalType type;

///菜单标题
@property(nonatomic,copy) NSString *menuTitle;

///统计数据信息 数组元素是 WMStatisticalDataInfo
@property(nonatomic,strong) NSArray *infos;

///从字典中创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic;

@end



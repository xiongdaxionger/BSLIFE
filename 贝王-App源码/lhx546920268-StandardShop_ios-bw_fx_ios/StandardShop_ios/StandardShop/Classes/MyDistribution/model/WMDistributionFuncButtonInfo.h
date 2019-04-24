//
//  WMDistributionFuncButtonInfo.h
//  WestMailDutyFee
//
//  Created by 罗海雄 on 15/8/26.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>


/**分销首页功能按钮类型
 */
typedef NS_ENUM(NSInteger, WMDistributionFuncButtonType)
{
    ///充值
    WMDistributionFuncButtonTypeTopup = 0,

    ///提现
    WMDistributionFuncButtonTypeWithdraw,

    ///推广
    WMDistributionFuncButtonTypePromote,

    ///团队
    WMDistributionFuncButtonTypeTeam,

    ///统计
    WMDistributionFuncButtonTypeStatistical,

    ///学院
    WMDistributionFuncButtonTypeCollege,
};

/**分销首页功能按钮信息
 */
@interface WMDistributionFuncButtonInfo : NSObject

/**按钮类型
 */
@property(nonatomic,assign) WMDistributionFuncButtonType type;

/**按钮标题
 */
@property(nonatomic,copy) NSString *title;

/**按钮图标
 */
@property(nonatomic,strong) UIImage *icon;

/**通过按钮类型初始化
 */
+ (id)infoFromType:(WMDistributionFuncButtonType) type;

/**获取需要显示的按钮
 *@return 数组元素是 WMDistributionFuncButtonInfo
 */
+ (NSArray*)funcButtonInfos;

@end

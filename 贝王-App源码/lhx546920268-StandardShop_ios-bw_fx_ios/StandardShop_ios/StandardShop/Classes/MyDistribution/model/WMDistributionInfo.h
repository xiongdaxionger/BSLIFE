//
//  WMDistributionInfo.h
//  StandardShop
//
//  Created by 罗海雄 on 16/7/19.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

///分销信息
@interface WMDistributionInfo : NSObject

///当前收益
@property(nonatomic,copy) NSString *cur_earnings;

///冻结收益
@property(nonatomic,copy) NSString *freeze_earnings;

///今日收益
@property(nonatomic,copy) NSString *today_earnings;

///累计收益
@property(nonatomic,copy) NSString *cumulative_earnings;

///分享链接
@property(nonatomic,copy) NSString *shareURL;

/**获取分销首页信息
 *@return 数组元素是 WMDistributionEarningsInfo
 */
- (NSArray*)distributionEarningsInfos;

@end

///分销收益信息
@interface WMDistributionEarningsInfo : NSObject

///标题
@property(nonatomic,copy) NSString *title;

///内容
@property(nonatomic,copy) NSString *content;

///遍历构造方法
+ (instancetype)infoWithTitle:(NSString*) title content:(NSString*) content;

@end

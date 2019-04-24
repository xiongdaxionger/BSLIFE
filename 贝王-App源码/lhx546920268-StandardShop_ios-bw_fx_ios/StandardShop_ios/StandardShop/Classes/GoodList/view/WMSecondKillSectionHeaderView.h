//
//  WMSecondKillSectionHeaderView.h
//  SuYan
//
//  Created by 罗海雄 on 16/4/14.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

///高度
#define WMSecondKillSectionHeaderViewHeight (90.0 + _separatorLineWidth_)

@class WMSecondKillSectionHeaderView, WMSecondKillInfo;

///秒杀专区时区代理
@protocol WMSecondKillSectionHeaderViewDelegate<NSObject>

///选择某个时区
- (void)secondKillSectionHeaderView:(WMSecondKillSectionHeaderView*) view didSelectInfo:(WMSecondKillInfo*) info;

///倒计时结束
- (void)secondKillSectionHeaderViewCountDownDidEnd:(WMSecondKillSectionHeaderView *)view;

@end

///秒杀专区 时区
@interface WMSecondKillSectionHeaderView : UIView

///选中的秒杀
@property(nonatomic,assign) NSInteger selectedIndex;

@property(nonatomic, weak) id<WMSecondKillSectionHeaderViewDelegate> delegate;

///秒杀信息
@property(nonatomic,strong) WMSecondKillInfo *info;

/**构造方法
 *@param infos 秒杀时区信息 数组元素是 WMSecondKillInfo
 */
- (instancetype)initWithInfos:(NSArray*) infos;


@end

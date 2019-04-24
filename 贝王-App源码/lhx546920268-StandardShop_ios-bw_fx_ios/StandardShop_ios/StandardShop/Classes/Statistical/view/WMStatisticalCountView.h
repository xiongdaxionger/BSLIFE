//
//  WMStatisticalCountView.h
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/3.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMStatisticalInfo;

/**统计数量视图 cell
 */
@interface WMStatisticalCountViewCell : UIView

///数量
@property(nonatomic,readonly) UILabel *countLabel;

///标题
@property(nonatomic,readonly) UILabel *titleLabel;

///点
@property(nonatomic,readonly) UIView *point;

@end

///统计视图高度
#define WMStatisticalCountViewHeight 65.0

/**统计数量视图
 */
@interface WMStatisticalCountView : UIView

/**统计信息
 */
@property(nonatomic,strong) WMStatisticalInfo *info;

@end

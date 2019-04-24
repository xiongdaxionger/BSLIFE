//
//  WMStatisticalBubbleView.h
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/4.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMStatisticalInfo;

/**统计 点击出现的气泡
 */
@interface WMStatisticalBubbleView : UIView

/**设置统计信息
 *@param WMStatisticalInfo 
 *@param index 点下标
 *@param point 尖角位置
 */
- (void)setStatisticalInfo:(WMStatisticalInfo*) info forIndex:(NSInteger) index inPoint:(CGPoint) point;

@end

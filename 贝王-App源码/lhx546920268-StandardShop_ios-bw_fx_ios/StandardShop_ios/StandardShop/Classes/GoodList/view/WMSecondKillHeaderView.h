//
//  WMSecondKillHeaderView.h
//  SuYan
//
//  Created by 罗海雄 on 16/4/14.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMHomeFlashAdCell,WMHomeAdInfo;

///大小
#define WMSecondKillHeaderViewHeight (_width_ * 600.0 / 1242.0)

///秒杀专区表头
@interface WMSecondKillHeaderView : UIView

/**滚动广告数据 数字元素是 WMHomeAdInfo
 */
@property(nonatomic,strong) NSArray *rollInfos;

///跳转导航
@property(nonatomic,weak) UINavigationController *navigationController;


/**重新加载数据
 */
- (void)reloadData;

@end
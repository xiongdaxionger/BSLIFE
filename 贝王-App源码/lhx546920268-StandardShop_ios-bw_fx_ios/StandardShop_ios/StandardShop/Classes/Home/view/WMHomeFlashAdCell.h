//
//  WMHomeFlashAdCell.h
//  WuMei
//
//  Created by 罗海雄 on 15/7/18.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import <UIKit/UIKit.h>

///大小
#define WMHomeFlashAdCellSize CGSizeMake(_width_, _width_ * 500.0 / 1242.0)

/**首页轮播广告
 */
@interface WMHomeFlashAdCell : UICollectionViewCell

/**滚动广告
 */
@property(nonatomic,strong) SeaAutoScrollView *adScrollView;

/**滚动广告数据 数字元素是 WMHomeAdInfo
 */
@property(nonatomic,strong) NSArray *rollInfos;

/**跳转导航
 */
@property(nonatomic,weak) UINavigationController *navigationController;

/**重新加载数据
 */
- (void)reloadData;

@end

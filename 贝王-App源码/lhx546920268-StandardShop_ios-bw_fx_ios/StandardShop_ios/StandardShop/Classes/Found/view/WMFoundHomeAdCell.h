//
//  WMFoundHomeAdCell.h
//  SuYan
//
//  Created by 罗海雄 on 16/4/29.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

///大小
#define WMFoundHomeAdCellSize CGSizeMake(_width_, _width_ * 500.0 / 1242.0)

///发现首页轮播广告
@interface WMFoundHomeAdCell : UICollectionViewCell

/**滚动广告
 */
@property(nonatomic,strong) SeaAutoScrollView *adScrollView;

/**滚动广告数据 数字元素是 WMHomeAdInfo
 */
@property(nonatomic,strong) NSArray *rollInfos;

///跳转导航
@property(nonatomic,weak) UINavigationController *navigationController;

/**重新加载数据
 */
- (void)reloadData;

@end

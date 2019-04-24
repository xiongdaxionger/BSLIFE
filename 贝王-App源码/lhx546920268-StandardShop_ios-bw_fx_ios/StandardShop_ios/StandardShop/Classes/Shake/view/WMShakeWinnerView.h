//
//  WMShakeWinnerView.h
//  StandardShop
//
//  Created by 罗海雄 on 16/8/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

///摇一摇获奖名单
@interface WMShakeWinnerView : UIView<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

/**获奖列表
 */
@property(nonatomic,readonly) UICollectionView *collectionView;

/**正在加载
 */
@property(nonatomic,assign) BOOL loading;

///摇一摇获奖名单 数组元素是 WMShakeWinnerInfo
@property(nonatomic,strong) NSMutableArray *winners;

///将要加载下一页获奖名单回调
@property(nonatomic,copy) void(^willLoadNextWinnersHandler)(void);

///停止倒计时
- (void)stopTimer;

@end

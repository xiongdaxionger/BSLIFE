//
//  WMHomeGoodSecondKillView.h
//  MoblieFX
//
//  Created by 罗海雄 on 15/11/16.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

///边距
#define WMHomeGoodSecondKillViewMargin 8.0

///秒杀商品cell的大小
#define WMHomeGoodSecondKillCellSize CGSizeMake((_width_ - WMHomeGoodSecondKillViewMargin * 4) / 3.5,(_width_ - WMHomeGoodSecondKillViewMargin * 4) / 3.5 + 5.0  + 20.0 + 5.0)

///秒杀视图大小
#define WMHomeGoodSecondKillViewSize CGSizeMake(_width_, WMHomeGoodSecondKillCellSize.height + 40.0 + WMHomeGoodSecondKillViewMargin)

@class WMHomeSecondKillInfo,WMHomeGoodSecondKillView,WMCountDownView;

///首页秒杀代理
@protocol WMHomeGoodSecondKillViewDelegate <NSObject>

///首页秒杀结束
- (void)homeGoodSecondKillViewDidEnd:(WMHomeGoodSecondKillView*) view;

@end

/**首页显示秒杀，放在首页
 */
@interface WMHomeGoodSecondKillView : UICollectionViewCell<UICollectionViewDataSource,UICollectionViewDelegate>

/**商品列表
 */
@property(nonatomic,readonly) UICollectionView *collectionView;

/**首页秒杀信息
 */
@property(nonatomic,strong) WMHomeSecondKillInfo *info;

/**图标
 */
@property(nonatomic,readonly) UIImageView *imageView;

/**副标题
 */
@property(nonatomic,readonly) UILabel *subtitleLabel;

/**秒杀倒计时
 */
@property(nonatomic,readonly) WMCountDownView *countDownView;

@property(nonatomic,weak) id<WMHomeGoodSecondKillViewDelegate> delegate;

///跳转导航
@property(nonatomic,weak) UINavigationController *navigationController;

@end

//
//  WMHomeLettersView.h
//  WanShoes
//
//  Created by 罗海雄 on 16/3/14.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WMHomeLettersViewSize CGSizeMake(_width_, 40.0)

@class WMHomeInfo,WMHomeAdInfo,WMHomeLettersView;

///首页快报
@interface WMHomeLettersView : UICollectionViewCell<UICollectionViewDataSource,UICollectionViewDelegate>

/**商品列表
 */
@property(nonatomic,readonly) UICollectionView *collectionView;

/**首页快报信息
 */
@property(nonatomic,strong) WMHomeInfo *info;

/**logo
 */
@property(nonatomic,readonly) UIImageView *logoImageView;

/**跳转导航
 */
@property(nonatomic,weak) UINavigationController *navigationController;

@end

//
//  WMCollectionFilterTypeReusableView.h
//  StandardFenXiao
//
//  Created by mac on 16/1/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>
#define WMCollectionFilterTypeReusableViewHeight 50
#define WMCollectionFilterTypeReusableViewIden @"WMCollectionFilterTypeReusableViewIden"

@class WMCollectionFilterTypeReusableView;
@class WMGoodFilterModel;

@protocol WMCollectionFilterTypeReusableViewDelegate <NSObject>

//点击下拉或者上拉按钮
- (void)collectionFilterTypeReusableViewButtonClick:(WMCollectionFilterTypeReusableView *)view;

@end

@interface WMCollectionFilterTypeReusableView : UICollectionReusableView
/**筛选类型文本
 */
@property (weak, nonatomic) IBOutlet UILabel *filterTypeLabel;
/**下拉或上拉按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *filterButton;
/**代理
 */
@property (weak,nonatomic) id<WMCollectionFilterTypeReusableViewDelegate>delegate;
/**所在的组
 */
@property (assign,nonatomic) NSInteger section;
/**配置模型
 */
@property (assign,nonatomic) WMGoodFilterModel *model;
/**配置类型
 */
- (void)configureFilterType:(WMGoodFilterModel *)model;
@end

//
//  GoodValuesImageViewCell.h
//  WuMei
//
//  Created by qsit on 15/7/21.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMGoodDetailSpecInfo;

@protocol GoodValuesImageViewCellDelegate <NSObject>

/**选中某个规格值后回调代理
 */
- (void)imageSpecValueSelectWithProductID:(NSString *)productID;

@end

#define GoodValuesImageViewCellIden @"GoodValuesImageViewCellIden"
#define GoodValuesImageViewCellHeight 125

/**图片规格选择
 */
@interface GoodValuesImageViewCell : UITableViewCell
/**属性名称
 */
@property (weak, nonatomic) IBOutlet UILabel *valuesNameLabel;
/**数据
 */
@property (strong,nonatomic) WMGoodDetailSpecInfo *specInfo;
/**属性图片展示集合视图
 */
@property (weak, nonatomic) IBOutlet UICollectionView *imageCollectionView;
/**代理
 */
@property (weak,nonatomic) id<GoodValuesImageViewCellDelegate>delegate;
/**配置数据
 */
- (void)configureCellWithModel:(WMGoodDetailSpecInfo *)model;
@end

//
//  WMGoodCategoryCell.h
//  WuMei
//
//  Created by 罗海雄 on 15/7/18.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMCategoryInfo;

///高度
#define WMGoodCategoryFirstCellHeight 57.0

///宽度
#define WMGoodCategoryFirstCellWidth 90.0

/**商品一级类目
 */
@interface WMGoodCategoryFirstCell : UITableViewCell

/**图标
 */
@property(nonatomic,readonly) UIImageView *iconImageView;

/**名称
 */
@property(nonatomic,readonly) UILabel *nameLabel;

/**选中背景
 */
@property(nonatomic,readonly) UIView *selectedBgView;

/**分割线
 */
@property(nonatomic,readonly) UIView *line;

/**分类信息
 */
@property(nonatomic,strong) WMCategoryInfo *info;

/**选中
 */
@property(nonatomic,assign) BOOL sea_selected;

/**创建给定宽度的cell
 */
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier width:(CGFloat) width;

@end

///间隔
#define WMGoodSecondaryCategoryCellInterval 0

///边距
#define WMGoodSecondaryCategoryCellMargin 10.0

/**商品二级类目图标加文字
 */
@interface WMGoodSecondaryCategoryCell : UICollectionViewCell

/**图标
*/
@property(nonatomic,readonly) UIImageView *iconImageView;

/**名称
 */
@property(nonatomic,readonly) UILabel *nameLabel;

/**分割线
 */
@property(nonatomic,readonly) UIView *line;

/**分割线位置 0 左边，1右边
 */
@property(nonatomic,assign) int position;

/**分类信息
 */
@property(nonatomic,strong) WMCategoryInfo *info;


/**item大小
 */
+ (CGSize)sea_itemSize;

@end

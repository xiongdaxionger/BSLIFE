//
//  WMHomeCategoryCell.h
//  MoblieFX
//
//  Created by 罗海雄 on 15/11/13.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMHomeAdInfo;

///大小
#define WMHomeCategoryCellSize CGSizeMake(_width_ / 4.0, _width_ / 4.0)

/**主页 分类
 */
@interface WMHomeCategoryCell : UICollectionViewCell

///图标
@property (weak, nonatomic) IBOutlet UIImageView *icon_imageView;

///标题
@property (weak, nonatomic) IBOutlet UILabel *title_label;

///分类信息
@property (strong, nonatomic) WMHomeAdInfo *info;


@end

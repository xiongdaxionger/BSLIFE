//
//  WMBrandSquareCell.h
//  WanShoes
//
//  Created by 罗海雄 on 16/3/31.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

///边距
#define WMBrandSquareCellMargin 8.0

///大小
#define WMBrandSquareCellSize CGSizeMake((_width_ - WMBrandSquareCellMargin * 4) / 3.0, (_width_ - WMBrandSquareCellMargin * 4) / 3.0)

///品牌方块cell
@interface WMBrandSquareCell : UICollectionViewCell

///图片
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

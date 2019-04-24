//
//  WMFoundHeaderCollectionViewCell.h
//  WanShoes
//
//  Created by 罗海雄 on 16/3/22.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

///表头按钮cell
@interface WMFoundHeaderCollectionViewCell : UICollectionViewCell

///图标
@property (weak, nonatomic) IBOutlet UIImageView *icon_imageView;

///名称
@property (weak, nonatomic) IBOutlet UILabel *name_label;

///是否选中
@property (assign, nonatomic) BOOL sea_selected;

@end

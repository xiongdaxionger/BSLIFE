//
//  WMHomeImageAdCell.h
//  WanShoes
//
//  Created by 罗海雄 on 16/3/30.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMHomeAdInfo;

///首页图片广告cell
@interface WMHomeImageAdCell : UICollectionViewCell

///图片
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

///广告信息
@property (strong, nonatomic) WMHomeAdInfo *info;

@end

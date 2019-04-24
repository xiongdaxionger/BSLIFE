//
//  WMFoundHomePlateListCell.h
//  SuYan
//
//  Created by 罗海雄 on 16/4/29.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMFoundCategoryInfo;

///大小
#define WMFoundHomePlateListCellSize CGSizeMake(_width_, 65.0)

///发现首页社区板块列表
@interface WMFoundHomePlateListCell : UICollectionViewCell

///图片
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

///标题
@property (weak, nonatomic) IBOutlet UILabel *title_label;

///副标题
@property (weak, nonatomic) IBOutlet UILabel *subtitle_label;\

///发现栏目
@property (strong, nonatomic) WMFoundCategoryInfo *info;

@end

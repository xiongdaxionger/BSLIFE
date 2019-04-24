//
//  WMFilterCollectionNameViewCell.h
//  StandardFenXiao
//
//  Created by mac on 16/1/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WMFilterCollectionNameViewCellIden @"WMFilterCollectionNameViewCellIden"
#define WMFilterCollectionNameViewCellHeight 33

///字体
#define WMFilterCollectionNameViewCellFont [UIFont fontWithName:MainFontName size:12.0]

@interface WMFilterCollectionNameViewCell : UICollectionViewCell
/**筛选的名称
 */
@property (weak, nonatomic) IBOutlet UILabel *filterNameLabel;
/**选中状态
 */
@property (assign,nonatomic) BOOL selectStatus;
/**配置筛选类型名称
 */
- (void)configureWithFilterName:(NSString *)name;
@end

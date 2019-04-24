//
//  ImageSelectCollectionViewCell.h
//  WuMei
//
//  Created by qsit on 15/7/21.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kImageSelectCollectionViewCellIden @"ImageSelectCollectionViewCellIden"
/**图片规格单元格
 */
@interface ImageSelectCollectionViewCell : UICollectionViewCell
/**图片背景视图
 */
@property (weak, nonatomic) IBOutlet UIView *imageBackImage;
/**属性图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *valuesImage;
/**属性名称
 */
@property (weak, nonatomic) IBOutlet UILabel *valuesNameLabel;


- (void)configureWithModel:(id)model;
@end

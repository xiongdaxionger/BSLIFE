//
//  WMFilterCollectionImageViewCell.h
//  StandardFenXiao
//
//  Created by mac on 16/1/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WMFilterCollectionImageViewCellIden @"WMFilterCollectionImageViewCellIden"
#define WMFilterCollectionImageViewCellHeight 50
@interface WMFilterCollectionImageViewCell : UICollectionViewCell
/**品牌图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *brandImage;
/**选中状态
 */
@property (assign,nonatomic) BOOL selectStatus;
/**配置图片
 */
- (void)configureWithImageURL:(NSString *)url;
@end

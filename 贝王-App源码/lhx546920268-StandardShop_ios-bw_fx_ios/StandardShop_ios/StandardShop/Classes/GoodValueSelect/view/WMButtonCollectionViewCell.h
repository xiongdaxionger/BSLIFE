//
//  WMButtonCollectionViewCell.h
//  StandardShop
//
//  Created by mac on 16/6/16.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WMButtonCollectionViewCellIden @"WMButtonCollectionViewCell"
/**规格选择的底部视图按钮单元格
 */
@interface WMButtonCollectionViewCell : UICollectionViewCell
/**按钮信息文本
 */
@property (weak, nonatomic) IBOutlet UILabel *buttonLabel;

/**配置数据
 */
- (void)configureWithDict:(NSDictionary *)dict;
@end

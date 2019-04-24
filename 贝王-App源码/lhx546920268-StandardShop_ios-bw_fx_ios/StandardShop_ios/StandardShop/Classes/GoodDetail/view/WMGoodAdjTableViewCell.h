//
//  WMGoodAdjTableViewCell.h
//  StandardShop
//
//  Created by mac on 16/6/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XTableCellConfigExDelegate.h"

@class JCTagListView;
#define WMGoodAdjTableViewCellIden @"WMGoodAdjTableViewCellIden"
#define WMGoodAdjTableViewCellHeight 200.0
//额外内容高度
#define WMGoodAdjExtraHeight 16.0
/**商品配件视图
 */
@interface WMGoodAdjTableViewCell : UITableViewCell<XTableCellConfigExDelegate>
/**配件商品集合视图
 */
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
/**集合视图布局
 */
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayOut;
/**集合视图高度约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
/**标签视图
 */
@property (weak, nonatomic) IBOutlet JCTagListView *tagListView;
/**配置数据
 */
- (void)configureCellWithModel:(id)model;
@end

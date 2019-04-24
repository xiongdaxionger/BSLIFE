//
//  WMGoodLinkTableViewCell.h
//  StandardShop
//
//  Created by mac on 16/6/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XTableCellConfigExDelegate.h"

#define WMGoodLinkTableViewCellIden @"WMGoodLinkTableViewCellIden"
#define WMGoodLinkTableViewCellHeight 170.0
//额外内容高度
#define WMGoodLinkExtraHeight 50.0
/**猜你喜欢
 */
@interface WMGoodLinkTableViewCell : UITableViewCell<XTableCellConfigExDelegate>
/**猜你喜欢商品视图
 */
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
/**集合视图布局
 */
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayOut;
/**底部距离
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewBottom;
/**分页控价
 */
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
/**回调跳转
 */
@property (copy,nonatomic) void(^selectCallBack)(NSString *productID);
/**配置数据
 */
- (void)configureCellWithModel:(id)model;
@end

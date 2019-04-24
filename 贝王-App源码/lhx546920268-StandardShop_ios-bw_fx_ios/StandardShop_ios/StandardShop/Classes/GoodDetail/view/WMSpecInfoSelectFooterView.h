//
//  WMSpecInfoSelectFooterView.h
//  StandardShop
//
//  Created by mac on 16/6/13.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WMSpecInfoSelectFooterViewHeight 50
/**属性选择的按钮视图
 */
@interface WMSpecInfoSelectFooterView : UIView
/**点击按钮的回调
 */
@property (copy,nonatomic) void(^buttonAction)(BOOL isFastBuy,BOOL notify,BOOL canBuy,NSString *value);
/**商品的按钮数组--元素是NSDictionary,key为name对应按钮名称,key为value对应按钮类型
 *类型fastbuy--立即购买，buy--加入购物车
 */
@property (strong,nonatomic) NSArray *buttonListArr;
/**按钮集合视图
 */
@property (strong,nonatomic) UICollectionView *collectionView;
/**配置界面
 */
- (void)configureUI;
/**更新UI
 */
- (void)updateUI;
@end

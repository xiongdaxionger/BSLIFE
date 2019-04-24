//
//  WMSpecInfoSelectHeaderView.h
//  StandardShop
//
//  Created by mac on 16/6/12.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WMGoodDetailInfo.h"
#define WMSpecInfoSelectHeaderViewHeight 120.0
/**商品规格选择的头部视图
 */
@interface WMSpecInfoSelectHeaderView : UIView
/**初始化视图
 */
- (void)configureUI;
/**选中的货品图片
 */
@property (copy,nonatomic) NSString *productImage;
/**选中的货品价格
 */
@property (copy,nonatomic) NSString *productPrice;
/**货品的库存
 */
@property (copy,nonatomic) NSString *productStore;
/**商品的名称
 */
@property (copy,nonatomic) NSString *productName;
/**商品类型
 */
@property (assign,nonatomic) GoodPromotionType type;
/**商品的已选规格显示
 */
@property (copy,nonatomic) NSAttributedString *specInfoAttrString;
/**点击关闭的回调
 */
@property (copy,nonatomic) void(^closeSpecInfoSelect)(void);
/**更新价格、图片和货号
 */
- (void)updateUI;
@end

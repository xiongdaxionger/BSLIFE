//
//  WMGoodSpecValueSelectViewController.h
//  StandardShop
//
//  Created by mac on 16/6/13.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "SeaViewController.h"
#import "WMSpecInfoSelectFooterView.h"

@class WMGoodDetailInfo;

/**商品的规格选择
 */
@interface WMGoodSpecValueSelectViewController : SeaViewController
/**商品的数据模型
 */
@property (strong,nonatomic) WMGoodDetailInfo *goodInfo;
/**切换动画协议
 */
@property (strong,nonatomic) SeaPartialPresentTransitionDelegate *p_delegate;
/**导航控制器
 */
@property (weak,nonatomic) UINavigationController *navigation;
/**购买配件的数量
 */
@property (assign,nonatomic) NSInteger adjunctBuyQuantity;
/**属性选择尾部视图
 */
@property (strong,nonatomic) UIButton *footerView;
/**是否为兑换赠品
 */
@property (assign,nonatomic) BOOL isGiftProduct;
/**是否为立即购买
 */
@property (assign,nonatomic) BOOL isFastBuy;
/**到货通知状态
 */
@property (assign,nonatomic) BOOL notify;
/**能否购买
 */
@property (assign,nonatomic) BOOL canBuy;
/**选中的按钮类型
 */
@property (copy,nonatomic) NSString *value;
/**显示/隐藏
 */
- (void)dismissSelf;
/**隐藏时的回调
 */
@property (copy,nonatomic) void(^dismissCallBack)(void);
/**选中某个规格时的回调
 */
@property (copy,nonatomic) void(^selectSpecInfo)(void);
/**初始化
 */
- (void)initialization;
/**计算高度
 */
- (CGFloat)returnGoodDetailInfoSpecValueHeight;
/**更新底部按钮UI
 */
- (void)updateFooterView;

@end

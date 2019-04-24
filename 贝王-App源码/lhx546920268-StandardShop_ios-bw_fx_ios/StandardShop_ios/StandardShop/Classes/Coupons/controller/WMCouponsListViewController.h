//
//  WMCouponsListViewController.h
//  WuMei
//
//  Created by 罗海雄 on 15/7/23.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

@class WMCouponsListViewController;
@class WMCouponsInfo;


@protocol WMCouponsListViewControllerDelegate <NSObject>

/**选择某个优惠券
 */
- (void)couponsListViewController:(WMCouponsListViewController*)view didSelectCouponsInfo:(NSDictionary*)info pointDict:(NSDictionary *)pointDict;

/**取消使用优惠券
 */
- (void)couponsListViewController:(WMCouponsListViewController *)view didDselectCouponsInfo:(NSString *)newMd5String pointDict:(NSDictionary *)pointDict;

@end

/**优惠券列表，入口 用户中心首页， 确认订单时使用优惠券(可选择)
 */
@interface WMCouponsListViewController : SeaTableViewController

/**选中的收货地址信息
 */
@property(nonatomic,strong) WMCouponsInfo *selectedCouponsInfo;

/**是否可以选中优惠券，default is 'NO'
 */
@property(nonatomic,assign) BOOL wantSelectInfo;

/**是否创建优惠券
 */
@property (assign,nonatomic) BOOL isCreateCoupon;

/**优惠券信息，数组元素是 WMCouponsInfo
 * 在确认订单中选择优惠券时，最好保存已加载的优惠券信息，防止第二次选择时重新加载，可传一个 strong的属性
 */
@property(nonatomic,strong) NSMutableArray *couponsInfos;

/**是否快速购买
 */
@property (copy,nonatomic) NSString *isFastBuy;

/**选中的下标
 */
@property (strong,nonatomic) NSIndexPath *selectIndexPath;

/**协议
 */
@property(nonatomic,weak) id<WMCouponsListViewControllerDelegate> delegate;



@end

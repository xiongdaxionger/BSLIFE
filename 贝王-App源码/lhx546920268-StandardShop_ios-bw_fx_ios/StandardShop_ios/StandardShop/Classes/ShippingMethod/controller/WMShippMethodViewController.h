//
//  WMShippMethodViewController.h
//  WanShoes
//
//  Created by mac on 16/3/15.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "SeaViewController.h"

@class WMShippingMethodInfo;
@class WMStoreInfo;
@class WMPayMethodModel;

///配送方式选择
@interface WMShippMethodViewController : SeaTableViewController
/**下单的商品货品ID数组
 */
@property (strong,nonatomic) NSArray *productIDArr;
/**数据模型数组，元素是WMShippingMethodInfo
 */
@property (strong,nonatomic) NSArray *shippingMethodArr;
/**弹出动画协议
 */
@property (strong,nonatomic) SeaPartialPresentTransitionDelegate *p_delegate;
/**配送方式回调
 */
@property (copy,nonatomic) void(^selectShippingCallBack)(WMShippingMethodInfo *shippingModel,NSString *currencyString,WMPayMethodModel *payMethodModel);

- (void)dismissSelf;
@end

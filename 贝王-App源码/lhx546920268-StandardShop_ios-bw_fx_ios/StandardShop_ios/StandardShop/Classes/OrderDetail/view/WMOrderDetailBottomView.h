//
//  WMOrderDetailBottomView.h
//  AKYP
//
//  Created by 罗海雄 on 16/1/20.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMOrderDetailInfo;

@interface WMOrderDetailBottomView : UIView
/**初始化
 */
- (instancetype)initWithFrame:(CGRect)frame orderInfo:(WMOrderDetailInfo *)info;
/**确认收货
 */
@property (copy,nonatomic) void(^confirmOrderButtonClick)(void);
/**取消订单
 */
@property (copy,nonatomic) void(^cancelOrderButtonClick)(void);
/**查看物流
 */
@property (copy,nonatomic) void(^checkExpressButtonClick)(void);
/**去付款
 */
@property (copy,nonatomic) void(^payOrderButtonClick)(void);
/**再次购买
 */
@property (copy,nonatomic) void(^buyAgainButtonClick)(void);
/**删除订单
 */
@property (copy,nonatomic) void(^deleteOrderButtonClick)(void);
/**查看取货二维码
 */
@property (copy,nonatomic) void(^checkSinceQRCodeClick)(void);
@end

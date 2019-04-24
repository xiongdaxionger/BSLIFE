//
//  WMRefundOrderDetailModel.h
//  WanShoes
//
//  Created by mac on 16/4/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

/**退换货/退款详情模型
 */
@interface WMRefundOrderDetailModel : NSObject
/**订单号
 */
@property (copy,nonatomic) NSString *orderID;
/**订单商品数组
 */
@property (strong,nonatomic) NSArray *orderGoodsArr;
/**退换的类型
 */
@property (strong,nonatomic) NSArray *refundGoodType;
/**初始化--退款/退换订单详情
 */
+ (instancetype)createViewModelWithRefundDetailDict:(NSDictionary *)dict;
@end

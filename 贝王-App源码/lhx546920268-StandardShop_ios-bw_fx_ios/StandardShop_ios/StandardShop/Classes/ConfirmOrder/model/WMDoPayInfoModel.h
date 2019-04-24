//
//  WMDoPayInfoModel.h
//  StandardFenXiao
//
//  Created by mac on 15/12/18.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMDoPayInfoModel : NSObject
/**支付内容
 */
@property (copy,nonatomic) NSString *body;
/**关联ID
 */
@property (copy,nonatomic) NSString *rel_id;
/**键值
 */
@property (copy,nonatomic) NSString *key;
/**支付ID
 */
@property (copy,nonatomic) NSString *payment_id;
/**订单ID
 */
@property (copy,nonatomic) NSString *order_id;
/**支付类型
 */
@property (copy,nonatomic) NSString *pay_app_type;
/**商户ID
 */
@property (copy,nonatomic) NSString *mer_id;
/**销售商品的用户名称
 */
@property (copy,nonatomic) NSString *seller_account_name;
/**总价
 */
@property (copy,nonatomic) NSString *total_amount;
/**回调地址
 */
@property (copy,nonatomic) NSString *callback_url;
/**支付字符串
 */
@property (copy,nonatomic) NSString *payStr;
/**初始化
 */
- (instancetype)initWithDict:(NSDictionary *)dict;
@end

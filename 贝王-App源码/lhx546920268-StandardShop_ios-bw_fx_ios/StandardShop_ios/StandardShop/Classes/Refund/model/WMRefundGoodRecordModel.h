//
//  WMRefundGoodRecordModel.h
//  WanShoes
//
//  Created by mac on 16/4/6.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  退换货记录模型
 */
@interface WMRefundGoodRecordModel : NSObject
/**订单ID
 */
@property (copy,nonatomic) NSString *orderID;
/**退换货ID
 */
@property (copy,nonatomic) NSString *refundID;
/**退换的理由
 */
@property (copy,nonatomic) NSString *refundReason;
/**退换的详细描述
 */
@property (copy,nonatomic) NSString *refundDetail;
/**退换的理由及描述
 */
@property (strong,nonatomic) NSMutableAttributedString *reason;
/**平台回复
 */
@property (strong,nonatomic) NSMutableAttributedString *comment;
/**商品数据--元素是WMRefundGoodModel
 */
@property (strong,nonatomic) NSArray *goodsArr;
/**快递信息--为nil且canInputDelivery为YES时订单能填写快递单号等信息
 */
@property (copy,nonatomic) NSString *deliveryCompany;
/**快递单号
 */
@property (copy,nonatomic) NSString *deliveryNumber;
/**选择的快递公司
 */
@property (copy,nonatomic) NSString *selectCompany;
/**快递信息
 */
@property (strong,nonatomic) NSMutableAttributedString *delivery;
/**状态
 */
@property (copy,nonatomic) NSString *status;
/**能否填写快递信息
 */
@property (assign,nonatomic) BOOL canInputDelivery;
/**初始化
 */
+ (NSArray *)returnRefundGoodRecordModelArrWithDictArr:(NSArray *)dataArr;

- (void)changeCropInfoWithDict:(NSDictionary *)dict;





@end

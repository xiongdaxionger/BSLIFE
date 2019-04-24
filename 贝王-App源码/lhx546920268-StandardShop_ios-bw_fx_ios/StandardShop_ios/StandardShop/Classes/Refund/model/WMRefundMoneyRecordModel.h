//
//  WMRefundMoneyRecordModel.h
//  WanShoes
//
//  Created by mac on 16/4/6.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  退款记录模型
 */
@interface WMRefundMoneyRecordModel : NSObject
/**退款记录ID
 */
@property (copy,nonatomic) NSString *recordID;
/**退款订单的订单号
 */
@property (copy,nonatomic) NSString *orderID;
/**退款的理由
 */
@property (copy,nonatomic) NSString *refundReason;
/**退款的详细描述
 */
@property (copy,nonatomic) NSString *refundDetail;
/**退款的理由及描述
 */
@property (strong,nonatomic) NSMutableAttributedString *reason;
/**平台的回复
 */
@property (strong,nonatomic) NSMutableAttributedString *comment;
/**退款订单的状态
 */
@property (copy,nonatomic) NSString *status;
/**退款订单的商品--元素是WMRefundGoodModel
 */
@property (strong,nonatomic) NSArray *goodsArr;
/**初始化
 */
+ (NSArray *)returnRefundMoneyRecordModelArrWithDictArr:(NSArray *)dataArr;





@end

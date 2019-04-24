//
//  WMGoodDetailSellLogInfo.h
//  StandardShop
//
//  Created by mac on 16/6/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

/**商品详情的销售记录
 */
@interface WMGoodDetailSellLogInfo : NSObject
/**记录ID
 */
@property (copy,nonatomic) NSString *sellLogID;
/**购买人会员ID
 */
@property (copy,nonatomic) NSString *memberID;
/**订单ID
 */
@property (copy,nonatomic) NSString *orderID;
/**购买人昵称
 */
@property (copy,nonatomic) NSString *memberName;
/**记录价格
 */
@property (copy,nonatomic) NSString *sellLogPrice;
/**记录购买商品的货品ID
 */
@property (copy,nonatomic) NSString *productID;
/**记录购买商品的商品ID
 */
@property (copy,nonatomic) NSString *goodID;
/**记录购买商品名称
 */
@property (copy,nonatomic) NSString *goodName;
/**记录购买商品的规格
 */
@property (copy,nonatomic) NSString *goodSpecInfo;
/**购买数量
 */
@property (copy,nonatomic) NSString *buyCount;
/**购买时间
 */
@property (copy,nonatomic) NSString *buyTime;
/**批量初始化
 */
+ (NSArray *)returnSellLogInfosArrWithDictsArr:(NSArray *)dictsArr;
@end

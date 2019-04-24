//
//  WMRefundGoodModel.h
//  WanShoes
//
//  Created by mac on 16/4/6.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

/**退换货/退款详情商品模型
 */
@interface WMRefundGoodModel : NSObject
/**商品bn
 */
@property (copy,nonatomic) NSString *bnCode;
/**商品的名称
 */
@property (copy,nonatomic) NSString *name;
/**商品的数量
 */
@property (copy,nonatomic) NSString *num;
/**商品的货品ID
 */
@property (copy,nonatomic) NSString *productID;
/**商品的格式化价格
 */
@property (copy,nonatomic) NSAttributedString *price;
/**商品的价格
 */
@property (copy,nonatomic) NSString *salePrice;
/**商品的格式化价格
 */
@property (copy,nonatomic) NSString *formatPrice;
/**商品图片
 */
@property (copy,nonatomic) NSString *image;
/**最终退换/退款数量
 */
@property (copy,nonatomic) NSString *refundFinalCount;
/**规格
 */
@property (copy,nonatomic) NSString *specInfo;
/**是否选中
 */
@property (assign,nonatomic) BOOL isSelect;
/**初始化
 */
+ (NSArray *)returnRefundGoodModelArrWithDataArr:(NSArray *)dictArr;
+ (NSArray *)returnRefundRecordGoodModelsArrWithDictsArr:(NSArray *)dictArr;
@end

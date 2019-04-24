//
//  WMBillInfoModel.h
//  StandardFenXiao
//
//  Created by mac on 15/12/4.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

/**账单数据模型
 */
@interface WMBillInfoModel : NSObject
/**账单的图片
 */
@property (copy,nonatomic) NSString *billImageView;
/**账单的信息
 */
@property (copy,nonatomic) NSString *billContentStr;
/**账单的价格
 */
@property (copy,nonatomic) NSString *billPriceStr;
/**账单的时间
 */
@property (copy,nonatomic) NSString *billTimeStr;
/**账单的订单ID
 */
@property (copy,nonatomic) NSString *billOrderID;
/**账单是否为支出账单
 */
@property (assign,nonatomic) BOOL billIsAdd;

/**批量初始化
 */
+ (NSMutableArray *)billListInfoArrWith:(NSArray *)dictArr;


@end

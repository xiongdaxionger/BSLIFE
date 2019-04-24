//
//  WMRefundOperation.h
//  WanShoes
//
//  Created by mac on 16/4/6.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

///获取退换货/退款订单
#define WMGetRefundOrderListIdentifier @"WMGetRefundOrderListIdentifier"
//获取退换订单详情
#define WMRefundGoodDetailIdentifier @"WMRefundGoodDetailIdentifier"
//提交退换申请
#define WMCommitRefundGoodOrderIdentifier @"WMCommitRefundGoodOrderIdentifier"
//获取退款订单详情
#define WMRefundMoneyDetailIdentifier @"WMRefundMoneyDetailIdentifier"
//提交退款申请
#define WMCommitRefundMoneyOrderIdentifier @"WMCommitRefundMoneyOrderIdentifier"
///获取退款/退换货订单记录
#define WMGetRefundRecordListIdentifier @"WMGetRefundRecordListIdentifier"
///保存快递信息
#define WMSaveDeliveryInfoIdentifier @"WMSaveDeliveryInfoIdentifier"
///获取售后须知
#define WMGetRefundReadMessage @"WMGetRefundReadMessage"

@class XTableCellConfigEx;
@class WMRefundGoodRecordModel;
@class WMRefundMoneyRecordModel;
@class WMRefundOrderDetailModel;
@class WMOrderInfo;

@interface WMRefundOperation : NSObject

#pragma mark - new

/**返回退换货记录 参数
 *@param 类型 type--退换货(reship)/退款(refund)
 */
+ (NSDictionary *)returnRefundRecordParamWithPageNumber:(NSInteger)page type:(NSString *)type;
/**返回退款记录 结果
 *return 数组元素--WMRefundMoneyRecordModel
 *return 记录总数
 */
+ (NSDictionary *)returnRefundMoneyRecordsArrWithData:(NSData *)data;
/**返回退货记录 结果
 *return 数组元素--WMRefundGoodRecordModel
 *return 快递数组--NSString
 *return 记录总数
 */
+ (NSDictionary *)returnRefundGoodRecordsArrWithData:(NSData *)data;

/**获取退款/退换订单列表 参数
 *@param 类型 type--退换货(reship)/退款(refund)
 */
+ (NSDictionary *)returnRefundOrderParamWithPage:(NSInteger)page type:(NSString *)type;

/**申请订单退款/退换详情 参数
 *@param 类型 type--退换货(reship)/退款(refund)
 */
+ (NSDictionary *)returnRefundOrderDetailWithOrderID:(NSString *)orderID type:(NSString *)type;
/**申请订单退款/退换 结果
 */
+ (WMRefundOrderDetailModel *)returnRefundOrderDetailModelWithData:(NSData *)data;

/**提交退换/退款 参数
 *@param 退换/退款理由
 *@param 退换/退款详细原因
 *@param 退换订单
 *@param 订单ID
 *@param 类型 type--退换货(reship)/退款(refund)
 *@param 退货图片--元素是NSString
 */
+ (NSDictionary *)returnCommitRefundOrderWith:(NSString *)reason detailReason:(NSString *)detailReason orderModel:(WMRefundOrderDetailModel *)orderModel type:(NSString *)type imagesArr:(NSArray *)imagesArr;
/**提交退款/退换 结果
 */
+ (BOOL)returnCommitRefundOrderResultWithData:(NSData *)data;

/**保存退款单快递信息 参数
 *@param 快递公司名称
 *@param 快递单号
 *@param 售后单号
 */
+ (NSDictionary *)returnSaveDeliveryInfoWithCompanyName:(NSString *)companyName deliveryNumber:(NSString *)number orderID:(NSString *)orderID;
/**保存退款单快递信息 结果
 */
+ (NSDictionary *)returnSaveDeliveryInfoResultWithData:(NSData *)data;

/**返回退换货记录每组的行数
 */
+ (NSInteger)returnRefundGoodRecordSectionNumber:(WMRefundGoodRecordModel *)goodRecordModel;
/**返回退换货记录的配置类
 */
+ (XTableCellConfigEx *)returnRefundGoodRecordConfigWith:(WMRefundGoodRecordModel *)goodRecordModel indexPath:(NSInteger)index configArr:(NSArray *)configArr;
/**返回退换记录的模型
 */
+ (id)returnRefundGoodRecordModelWithIndex:(NSInteger)index goodRecordModel:(WMRefundGoodRecordModel *)goodRecordModel controller:(SeaTableViewController *)controller;
/**返回退换记录每行高度
 */
+ (CGFloat)returnRefundGoodRecordCellHeightWithIndex:(NSInteger)index goodRecordModel:(WMRefundGoodRecordModel *)goodRecordModel;

/**返回退款记录每组的行数
 */
+ (NSInteger)returnRefundMoneyRecordSectionNumber:(WMRefundMoneyRecordModel *)moneyRecordModel;
/**返回退款记录的配置类
 */
+ (XTableCellConfigEx *)returnRefundMoneyRecordConfigWith:(WMRefundMoneyRecordModel *)moneyRecordModel indexPath:(NSInteger)index configArr:(NSArray *)configArr;
/**返回退款记录的模型
 */
+ (id)returnRefundMoneyRecordModelWithIndex:(NSInteger)index moneyRecordModel:(WMRefundMoneyRecordModel *)moenyRecordModel;
/**返回退款记录每行高度
 */
+ (CGFloat)returnRefundMoneyRecordCellHeightWithIndex:(NSInteger)index moneyRecordModel:(WMRefundMoneyRecordModel *)moneyRecordModel;

/**售后须知文章 参数
 */
+ (NSDictionary *)returnRefundReadMessageParam;
/**售后须知文章 结果
 *@return 售后须知的html
 */
+ (NSString *)returnRefundReadMessageResult:(NSData *)data;
@end

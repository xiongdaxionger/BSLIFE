//
//  WMOrderDetailOpeartion.h
//  WanShoes
//
//  Created by mac on 16/3/18.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

//订单详情组
typedef NS_ENUM(NSInteger, OrderDetailSection){

    //订单号
    OrderDetailSectionID = 0,
    
    //代客下单
    OrderDetailSectionCustomer = 1,
    
    //地址
    OrderDetailSectionAddress = 2,
    
    //普通商品
    OrderDetailSectionNormalGood = 3,
    
    //订单赠品
    OrderDetailSectionOrderGiftGood = 4,
    
    //积分兑换赠品
    OrderDetailSectionPointGood = 5,
    
    //订单享受的优惠
    OrderDetailSectionPromotion = 6,
    
    //订单自提码
    OrderDetailSectionSinceCode = 7,
    
    //订单基本信息
    OrderDetailSectionInfo = 8,
    
    //订单价格信息
    OrderDetailSectionPrice = 9,
    
};

//获取订单详情
#define WMOrderDetailIdentifier @"WMOrderDetailIdentifier"

@class WMOrderDetailInfo;
@class XTableCellConfigEx;
@interface WMOrderDetailOpeartion : NSObject
/**返回订单详情的每组的行数
 */
+ (NSInteger)returnSectionRowNumberWithIndexPath:(NSInteger)section orderModel:(WMOrderDetailInfo *)orderModel;
/**返回订单详情的组数
 */
+ (NSInteger)returnSectionNumberWithInfo:(WMOrderDetailInfo *)info;
/**返回订单详情配置类
 */
+ (XTableCellConfigEx *)returnConfigWithSection:(NSIndexPath *)indexPath configArr:(NSArray *)configArr orderInfo:(WMOrderDetailInfo *)info;
/**返回订单详情模型
 */
+ (id)returnOrderModelWith:(NSIndexPath *)indexPath orderModel:(WMOrderDetailInfo *)orderModel;
/**返回订单详情尾部视图高度
 */
+ (CGFloat)returnOrderDetailTableFooterHeightWithIndex:(NSInteger)section orderInfo:(WMOrderDetailInfo *)orderInfo;
/**返回享受优惠的属性字符串--订单/商品优惠
 */
+ (NSAttributedString *)returnPromotionAttrStringWithPromotionsArr:(NSArray *)promotionsArr;
/**订单号获取订单详情 参数
 *@param 订单号
 */
+ (NSDictionary *)returnOrderDetailWithOrderID:(NSString *)orderID;
/**订单号获取订单详情 结果
 */
+ (WMOrderDetailInfo *)returnOrderDetailInfoWithData:(NSData *)data;


@end

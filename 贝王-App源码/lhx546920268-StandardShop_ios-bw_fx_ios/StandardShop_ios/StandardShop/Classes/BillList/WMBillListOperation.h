//
//  WMBillListOperation.h
//  StandardFenXiao
//
//  Created by mac on 15/12/4.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SeaDropDownMenu;
@class SeaDropDownMenuItem;
@class WMBillListViewController;

@interface WMBillListOperation : NSObject

/**返回下拉菜单
 */
+ (SeaDropDownMenu *)returnDropDownViewWith:(WMBillListViewController *)controller;

/**返回选中的二级账单状态
 */
+ (NSString *)returnSecondSelectStatusWithIndex:(NSInteger)select firstIndex:(NSInteger)firstIndex;

/**返回选中的二级账单标题
 */
+ (NSString *)returnSecondSelectTitleItem:(SeaDropDownMenuItem *)item;
/**获取账单数据 参数
 @param 账单的状态 NSString
 @param 页码 NSInteger
 @param 每页数量 NSInteger
 @param 是否为代销订单 isCommisionOrder
 */
+ (NSDictionary *)returnBillListParamWithStatus:(NSString *)payStatus pageNum:(NSInteger)page_num isCommisionOrder:(BOOL)isCommisionOrder;
/**获取账单数据 结果
 *return 字典 key为infos时数组 元素是WMBillInfoModel key为total时为总数
 */
+ (NSDictionary *)returnBillListInfosWithData:(NSData *)data;
@end

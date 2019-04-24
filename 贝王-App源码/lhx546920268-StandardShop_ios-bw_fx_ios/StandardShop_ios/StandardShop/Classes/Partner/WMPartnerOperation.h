//
//  WMPartnerOperation.h
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/1.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

///网络请求标识
#define WMAddPartnerNeedsIdentifier @"WMAddPartnerNeedsIdentifier" ///添加会员所需信息
#define WMAddPartnerIdentifier @"WMAddPartnerIdentifier" ///添加会员
#define WMPartnerInfoListIdentifier @"WMPartnerInfoListIdentifier" ///下线会员
#define WMPartnerLevelupIdentifier @"WMPartnerLevelupIdentifier" ///升级会员
#define WMPartnerLevelListIdentifier @"WMPartnerLevelListIdentifier" ///获取等级

///升级成功通知
#define WMPartnerLevelupSuccessNotification @"WMPartnerLevelupSuccessNotification" 
#define WMPartnerLevelInfoKey @"levelInfo" ///新的等级信息
#define WMPartnerInfoUserId @"userId" ///升级的用户id

///添加会员成功通知
#define WMPartnerDidAddNotification @"WMPartnerDidAddNotification"

///会员列表排序
typedef NS_ENUM(NSInteger, WMPartnerListOrderBy)
{
    ///默认排序
    WMPartnerListOrderByDefault = 0,
    
    ///收益排序
    WMPartnerListOrderByIncome = 1,
    
    ///团队、下线人数排序
    WMPartnerListOrderByTeam = 2,
};

///会员每页数量
#define WMPartnerPageSize 20

@class WMPartnerInfo,WMPartnerLevelInfo;

///会员网络操作
@interface WMPartnerOperation : NSObject

/**添加会员所需信息 参数
 */
+ (NSDictionary*)addPartnerNeedsParams;

/**添加会员所需信息 结果
 *@return 如果需要图形验证码，则返回图形验证码链接
 */
+ (NSString*)addPartnerNeedsFromData:(NSData*) data;

/**添加会员 参数
 *@param phoneNumber 手机号码
 *@param code 短信验证码
 *@param name 昵称
 *@param passwd 密码
 */
+ (NSDictionary*)addPartnerParamWithPhoneNumber:(NSString*) phoneNumber code:(NSString*) code name:(NSString*) name passwd:(NSString*) passwd;

/**添加会员结果
 *@return 是否添加成功
 */
+ (BOOL)addPartnerResultFromData:(NSData*) data;

/**获取某个用户的下线 参数
 *@param userId 要获取下线的用户id
 *@param pageIndex 页码
 *@param levelInfo 筛选等级
 *@param orderBy 排序 
 *@param keyword 搜索关键字
 */
+ (NSDictionary*)partnerInfoListParamWithUserId:(NSString*) userId
                                      pageIndex:(int) pageIndex
                                      levelInfo:(WMPartnerLevelInfo*) levelInfo
                                        orderBy:(WMPartnerListOrderBy) orderBy
                                        keyword:(NSString*) keyword;

/**获取某个用户的下线 结果
 *@param totalSize 列表总数
 *@param hierarchy 分销层级
 */
+ (NSArray*)partnerInfoListFromData:(NSData*) data totalSize:(long long *) totalSize hierarchy:(int*) hierarchy;

/**升级会员 参数
 *@param info 要升级的会员
 *@param code 升级码
 */
+ (NSDictionary*)partnerLevelupParamWithInfo:(WMPartnerInfo*) info code:(NSString*) code;

/**升级会员 结果
 *@return 新的会员等级信息
 */
+ (WMPartnerLevelInfo*)partnerLevelupResultFromData:(NSData*) data;

/**获取可筛选的 会员等级 参数
 */
+ (NSDictionary*)partnerLevelListParam;

/**获取可筛选的 会员等级 参数
 *@return 数组元素是 WMPartnerLevelInfo
 */
+ (NSMutableArray*)partnerLevelListFromData:(NSData*) data;

/**获取会员销售订单 参数
 *@param info 会员信息
 *@param pageIndex 页码
 */
+ (NSDictionary*)partnerOrderListParamWithPartnerInfo:(WMPartnerInfo*) info pageIndex:(int) pageIndex;

/**获取会员销售订单 结果
 *@param totalSize 列表数量
 *@return 数组元素是 WMOrderListModel
 */
+ (NSArray*)partnerOrderListFromData:(NSData *)data totalSize:(long long*) totalSize;

@end

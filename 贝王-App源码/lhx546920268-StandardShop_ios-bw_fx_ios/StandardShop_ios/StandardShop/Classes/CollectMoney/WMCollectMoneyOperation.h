//
//  WMCollectMoneyOperation.h
//  StandardFenXiao
//
//  Created by 罗海雄 on 16/3/8.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WMCollectMoneyInfo;

///收钱网络操作
@interface WMCollectMoneyOperation : NSObject

/**生成收钱信息 参数
 *@param amount 收钱金额
 *@param title 收钱标题
 */
+ (NSDictionary*)collectMoneyParamWithAmount:(NSString*) amount title:(NSString*) title;

/**生成收钱信息 结果
 *@return 收钱信息，或nil，生成收钱信息失败
 */
+ (WMCollectMoneyInfo*)collectMoneyResultFromData:(NSData*) data;

@end

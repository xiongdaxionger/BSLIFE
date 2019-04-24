//
//  WMGoodCollectionInfo.h
//  WuMei
//
//  Created by 罗海雄 on 15/7/31.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMGoodInfo.h"

/**收藏信息
 */
@interface WMGoodCollectionInfo : NSObject

/**收藏Id
 */
@property(nonatomic,assign) long long Id;

/**收藏时间
 */
@property(nonatomic,copy) NSString *time;

/**商品信息
 */
@property(nonatomic,strong) WMGoodInfo *goodInfo;

/**从字典中创建
 *@param dic 包含收藏信息的字典
 *@return 一个实例
 */
+ (id)infoFromDictionary:(NSDictionary*) dic;

@end

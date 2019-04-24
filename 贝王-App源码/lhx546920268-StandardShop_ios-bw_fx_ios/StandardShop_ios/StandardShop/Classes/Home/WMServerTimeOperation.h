//
//  WMServerTimeOperation.h
//  WuMei
//
//  Created by 罗海雄 on 15/7/30.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import <Foundation/Foundation.h>

/**获取服务器时间
 */
@interface WMServerTimeOperation : NSObject

/**服务器时间戳 距离1970至今的秒数
 */
@property(nonatomic,assign) NSTimeInterval time;

/**从字典中获取服务器时间
 */
+ (void)timeFromDictionary:(NSDictionary*) dic;

/**单例
 */
+ (WMServerTimeOperation*)sharedInstance;

///加载服务器时间
- (void)loadServerTime;

@end

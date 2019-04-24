//
//  WMPartnerLevelInfo.h
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/18.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

/**会员等级信息
 */
@interface WMPartnerLevelInfo : NSObject

///等级id
@property(nonatomic,copy) NSString *levelId;

///等级名称
@property(nonatomic,copy) NSString *levelName;

///从字典中创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic;

@end

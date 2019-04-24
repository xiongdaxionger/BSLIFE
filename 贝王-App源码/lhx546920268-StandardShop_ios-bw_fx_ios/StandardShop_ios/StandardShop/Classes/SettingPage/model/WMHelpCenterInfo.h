//
//  WMHelpCenterInfo.h
//  WestMailDutyFee
//
//  Created by 罗海雄 on 15/9/7.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

/**帮助中心信息
 */
@interface WMHelpCenterInfo : NSObject

/**文章id
 */
@property(nonatomic,copy) NSString *Id;

/**标题
 */
@property(nonatomic,copy) NSString *title;

/**内容,html
 */
@property(nonatomic,copy) NSString *content;

///通过字典创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic;

@end

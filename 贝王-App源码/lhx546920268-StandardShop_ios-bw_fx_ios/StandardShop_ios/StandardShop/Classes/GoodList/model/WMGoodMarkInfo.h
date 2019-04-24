//
//  WMGoodMarkInfo.h
//  StandardShop
//
//  Created by 罗海雄 on 16/6/27.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

///商品标记信息 如促销、限购
@interface WMGoodMarkInfo : NSObject

///标记大小
@property(nonatomic,assign) CGSize size;

///标记内容
@property(nonatomic,copy) NSString *text;

/**通过字典创建
 *@param dic 包含标记信息的字典
 *@return 数组元素是 WMGoodMarkInfo
 */
+ (NSArray*)infosFromDictionary:(NSDictionary*) dic;

@end

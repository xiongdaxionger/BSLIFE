//
//  WMGoodListSettings.h
//  StandardShop
//
//  Created by 罗海雄 on 16/6/27.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

///商品列表设置信息
@interface WMGoodListSettings : NSObject

///是否显示评论人数
@property(nonatomic,assign) BOOL showCommentCount;

///当前分类名称
@property(nonatomic,copy) NSString *categoryName;

///默认列表样式，是否单行
@property(nonatomic,assign) BOOL isSingleRow;

/**通过字典创建
 *@param dic 包含设置信息的字典
 *@return 一个实例
 */
+ (instancetype)infoFromDictionary:(NSDictionary*) dic;

@end

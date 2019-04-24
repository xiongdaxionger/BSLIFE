//
//  WMCategoryInfo.h
//  WuMei
//
//  Created by 罗海雄 on 15/7/18.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import <Foundation/Foundation.h>

/**商品分类
 */
@interface WMCategoryInfo : NSObject

/**分类id
 */
@property(nonatomic,assign) long long categoryId;

/**是否是虚拟分类
 */
@property(nonatomic,assign) BOOL isVirtualCategory;

/**分类名称
 */
@property(nonatomic,copy) NSString *categoryName;

/**分类图标
 */
@property(nonatomic,copy) NSString *imageURL;

/**所属分类
 */
@property(nonatomic,weak) WMCategoryInfo *pInfo;

/**用于一级分类判断是否存在3级分类
 */
@property(nonatomic,assign) BOOL existThreeCategory;

/**分类对应的筛选属性
 */
@property (strong,nonatomic) NSArray *filterInfoArr;

/**下级级分类 数组元素是 WMCategoryInfo
 */
@property(nonatomic,strong) NSMutableArray *categoryInfos;

/**通过字典创建
 */
+ (instancetype)infoFromDictionary:(NSDictionary*) dic;

@end

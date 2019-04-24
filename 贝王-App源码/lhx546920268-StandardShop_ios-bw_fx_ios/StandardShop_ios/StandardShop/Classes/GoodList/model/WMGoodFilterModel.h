//
//  WMGoodFilterModel.h
//  StandardFenXiao
//
//  Created by mac on 16/1/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMGoodFilterModel : NSObject
/**类型名称
 */
@property (copy,nonatomic) NSString *filterTypeName;
/**类型含有的筛选种类，元素是WMGoodFilterOptionModel
 */
@property (strong,nonatomic) NSArray *filterTypeArr;
/**筛选的类型，用与http的参数
 */
@property (copy,nonatomic) NSString *filterField;
/**是否单选
 */
@property (assign,nonatomic) BOOL isSingle;
/**是否图片类型
 */
@property (assign,nonatomic) BOOL isLogo;
/**记录单选情况下选中的下标值
 */
@property (strong,nonatomic) NSIndexPath *singleSelectPath;
/**是否打开
 */
@property (assign,nonatomic) BOOL isDrop;

/**如果不是图片类型，一行最大的显示数量，没展开时
 */
@property (assign,nonatomic) NSInteger maxCountWhenNotExpand;

/**批量初始化
 */
+ (NSArray *)initWithArr:(NSArray *)arr;

@end

@interface WMGoodFilterOptionModel : NSObject
/**筛选种类ID
 */
@property (copy,nonatomic) NSString *filterOptionID;
/**筛选种类名称
 */
@property (copy,nonatomic) NSString *filterOptionName;
/**图片
 */
@property (copy,nonatomic) NSString *filterLogo;
/**是否选中
 */
@property (assign,nonatomic) BOOL isSelect;

///名称大小
@property (assign,nonatomic) CGSize size;

/**批量初始化
 */
+ (NSArray *)initWithArr:(NSArray *)arr;
@end

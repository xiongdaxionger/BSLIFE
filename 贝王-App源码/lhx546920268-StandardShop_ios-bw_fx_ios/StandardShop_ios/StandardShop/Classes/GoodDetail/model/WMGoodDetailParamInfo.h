//
//  WMGoodDetailParamInfo.h
//  StandardShop
//
//  Created by mac on 16/6/6.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

/**商品详情的详细参数内容
 */
@interface WMGoodDetailParamValueInfo : NSObject
/**参数名字
 */
@property (copy,nonatomic) NSString *paramName;
/**参数内容
 */
@property (copy,nonatomic) NSString *paramContent;
/**批量初始化
 */
+ (NSArray *)returnGoodDetailParamValueInfosArrWithDictArr:(NSArray *)dictArr;
@end

/**商品详情的详细参数
 */
@interface WMGoodDetailParamInfo : NSObject
/**参数组名
 */
@property (copy,nonatomic) NSString *groupParamName;
/**参数组内容--元素是WMGoodDetailParamValueInfo
 */
@property (strong,nonatomic) NSArray *groupParamsArr;
/**批量初始化
 */
+ (NSArray *)returnGoodDetailParamInfosArrWithDictArr:(NSArray *)dictArr;
@end

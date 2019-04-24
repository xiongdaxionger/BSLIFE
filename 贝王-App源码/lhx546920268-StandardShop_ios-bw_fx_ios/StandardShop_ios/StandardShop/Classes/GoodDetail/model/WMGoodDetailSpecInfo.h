//
//  WMGoodSpecInfo.h
//  StandardShop
//
//  Created by mac on 16/6/6.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

/**商品详情规格值信息模型
 */
@interface WMGoodDetailSpecValueInfo : NSObject
/**规格值是否选中
 */
@property (assign,nonatomic) BOOL valueSelect;
/**规格值货品ID--选中时为nil
 */
@property (copy,nonatomic) NSString *valueProductID;
/**规格值对应的图片--文字规格时值为nil
 */
@property (copy,nonatomic) NSString *valueSpecImage;
/**规格值名称
 */
@property (copy,nonatomic) NSString *valueSpecName;
/**批量初始化
 */
+ (NSArray *)returnGoodSpecValueInfoArrWithDictArr:(NSArray *)dictArr;
@end

/**商品详情规格信息模型
 */
@interface WMGoodDetailSpecInfo : NSObject
/**规格名称
 */
@property (copy,nonatomic) NSString *specInfoName;
/**规格值数组--元素是WMGoodDetailSpecValueInfo
 */
@property (strong,nonatomic) NSArray *specValueInfosArr;
/**规格是否为图片规格
 */
@property (assign,nonatomic) BOOL specInfoIsImage;
/**当前选中的规格下标
 */
@property (assign,nonatomic) NSInteger selectIndex;
/**规格的标题数组--元素是NSString
 */
@property (strong,nonatomic) NSMutableArray *titlesArr;
/**批量初始化
 */
+ (NSArray *)returnGoodSpecInfoArrWithDictArr:(NSArray *)dictArr;
 
 
 
 
 
@end

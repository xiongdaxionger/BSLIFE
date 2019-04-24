//
//  WMGoodsAccessRecordInfo.h
//  StandardShop
//
//  Created by 罗海雄 on 2017/11/24.
//  Copyright © 2017年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

///商品存取记录信息
@interface WMGoodsAccessRecordInfo : NSObject

/**商品Id
 */
@property(nonatomic,copy) NSString *goodId;

/**货品Id
 */
@property (copy,nonatomic) NSString *productId;

/**商品名称
 */
@property(nonatomic,copy) NSString *goodName;

/**商品图片
 */
@property(nonatomic,copy) NSString *imageURL;

///时间
@property(nonatomic,copy) NSString *time;

///剩余数量
@property(nonatomic,assign) int count;

///门店
@property(nonatomic,copy) NSString *store;


/**通过字典创建
 */
+ (instancetype)infoFromDictionary:(NSDictionary*) dic;

@end

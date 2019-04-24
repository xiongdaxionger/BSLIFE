//
//  WMGoodDetailPointInfo.h
//  StandardShop
//
//  Created by mac on 16/6/6.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

/**商品详情评分模型
 */
@interface WMGoodDetailPointInfo : NSObject
/**评分人数
 */
@property (copy,nonatomic) NSString *goodPointCount;
/**评论人数
 */
@property (copy,nonatomic) NSString *goodCommentCount;
/**评论显示的星星个数
 */
@property (copy,nonatomic) NSString *goodPointStarCount;
/**评分总分
 */
@property (copy,nonatomic) NSString *goodPointSum;
/**评分平均分
 */
@property (copy,nonatomic) NSString *goodPointAverage;
/**商品的好评率,好评率为0时不显示好评率
 */
@property (copy,nonatomic) NSString *goodBestPointRate;
/**初始化
 */
+ (instancetype)returnGoooDetailPointInfoWithDict:(NSDictionary *)dict;
@end

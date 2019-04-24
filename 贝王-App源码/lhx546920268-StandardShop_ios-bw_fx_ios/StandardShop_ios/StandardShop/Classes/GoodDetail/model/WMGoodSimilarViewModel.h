//
//  GoodSimilarViewModel.h
//  SchoolBuy
//
//  Created by Hank on 15/6/25.
//  Copyright (c) 2015年 Hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMGoodSimilarViewModel : NSObject
/**相似商品的ID
 */
@property (nonatomic, copy) NSString *similarGoodsId;
/**相似商品的图片链接
 */
@property (nonatomic, copy) NSString *similarImageUrl;
/**相似商品的名称
 */
@property (nonatomic, copy) NSString *similarGoodName;
/**相似商品的价格
 */
@property (nonatomic, copy) NSString *similarGoodPrice;
/**是否上架
 */
@property (assign,nonatomic) BOOL marketable;
/**初始化
 */
+ (instancetype)createViewModelWithModel:(NSDictionary *)dict;
/**批量初始化
 */
+ (NSArray *)createViewModelArryWithArry:(NSArray *)modelArry;
@end

//
//  WMGoodFilterViewController.h
//  StandardFenXiao
//
//  Created by mac on 16/1/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "SeaCollectionViewController.h"

@class WMGoodListViewController;

/**商品的筛选
 */
@interface WMGoodFilterViewController : SeaCollectionViewController

/**内容数组
 */
@property (strong,nonatomic) NSArray *filterModelArr;

/**可筛选的商品数量
 */
@property (assign,nonatomic) NSInteger filterGoodCount;

/**关联的商品列表
 */
@property(nonatomic,weak) WMGoodListViewController *goodListViewController;

/**确认按钮的回调
 *@param filters 筛选参数
 */
@property (copy,nonatomic) void(^confirmButtonClick)(void);

/**数据下载完成后回调
 */
@property (copy,nonatomic) void(^httpFinishCallBack)(NSArray *filterModelsArr);
/**商品分类ID
 */
@property (copy,nonatomic) NSString *goodCateID;

- (void)configureUI;

@property (assign,nonatomic) BOOL hasCategoryMenuBar;

///获取筛选参数
- (NSDictionary*)filters;

@end

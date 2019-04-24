//
//  WMGoodListViewController.h
//  WuMei
//
//  Created by 罗海雄 on 15/7/18.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "SeaTableViewController.h"

@class WMCategoryInfo,WMBrandInfo;

///商品列表
@interface WMGoodListViewController : SeaCollectionViewController

///标题名称
@property (nonatomic,copy) NSString *titleName;

///是否只获取预售商品
@property (nonatomic,assign) BOOL onlyPresell;

///搜索关键字
@property (nonatomic,copy) NSString *searchKey;

///促销标签id
@property (nonatomic,copy) NSString *promotionTagId;

///商品品牌信息
@property(nonatomic,copy) WMBrandInfo *brandInfo;

/**以商品分类初始化
 *@param info 商品分类信息
 *@return 一个实例
 */
- (instancetype)initWithCategoryInfo:(WMCategoryInfo*) info;

/**以商品品牌初始化
 *@param info 商品品牌信息
 *@return 一个实例
 */
- (instancetype)initWithBrandInfo:(WMBrandInfo*) info;

@end



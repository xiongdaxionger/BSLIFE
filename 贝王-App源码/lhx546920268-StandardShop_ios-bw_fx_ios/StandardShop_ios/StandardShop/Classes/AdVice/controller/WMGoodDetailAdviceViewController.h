//
//  WMGoodDetailAdviceViewController.h
//  StandardShop
//
//  Created by mac on 16/6/2.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "SeaTableViewController.h"

/**商品详情咨询列表
 */
@interface WMGoodDetailAdviceViewController : SeaTableViewController
/**咨询内容数组，内容是WMAdviceQuestionInfo
 */
@property (strong,nonatomic) NSMutableArray *adviceInfoArr;
/**页码
 */
@property (assign,nonatomic) NSInteger pageNum;
/**菜单栏
 */
@property (strong,nonatomic) SeaMenuBar *adviceListMenuBar;
/**表格视图的配置
 */
@property (strong,nonatomic) NSArray *configureArr;
/**咨询类型数组，内容是WMAdviceTypeInfo
 */
@property (strong,nonatomic) NSArray *adviceTypeInfoArr;
/**商品ID
 */
@property (copy,nonatomic) NSString *goodID;
/**选中的菜单栏下标
 */
@property (assign,nonatomic) NSInteger selectIndex;
@end

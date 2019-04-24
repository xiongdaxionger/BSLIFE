//
//  WMGoodGraphicDetailViewController.h
//  StandardShop
//
//  Created by mac on 16/6/16.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "SeaTableViewController.h"

@class WMGoodDetailInfo;
/**商品详情的图文详情
 */
@interface WMGoodGraphicDetailViewController : SeaTableViewController<UIWebViewDelegate>
/**商品信息模型
 */
@property (strong,nonatomic) WMGoodDetailInfo *goodDetailInfo;
/**销售记录数组--元素是WMGoodDetailSellLogInfo
 */
@property (strong,nonatomic) NSMutableArray *goodSellLogInfosArr;
/**记录图文详情的高度
 */
@property (assign,nonatomic) CGFloat graphicWebHeight;
/**图文详情是否加载完成
 */
@property (assign,nonatomic) BOOL isReloadWeb;
/**销售记录是否显示价格
 */
@property (assign,nonatomic) BOOL sellLogShowPrice;
/**下拉回调
 */
@property (copy,nonatomic) void(^dropDown)(void);
@end

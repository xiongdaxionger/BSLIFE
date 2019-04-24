//
//  WMGoodDetailInfoViewController.h
//  StandardShop
//
//  Created by mac on 16/6/6.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "SeaTableViewController.h"

//上拉的临界值
#define UpLoadOffestMaxValue 615
@class WMGoodDetailInfo;
/**商品详情基本信息页
 */
@interface WMGoodDetailInfoViewController : SeaTableViewController
/**商品详情模型
 */
@property (strong,nonatomic) WMGoodDetailInfo *goodDetailInfo;
/**导航控制器
 */
@property (weak,nonatomic) UINavigationController *navigation;
/**上拉回调
 */
@property (copy,nonatomic) void(^upLoadCallBack)(void);
/**刷新按钮集合
 */
@property (copy,nonatomic) void(^upLoadButtonCollection)(void);
/**是否为赠品
 */
@property (assign,nonatomic) BOOL isGift;
/**弹出规格选择
 */
- (void)configureSpecInfoControllerIsGift:(BOOL)isGift fastBuy:(BOOL)fastBuy notify:(BOOL)notify canBuy:(BOOL)canBuy value:(NSString *)value;



@end

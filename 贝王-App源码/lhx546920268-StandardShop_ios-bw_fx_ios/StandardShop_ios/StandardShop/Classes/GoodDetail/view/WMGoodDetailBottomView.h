//
//  GoodDetailBottomView.h
//  WestMailDutyFee
//
//  Created by qsit on 15/8/27.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WMGoodDetailInfo.h"
#import "WMSpecInfoSelectFooterView.h"

#define WMGoodDetailBottomViewHeight 49.0
/**商品详情的底部视图
 */
@interface WMGoodDetailBottomView : UIView
/**配置UI
 */
- (void)layOutGoodBottomView;

/**收藏按钮的点击事件
 */
@property (copy,nonatomic) void(^addFavButtonAction)(UIButton *button);
/**购物车按钮的点击事件
 */
@property (copy,nonatomic) void (^shopCarButtonAction)(UIButton *button);
/**客服按钮的点击事件
 */
@property (copy,nonatomic) void (^customServiceAction)(UIButton *button);
/**购物车的数量
 */
@property (copy,nonatomic) NSString *quantity;
/**数量的文本
 */
@property (strong,nonatomic) SeaNumberBadge *badgeView;
/**是否收藏商品
 */
@property (assign,nonatomic) BOOL goodIsFav;
/**商品类型
 */
@property (assign,nonatomic) GoodPromotionType type;
/**按钮视图
 */
@property (strong,nonatomic) WMSpecInfoSelectFooterView *buttonView;
/**按钮数组
 */
@property (strong,nonatomic) NSArray *buttonPageList;
/**更新UI
 */
- (void)updateUI;

@end

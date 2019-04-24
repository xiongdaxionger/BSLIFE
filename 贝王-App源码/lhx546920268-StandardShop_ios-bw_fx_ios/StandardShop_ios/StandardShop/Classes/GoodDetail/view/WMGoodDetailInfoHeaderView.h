//
//  GoodDetailTableHeaderView.h
//  WuMei
//
//  Created by qsit on 15/8/5.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WMGoodDetailInfo;

/**商品详情名称和价格头部
 */
@interface WMGoodDetailInfoHeaderView : UIView
/**初始化
 */
- (instancetype)initWithGoodInfo:(WMGoodDetailInfo *)info;
/**更新UI
 */
- (void)updateUI;
@end

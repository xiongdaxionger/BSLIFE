//
//  GoodDetailBannerView.h
//  WuMei
//
//  Created by qsit on 15/8/4.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//
#define kBannerHeight 250
#import <UIKit/UIKit.h>
#import "SeaAutoScrollView.h"
@interface WMGoodDetailBannerView : UIView
/**商品滚动广告图片数组，内容是图片的URL
 */
@property (strong,nonatomic) NSArray *imageArr;
/**滚动视图
 */
@property (strong,nonatomic) SeaAutoScrollView *autoScrollView;
/**初始化
 */
- (instancetype)initWithImageArr:(NSArray *)imageArr;
/**拖动最后一页的回调
 */
@property (copy,nonatomic) void (^draggingLastPage)(void);
/**刷新
 */
- (void)reloadData;
@end

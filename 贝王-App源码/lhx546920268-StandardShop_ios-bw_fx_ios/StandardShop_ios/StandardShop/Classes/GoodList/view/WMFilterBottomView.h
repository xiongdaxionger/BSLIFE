//
//  WMFilterBottomView.h
//  StandardFenXiao
//
//  Created by mac on 16/1/8.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMFilterBottomView : UIView
/**初始化
 */
- (instancetype)initWithGoodCount:(int)goodCount;
/**可筛选的商品数量
 */
@property (assign,nonatomic) int goodCount;
/**重置回调
 */
@property (copy,nonatomic) void(^resetButtonClick)(UIButton *button);
/**完成回调
 */
@property (copy,nonatomic) void(^commitButtonClick)(UIButton *button);
/**改变商品数量
 */
- (void)changeFilterGoodCountWith:(int)goodCount;
@end

//
//  WMQRCodeScanBackgroundView.h
//  WestMailDutyFee
//
//  Created by 罗海雄 on 15/8/26.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

//边角线条宽度
#define WMQRCodeCornerLineWith 5.0

//扫描区域
#define WMQRCodeScanBackgroundViewScanSize (_width_ * 294.0f / 414.0f)

/**扫描框
 */
@interface WMQRCodeScanView : UIView

@end

/**二维码扫描背景
 */
@interface WMQRCodeScanBackgroundView : UIView

/**扫描框位置大小
 */
@property(nonatomic,readonly) CGRect scanBoxRect;

/**扫描框大小
 */
@property(nonatomic,assign) CGSize scanBoxSize;

/**开始扫描动画
 */
- (void)startScanAnimate;

/**停止扫描动画
 */
- (void)stopScanAnimate;

@end

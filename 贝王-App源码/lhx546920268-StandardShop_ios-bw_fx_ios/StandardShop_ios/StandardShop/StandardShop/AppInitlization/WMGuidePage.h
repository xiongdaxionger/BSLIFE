//
//  WMGuidePage.h
//  WuMei
//
//  Created by 罗海雄 on 15/8/6.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMGuidePage;

@protocol WMGuidePageDelegate <NSObject>

///引导页将要消失
- (void)guideWillDisappear:(WMGuidePage*) guildPage;

@end

/**引导页
 */
@interface WMGuidePage : UIView

@property(nonatomic,weak) id<WMGuidePageDelegate> delegate;

/**显示引导页
 */
- (void)show;

///是否需要显示引导页
+ (BOOL)shouldShowGuidePage;

@end

//
//  WMAdviceAnsertViewController.h
//  StandardShop
//
//  Created by mac on 16/6/3.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "SeaViewController.h"

@class WMAdviceQuestionInfo;
@class WMAdviceContentInfo;
@class WMAdviceSettingInfo;
/**回复咨询的问题
 */
@interface WMAdviceAnswerViewController : SeaViewController
/**回复的咨询模型
 */
@property (strong,nonatomic) WMAdviceQuestionInfo *questionInfo;
/**咨询的设置数据模型
 */
@property (strong,nonatomic) WMAdviceSettingInfo *settingInfo;
/**输入框
 */
@property (strong,nonatomic) SeaTextView *intPutView;
/**滚动视图
 */
@property (strong,nonatomic) UIScrollView *scrollView;
/**键盘是否显示
 */
@property (assign,nonatomic) BOOL keyboardHidden;
/**咨询回复后的回调
 */
@property(nonatomic,copy) void(^commitReplySuccess)(WMAdviceContentInfo *info);

@end

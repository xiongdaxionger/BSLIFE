//
//  WMAdviceTypeDialog.h
//  StandardShop
//
//  Created by mac on 16/6/2.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "SeaDialogViewController.h"

@class WMAdviceTypeInfo;
//头部高度
#define WMAdviceTypeHeaderHeight 50
//底部高度
#define WMAdviceTypeFooterHeight 55
/**咨询类型弹窗
 */
@interface WMAdviceTypeDialog : SeaDialog

/**咨询的类型数组，内容是WMAdviceTypeInfo
 */
@property (strong,nonatomic) NSArray *adviceTypeInfoArr;
/**点击确定按钮回调
 *@param 咨询类型数据模型
 */
@property(nonatomic,copy) void(^commitAdvice)(WMAdviceTypeInfo *info);
/**初始化
 */
- (id)initWithTypeInfoArr:(NSArray *)infoArr;
@end

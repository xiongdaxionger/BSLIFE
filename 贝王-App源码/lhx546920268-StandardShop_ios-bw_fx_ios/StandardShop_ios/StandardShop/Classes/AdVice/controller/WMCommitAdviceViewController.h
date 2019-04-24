//
//  WMCommitAdviceViewController.h
//  StandardShop
//
//  Created by mac on 16/6/2.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "SeaViewController.h"
@class WMAdviceSettingInfo;
@class WMAdviceQuestionInfo;
//全部类型的ID
#define WMAdviceAllTypeID @"0"
/**提交商品咨询
 */
@interface WMCommitAdviceViewController : SeaViewController
/**输入框
 */
@property (strong,nonatomic) SeaTextView *intPutView;
/**滚动视图
 */
@property (strong,nonatomic) UIScrollView *scrollView;
/**键盘是否显示
 */
@property (assign,nonatomic) BOOL keyboardHidden;
/**是否匿名咨询
 */
@property (assign,nonatomic) BOOL isHiddenName;
/**咨询的类型
 */
@property (strong,nonatomic) NSArray *adviceTypeInfoArr;
/**列表选中的咨询类型ID
 */
@property (copy,nonatomic) NSString *listSelectAdviceTypeID;
/**商品ID
 */
@property (copy,nonatomic) NSString *goodID;
/**选中的行
 */
@property (assign,nonatomic) NSInteger selectIndex;
/**咨询设置数据模型
 */
@property (strong,nonatomic) WMAdviceSettingInfo *settingInfo;
/**发表咨询后的回调
 */
@property (nonatomic,copy) void(^commitAdviceSuccess)(WMAdviceQuestionInfo *info);
/**发表咨询后改变咨询类型数量的回调
 */
@property (nonatomic,copy) void(^changeAdviceCount)(NSArray *titlesArr);


@end

//
//  WMAdviceQusetionInfo.h
//  StandardShop
//
//  Created by mac on 16/6/2.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMAdviceContentInfo.h"
//显示展开查看更多的数量界限
#define WMShowMoreInfoMaxCount 2
/**咨询提问数据模型
 */
@interface WMAdviceQuestionInfo : WMAdviceContentInfo
/**咨询提问的回复，内容是WMAdviceContentInfo
 */
@property (strong,nonatomic) NSMutableArray *adviceAnswerInfoArr;
/**当前问题是否展开显示--当问题回答多于两条并用户点击查看更多时为YES
 */
@property (assign,nonatomic) BOOL isShowMoreOpen;
/**返回自身内容高度
 */
- (CGFloat)returnContentHeightCanReply:(BOOL)canReply;
@end

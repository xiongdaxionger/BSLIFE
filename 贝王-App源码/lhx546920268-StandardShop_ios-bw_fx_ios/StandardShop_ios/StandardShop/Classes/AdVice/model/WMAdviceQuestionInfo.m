//
//  WMAdviceQusetionInfo.m
//  StandardShop
//
//  Created by mac on 16/6/2.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMAdviceQuestionInfo.h"

@implementation WMAdviceQuestionInfo

/**批量初始化
 */
+ (NSArray *)returnAdviceContentInfoArrWithDictArr:(NSArray *)dictArr{
    
    NSMutableArray *infoArr = [NSMutableArray arrayWithCapacity:dictArr.count];
    
    for (NSDictionary *dict in dictArr) {
        
        [infoArr addObject:[WMAdviceQuestionInfo returnAdviceContentInfoWithDict:dict]];
    }
    
    return infoArr;
}

/**初始化
 */
+ (instancetype)returnAdviceContentInfoWithDict:(NSDictionary *)dict{
    
    WMAdviceQuestionInfo *questionInfo = [WMAdviceQuestionInfo new];
    
    questionInfo.adviceID = [dict sea_stringForKey:@"comment_id"];
    
    questionInfo.adviceContent = [dict sea_stringForKey:@"comment"];
    
    questionInfo.adviceTime = [NSDate previousDateWithTimeInterval:[[dict sea_stringForKey:@"time"] doubleValue]];
    
    questionInfo.adviceUserID = [dict sea_stringForKey:@"author_id"];
    
    questionInfo.adviceUserName = [dict sea_stringForKey:@"author"];
    
    questionInfo.type = AdviceTypeQuestion;
    
    questionInfo.isShowMoreOpen = NO;
    
    questionInfo.adviceAnswerInfoArr = [WMAdviceContentInfo returnAdviceContentInfoArrWithDictArr:[dict arrayForKey:@"items"]];
    
    return questionInfo;
}

/**返回自身内容高度
 */
- (CGFloat)returnContentHeightCanReply:(BOOL)canReply{
    
    CGFloat maxWidth = canReply ? _width_ - 75.0 : _width_ - 54.0;
    
    return MAX([self.adviceContent stringSizeWithFont:[UIFont fontWithName:MainFontName size:15.0] contraintWith:maxWidth].height, 38.0) + 1.0;
}




@end

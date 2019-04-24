//
//  WMAdviceContentInfo.m
//  StandardShop
//
//  Created by mac on 16/6/2.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMAdviceContentInfo.h"

#import "NSDate+Utilities.h"
@implementation WMAdviceContentInfo
/**批量初始化
 */
+ (NSMutableArray *)returnAdviceContentInfoArrWithDictArr:(NSArray *)dictArr{
    
    NSMutableArray *infoArr = [NSMutableArray arrayWithCapacity:dictArr.count];
    
    for (NSDictionary *dict in dictArr) {
        
        [infoArr addObject:[WMAdviceContentInfo returnAdviceContentInfoWithDict:dict]];
    }
    
    return infoArr;
}

+ (instancetype)returnAdviceContentInfoWithDict:(NSDictionary *)dict{
    
    WMAdviceContentInfo *contentInfo = [WMAdviceContentInfo new];
    
    contentInfo.adviceID = [dict sea_stringForKey:@"comment_id"];
    
    contentInfo.adviceContent = [dict sea_stringForKey:@"comment"];
    
    contentInfo.adviceTime = [NSDate previousDateWithTimeInterval:[[dict sea_stringForKey:@"time"] doubleValue]];
    
    contentInfo.adviceUserID = [dict sea_stringForKey:@"author_id"];
    
    contentInfo.adviceUserName = [dict sea_stringForKey:@"author"];

    if ([contentInfo.adviceUserID isEqualToString:@"0"]) {
        
        contentInfo.type = AdviceTypeAdminAnswer;
    }
    else{
        
        contentInfo.type = AdviceTypeMemberAnswer;
    }
    
    return contentInfo;
}

- (CGFloat)returnContentHeight{
    
    return MAX([self.adviceContent stringSizeWithFont:[UIFont fontWithName:MainFontName size:15.0] contraintWith:_width_ - 45].height, 21.0) + 1.0 + 33.0;
}










@end

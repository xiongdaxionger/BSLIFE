//
//  WMWithDrawAccountInfo.m
//  StandardFenXiao
//
//  Created by mac on 15/12/21.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import "WMWithDrawAccountInfo.h"

@implementation WMWithDrawAccountInfo

/**批量初始化
 */
+ (NSMutableArray *)returnInfoArrWith:(NSArray *)dictArr{
    
    NSMutableArray *infosArr = [[NSMutableArray alloc] initWithCapacity:dictArr.count];
    
    for (NSDictionary *dict in dictArr) {
        
        [infosArr addObject:[WMWithDrawAccountInfo returnInfoWithDict:dict]];
    }
    
    return infosArr;
}

+ (instancetype)returnInfoWithDict:(NSDictionary *)dict{
    
    WMWithDrawAccountInfo *info = [[WMWithDrawAccountInfo alloc] init];
    
    info.memberID = [dict sea_stringForKey:WMUserInfoId];
    
    info.blankCardPerson = [dict sea_stringForKey:@"real_name"];
    
    info.blankName = [dict sea_stringForKey:@"bank_name"];
    
    info.blankNumber = [dict sea_stringForKey:@"bank_num"];
    
    info.type = [[dict numberForKey:@"bank_type"] integerValue];
    
    info.accountID = [dict sea_stringForKey:@"member_bank_id"];
    
    info.accountLogo = [dict sea_stringForKey:@"bank_img"];
    
    if (info.type == WithDrawAccountTypeBlank) {
        
        NSInteger beiginLength = 0;
        
        NSString *str = [info.blankNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        if(str.length > 4)
        {
            info.lastNumber = [str substringFromIndex:str.length - 4];
        }
        else
        {
            info.lastNumber = str;
        }
        
        NSMutableString *realStr = [[NSMutableString alloc] initWithString:[info.blankNumber stringByReplacingOccurrencesOfString:@" " withString:@""]];
        
        NSInteger len = 4;
        ///前面的字符变成*
        for(NSInteger i = 0;i < realStr.length - len;i ++)
        {
            [realStr replaceCharactersInRange:NSMakeRange(i, 1) withString:@"*"];
        }
        
        //添加空格分隔符
        for(NSInteger i = 0;i < realStr.length;i += len)
        {
            if(i + len > realStr.length)
            {
                i = realStr.length - len;
            }
            [realStr replaceCharactersInRange:NSMakeRange(i, 0) withString:@" "];
            i ++;
        }
        
        if(realStr.length > len)
        {
            beiginLength = realStr.length - len;
        }
        
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:realStr];
        
        [text addAttribute:NSKernAttributeName value:[NSNumber numberWithFloat:0.0] range:NSMakeRange(0, text.length)];
        
        [text addAttribute:NSBaselineOffsetAttributeName value:[NSNumber numberWithFloat:_ios9_0_ ? -5.0 : -8.0] range:NSMakeRange(0, beiginLength)];
        
        [text addAttribute:NSFontAttributeName value:[UIFont fontWithName:MainNumberFontName size:_ios9_0_ ? 18 : 25] range:NSMakeRange(0, beiginLength)];
        
        info.blankAttrString = text;
    }
    
    
    return info;
}
@end

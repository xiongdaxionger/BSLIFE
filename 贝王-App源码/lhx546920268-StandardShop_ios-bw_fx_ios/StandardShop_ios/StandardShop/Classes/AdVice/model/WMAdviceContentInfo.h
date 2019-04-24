//
//  WMAdviceContentInfo.h
//  StandardShop
//
//  Created by mac on 16/6/2.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

//咨询的类型
typedef NS_ENUM(NSInteger, AdviceType){
    
    //提问
    AdviceTypeQuestion = 1,
    
    //管理员回答
    AdviceTypeAdminAnswer = 2,
    
    //普通会员回答
    AdviceTypeMemberAnswer = 3,
};

/**咨询内容数据模型
 */
@interface WMAdviceContentInfo : NSObject
/**咨询内容类型
 */
@property (assign,nonatomic) AdviceType type;
/**咨询内容
 */
@property (copy,nonatomic) NSString *adviceContent;
/**咨询内容ID
 */
@property (copy,nonatomic) NSString *adviceID;
/**咨询内容时间
 */
@property (copy,nonatomic) NSString *adviceTime;
/**咨询内容用户ID
 */
@property (copy,nonatomic) NSString *adviceUserID;
/**咨询内容用户昵称
 */
@property (copy,nonatomic) NSString *adviceUserName;
/**批量初始化
 */
+ (NSMutableArray *)returnAdviceContentInfoArrWithDictArr:(NSArray *)dictArr;
/**初始化
 */
+ (instancetype)returnAdviceContentInfoWithDict:(NSDictionary *)dict;
/**返回自身内容的高度
 */
- (CGFloat)returnContentHeight;

@end

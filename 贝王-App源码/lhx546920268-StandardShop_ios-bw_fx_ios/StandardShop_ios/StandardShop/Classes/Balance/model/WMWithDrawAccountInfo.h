//
//  WMWithDrawAccountInfo.h
//  StandardFenXiao
//
//  Created by mac on 15/12/21.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMWithDrawAccountInfo : NSObject
/**账户ID
 */
@property (copy,nonatomic) NSString *accountID;
/**会员ID
 */
@property (copy,nonatomic) NSString *memberID;
/**银行卡号
 */
@property (copy,nonatomic) NSString *blankNumber;
/**银行的名称
 */
@property (copy,nonatomic) NSString *blankName;
/**持卡人姓名
 */
@property (copy,nonatomic) NSString *blankCardPerson;
/**账号类型
 */
@property (assign,nonatomic) WithDrawAccountType type;
/**账号的图标
 */
@property (copy,nonatomic) NSString *accountLogo;
/**尾号
 */
@property (copy,nonatomic) NSString *lastNumber;
/**银行账号的属性字符串
 */
@property (copy,nonatomic) NSAttributedString *blankAttrString;
/**批量初始化
 */
+ (NSMutableArray *)returnInfoArrWith:(NSArray *)dictArr;
@end

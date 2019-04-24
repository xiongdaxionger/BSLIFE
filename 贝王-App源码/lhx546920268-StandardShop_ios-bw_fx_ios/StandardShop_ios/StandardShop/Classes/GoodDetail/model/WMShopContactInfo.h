//
//  WMShopContactInfo.h
//  StandardShop
//
//  Created by Hank on 16/11/14.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

/**商家联系信息
 */
@interface WMShopContactInfo : NSObject
/**商店名称--总平台，总平台用于未登录显示
 */
@property (copy,nonatomic) NSString *shopName;
/**商店联系人--总平台
 */
@property (copy,nonatomic) NSString *contactName;
/**固定电话--总平台
 */
@property (copy,nonatomic) NSString *localPhone;
/**手机--总平台
 */
@property (copy,nonatomic) NSString *telePhone;
/**QQ邮箱--总平台
 */
@property (copy,nonatomic) NSString *qqMail;
/**QQ--总平台
 */
@property (copy,nonatomic) NSString *qqNumber;
/**联系地址--总平台
 */
@property (copy,nonatomic) NSString *address;
/**邮政编码--总平台
 */
@property (copy,nonatomic) NSString *zipCode;
/**显示的富文本--总平台
 */
@property (copy,nonatomic) NSAttributedString *attrString;
/**商店名称--上线，上线用于登录显示
 */
@property (copy,nonatomic) NSString *upLineShopName;
/**商店联系人--上线
 */
@property (copy,nonatomic) NSString *upLineContactName;
/**固定电话--上线
 */
@property (copy,nonatomic) NSString *upLineLocalPhone;
/**手机--上线
 */
@property (copy,nonatomic) NSString *upLineTelePhone;
/**QQ邮箱--上线
 */
@property (copy,nonatomic) NSString *upLineQQMail;
/**QQ--上线
 */
@property (copy,nonatomic) NSString *upLineQQNumber;
/**联系地址--上线
 */
@property (copy,nonatomic) NSString *upLineAddress;
/**邮政编码--上线
 */
@property (copy,nonatomic) NSString *upLineZipCode;
/**显示的富文本--上线
 */
@property (copy,nonatomic) NSAttributedString *upLineAttrString;
/**初始化
 */
- (void)getShopContactInfo:(NSDictionary *)dict;
/**单例
 */
+ (instancetype)shareInstance;
@end

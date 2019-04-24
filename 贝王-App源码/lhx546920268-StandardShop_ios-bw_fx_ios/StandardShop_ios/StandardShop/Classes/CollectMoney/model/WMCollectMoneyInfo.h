//
//  WMCollectMoneyInfo.h
//  StandardFenXiao
//
//  Created by 罗海雄 on 16/3/8.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

///收钱信息
@interface WMCollectMoneyInfo : NSObject

/**收钱名称
 */
@property(nonatomic,copy) NSString *name;

///收款金额
@property(nonatomic,copy) NSString *amount;

/**收钱链接
 */
@property(nonatomic,copy) NSString *shareURL;

///收钱二维码链接
@property(nonatomic,copy) NSString *QRCodeURL;


@end

//
//  WMCustomerServiceInfo.h
//  StandardShop
//
//  Created by Hank on 16/9/13.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

///客户服务类型
typedef NS_ENUM(NSInteger,WMCustomerServiceType)
{
    ///在线客服
    WMCustomerServiceTypeOnLine,
    
    ///意见反馈
    WMCustomerServiceTypeFeedBack,
    
    ///客服电话
    WMCustomerServiceTypePhone,
};

//客户服务信息模型
@interface WMCustomerServiceInfo : NSObject
/**类型
 */
@property (assign,nonatomic) WMCustomerServiceType type;
/**图标
 */
@property (copy,nonatomic) NSString *imageName;
/**名称
 */
@property (copy,nonatomic) NSString *name;

/**初始化
 */
+ (NSArray *)returnCustomerServiceInfosArr;


@end

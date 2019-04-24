//
//  WMStoreToJoinInfo.h
//  SuYan
//
//  Created by 罗海雄 on 16/4/25.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMHomeAdInfo.h"

///门店加盟信息
@interface WMStoreToJoinInfo : NSObject

///顶部图片信息
@property(nonatomic,strong) WMHomeAdInfo *adInfo;

///底部信息
@property(nonatomic,copy) NSString *msg;

@end

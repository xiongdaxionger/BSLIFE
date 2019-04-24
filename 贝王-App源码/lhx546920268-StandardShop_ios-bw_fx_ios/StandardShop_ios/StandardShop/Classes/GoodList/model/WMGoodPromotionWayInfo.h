//
//  WMGoodPromotionWayInfo.h
//  StandardShop
//
//  Created by 罗海雄 on 16/6/3.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

///商品促销方式
@interface WMGoodPromotionWayInfo : NSObject

///id
@property(nonatomic,copy) NSString *Id;

///名称
@property(nonatomic,copy) NSString *name;

///是否选中
@property(nonatomic,assign) BOOL selected;

@end

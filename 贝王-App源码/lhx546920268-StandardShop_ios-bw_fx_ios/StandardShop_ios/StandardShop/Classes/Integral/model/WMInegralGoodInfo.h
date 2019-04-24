//
//  WMInegralGoodInfo.h
//  StandardShop
//
//  Created by 罗海雄 on 16/7/4.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodInfo.h"

///积分兑换商品信息
@interface WMInegralGoodInfo : WMGoodInfo

///兑换商品所需积分
@property(nonatomic,copy) NSString *integral;

///兑换商品所需积分富文本
@property(nonatomic,copy) NSAttributedString *integralAttributedString;

@end

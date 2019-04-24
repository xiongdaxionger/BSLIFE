//
//  WMBrandDetailInfo.h
//  StandardShop
//
//  Created by 罗海雄 on 16/6/28.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMBrandInfo.h"

///品牌详情
@interface WMBrandDetailInfo : WMBrandInfo

///简介是否已加载完
@property(nonatomic,assign) BOOL introIsFinishLoading;

///html 品牌简介
@property(nonatomic,copy) NSString *intro;

///简介高度
@property(nonatomic,assign) CGFloat introHeight;

@end

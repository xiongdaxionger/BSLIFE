//
//  WMImageInitialization.h
//  StandardFenXiao
//
//  Created by 罗海雄 on 16/2/19.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

///根据主题创建图片
@interface WMImageInitialization : NSObject

///未打钩图片
+ (UIImage*)untickIcon;

///打钩的选中图标
+ (UIImage*)tickingIcon;

@end

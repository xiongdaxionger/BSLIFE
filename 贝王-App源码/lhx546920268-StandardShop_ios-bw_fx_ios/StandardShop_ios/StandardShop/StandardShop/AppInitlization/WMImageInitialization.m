//
//  WMImageInitialization.m
//  StandardFenXiao
//
//  Created by 罗海雄 on 16/2/19.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "WMImageInitialization.h"

@implementation WMImageInitialization

///未打钩图片
+ (UIImage*)untickIcon
{
    return [UIImage imageNamed:@"shop_Car_UnSelect"];
}

///打钩的选中图标
+ (UIImage*)tickingIcon
{
    static dispatch_once_t once = 0;
    static UIImage *shareTickingIcon = nil;
    
    dispatch_once(&once, ^(void){
       
        CGSize size = CGSizeMake(21, 21);
        UIGraphicsBeginImageContextWithOptions(size, NO, 0);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextAddArc(context, size.width / 2.0, size.height / 2.0, size.width / 2.0, 0, M_PI * 2, NO);
        CGContextSetFillColorWithColor(context, WMRedColor.CGColor);
        CGContextFillPath(context);
        
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextSetLineWidth(context, 1.5);
        CGContextMoveToPoint(context, 3.0, size.height / 2.0);
        CGContextAddLineToPoint(context, size.width / 3.0, size.height / 4.0 * 3.0);
        CGContextAddLineToPoint(context, size.width / 4.0 * 3.0, size.height / 4.0);
        
        CGContextStrokePath(context);
        
        shareTickingIcon = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    });
    
    return shareTickingIcon;
}

@end

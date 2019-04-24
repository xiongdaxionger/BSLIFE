//
//  WMImageInfo.h
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/8.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

/**图片信息
 */
@interface WMImageInfo : NSObject<NSCopying>

///图片Id
@property(nonatomic,copy) NSString *imageId;

///图片路径
@property(nonatomic,copy) NSString *imageURL;

///图片本地路径，在dealloc 中会删除图片
@property(nonatomic,copy) NSString *locationImageURL;

///图片
@property(nonatomic,strong) UIImage *image;


///通过字典创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic;

@end

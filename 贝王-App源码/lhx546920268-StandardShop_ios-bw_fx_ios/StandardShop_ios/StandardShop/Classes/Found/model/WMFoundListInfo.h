//
//  WMFoundListInfo.h
//  WanShoes
//
//  Created by 罗海雄 on 16/3/22.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

///发现列表信息
@interface WMFoundListInfo : NSObject<NSCopying>

///信息Id
@property(nonatomic,copy) NSString *Id;

///标题名称
@property(nonatomic,copy) NSString *title;

///作者
@property(nonatomic,copy) NSString *author;

///简介
@property(nonatomic,copy) NSString *content;

///大图片
@property(nonatomic,copy) NSString *imageURL;

///小图片
@property(nonatomic,copy) NSString *smallImageURL;

///文字内容
@property(nonatomic,copy) NSString *foundHtml;

///是否已点赞
@property(nonatomic,assign) BOOL isPraised;

///点赞数量
@property(nonatomic,assign) int praisedCount;

///评论数量
@property(nonatomic,assign) int commentCount;

///时间
@property(nonatomic,copy) NSString *time;

///所属栏目名称
@property(nonatomic,copy) NSString *pName;

///所属栏目名称宽度
@property(nonatomic,assign) CGFloat pNameWidth;

///链接
@property(nonatomic,copy) NSString *URL;

///从字典创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic;

@end

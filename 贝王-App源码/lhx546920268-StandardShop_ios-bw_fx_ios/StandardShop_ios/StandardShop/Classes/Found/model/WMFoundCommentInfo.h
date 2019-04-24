//
//  WMFoundCommentInfo.h
//  WanShoes
//
//  Created by 罗海雄 on 16/3/22.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "WMUserInfo.h"

///发现评论内容
@interface WMFoundCommentInfo : NSObject

///评论内容
@property(nonatomic,copy) NSString *content;

///评论内容高度 default is '0'
@property(nonatomic,assign) CGFloat contentHeight;

///评论时间
@property(nonatomic,copy) NSString *time;

///评论人
@property(nonatomic,strong) WMUserInfo *userInfo;

///从字典创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic;

@end

//
//  WMGoodCommentInfo.h
//  StandardShop
//
//  Created by 罗海雄 on 16/6/2.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMUserInfo.h"

///显示的部分回复最大数量
#define WMGoodCommentInfoPartialReplayMaxCount 2

///评论内容字体
#define WMGoodCommentContentFont [UIFont fontWithName:MainFontName size:15.0]

///商品评价信息
@interface WMGoodCommentInfo : NSObject

///评论id
@property(nonatomic,copy) NSString *Id;

///评论人信息
@property(nonatomic,strong) WMUserInfo *userInfo;

///评论时间
@property(nonatomic,copy) NSString *time;

///评论内容
@property(nonatomic,copy) NSString *content;

///评分
@property(nonatomic,assign) int score;

///评论内容高度
@property(nonatomic,assign) CGFloat contentHeight;

///评论图片 数组元素是图片路径 NSString
@property(nonatomic,strong) NSArray *images;

///第一张图片大小
@property(nonatomic,assign) CGSize firstImageSize;

///图片总高度
@property(nonatomic,assign) CGFloat imageHeight;

///评论回复，数组元素是 WMGoodCommentInfo
@property(nonatomic,strong) NSArray *replyInfos;

///回复的内容
@property(nonatomic,copy) NSAttributedString *replyAttributedString;

///部分回复的内容，未展开时只显示前两条
@property(nonatomic,copy) NSAttributedString *partialReplyAttributedString;

///回复的内容高度
@property(nonatomic,assign) CGFloat replyHeight;

///部分回复的内容高度
@property(nonatomic,assign) CGFloat partialReplyHeight;

///是否是管理员回复
@property(nonatomic,assign) BOOL isAdminReply;

///是否展开
@property(nonatomic,assign) BOOL expand;

///通过字典创建
+ (WMGoodCommentInfo*)infoFromDictionary:(NSDictionary*) dic;

@end

//
//  WMGoodCommentInfo.m
//  StandardShop
//
//  Created by 罗海雄 on 16/6/2.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodCommentInfo.h"

@interface WMGoodCommentInfo ()

@end

@implementation WMGoodCommentInfo

///通过字典创建
+ (WMGoodCommentInfo*)infoFromDictionary:(NSDictionary*) dic
{
    WMGoodCommentInfo *info = [[WMGoodCommentInfo alloc] init];
    info.Id = [dic sea_stringForKey:@"comment_id"];
    info.content = [dic sea_stringForKey:@"comment"];
    CGFloat width = _width_ - 15.0 * 3 - 45.0;
    UIFont *font = WMGoodCommentContentFont;
    info.contentHeight = [info.content stringSizeWithFont:font contraintWith:width].height + 1.0;
    info.score = [[dic numberForKey:@"goods_point"] intValue];
    info.isAdminReply = [info.Id isEqualToString:@"0"];

    NSString *time = [dic sea_stringForKey:@"time"];
    info.time = [NSDate previousDateWithTimeInterval:[time doubleValue]];

    info.userInfo = [[WMUserInfo alloc] init];
    info.userInfo.userId = [dic sea_stringForKey:@"author_id"];
    info.userInfo.name = [dic sea_stringForKey:@"author"];
    info.userInfo.level = [dic sea_stringForKey:@"member_lv_name"];
    info.userInfo.headImageURL = [dic sea_stringForKey:@"member_avatar"];
    
    info.images = [dic arrayForKey:@"images"];

    NSArray *items = [dic arrayForKey:@"items"];
    if(items.count > 0)
    {
        NSMutableArray *infos = [NSMutableArray arrayWithCapacity:items.count];
        for(NSDictionary *dict in items)
        {
            [infos addObject:[WMGoodCommentInfo infoFromDictionary:dict]];
        }

        info.replyInfos = infos;
    }

    return info;
}

- (void)setReplyInfos:(NSArray *)replyInfos
{
    if(_replyInfos != replyInfos)
    {
        _replyInfos = replyInfos;
        self.replyAttributedString = nil;
        self.partialReplyAttributedString = nil;
    }
}

- (NSAttributedString*)replyAttributedString
{
    if(!_replyAttributedString)
    {
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];
        for(NSInteger i = 0;i < self.replyInfos.count;i ++)
        {
            WMGoodCommentInfo *info = [self.replyInfos objectAtIndex:i];
    
            [text appendAttributedString:[self attributedStringFromInfo:info isLast:i == self.replyInfos.count - 1]];
        }

        [self addDefaultAttributesWithText:text];

        _replyAttributedString = text;
    }

    return _replyAttributedString;
}

- (NSAttributedString*)partialReplyAttributedString
{
    if(!_partialReplyAttributedString)
    {
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];

        int count = MIN(WMGoodCommentInfoPartialReplayMaxCount, self.replyInfos.count);
        for(NSInteger i = 0;i < count;i ++)
        {
            WMGoodCommentInfo *info = [self.replyInfos objectAtIndex:i];
            [text appendAttributedString:[self attributedStringFromInfo:info isLast:i == count - 1]];
        }

        [self addDefaultAttributesWithText:text];

        _partialReplyAttributedString = text;
    }

    return _partialReplyAttributedString;
}

///添加默认属性
- (void)addDefaultAttributesWithText:(NSMutableAttributedString*) text
{
    [text addAttribute:NSFontAttributeName value:WMGoodCommentContentFont range:NSMakeRange(0, text.length)];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByCharWrapping;
    style.paragraphSpacing = 5.0;
    [text addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
}

///通过评论信息获取评论内容组合 isLast 是否是最后一个
- (NSAttributedString*)attributedStringFromInfo:(WMGoodCommentInfo*) info isLast:(BOOL) isLast
{
    NSString *name = info.userInfo.displayName;
    NSString *content = info.content;

    if(!name)
        name = @"";
    if(!content)
        content = @"";
    name = [NSString stringWithFormat:@"%@：", name];
    content = isLast ? [NSString stringWithFormat:@"%@", content] : [NSString stringWithFormat:@"%@\n", content];

    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", name, content]];
    [text addAttribute:NSForegroundColorAttributeName value:info.isAdminReply ? WMRedColor : [UIColor blackColor] range:NSMakeRange(0, name.length)];

    return text;
}

@end

//
//  WMGoodTagInfo.h
//  StandardShop
//
//  Created by 罗海雄 on 16/6/3.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

///标签位置
typedef NS_ENUM(NSInteger, WMGoodTagPosition)
{
    ///左上角
    WMGoodTagPositionLeftTop,

    ///右上角
    WMGoodTagPositionRightTop,

    ///左下角
    WMGoodTagPositionLeftBottom,

    ///右下角
    WMGoodTagPositionRightBottom,
};

///标签类型
typedef NS_ENUM(NSInteger, WMGoodTagType)
{
    ///文本标签
    WMGoodTagTypeText = 0,

    ///图片标签
    WMGoodTagTypeImage,
};

///商品标签信息
@interface WMGoodTagInfo : NSObject

///标签位置
@property(nonatomic,assign) WMGoodTagPosition position;

///标签内容
@property(nonatomic,copy) NSString *text;

///标签背景颜色
@property(nonatomic,strong) UIColor *backgroundColor;

///字体颜色
@property(nonatomic,strong) UIColor *textColor;

///标签图片 和 文字能共存，优先使用图片
@property(nonatomic,copy) NSString *imageURL;

///标签类型
@property(nonatomic,assign) WMGoodTagType type;

/**通过字典创建
 *@param dic 包含标签信息的字典
 *@return 数组元素是 WMGoodTagInfo
 */
+ (NSArray*)infosFromDictionary:(NSDictionary*) dic;

@end

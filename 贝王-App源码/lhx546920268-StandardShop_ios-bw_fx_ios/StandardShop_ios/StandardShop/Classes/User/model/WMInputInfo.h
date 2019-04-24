//
//  WMInputInfo.h
//  StandardShop
//
//  Created by 罗海雄 on 16/6/21.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WMInputCell;

/**注册信息类型
 */
typedef NS_ENUM(NSInteger, WMInputType)
{

    ///其他
    WMInputTypeOther = -1,

    ///图形验证码
    WMInputTypeImageCode,

    //账号
    WMInputTypeAccount,

    ///短信验证码
    WMInputTypeCode,

    ///密码
    WMInputTypePassword,

    ///昵称
    WMInputTypeName,

    ///性别
    WMInputTypeSex,
};

///输入内容类型
typedef NS_ENUM(NSInteger, WMInputContentType)
{
    ///文本输入无限制
    WMInputContentTypeTextUnlimited,

    ///只能输入数字
    WMInputContentTypeNumber,

    ///只能输入字母
    WMInputContentTypeLetter,

    ///只能输入字母和数字
    WMInputContentTypeLetterAndNumber,

    ///单选
    WMInputContentTypeRadio,

    ///多选
    WMInputContentTypeMultipleSelection,

    ///地区
    WMInputContentTypeArea,

    ///时间
    WMInputContentTypeDate,
};

///注册信息
@interface WMInputInfo : NSObject

/**用来编辑信息的字段
 */
@property(nonatomic,copy) NSString *key;

/**标题
 */
@property(nonatomic,copy) NSString *title;

/**是否是必填
 */
@property(nonatomic,assign) BOOL required;

/**内容
 */
@property(nonatomic,readonly) NSString *content;

/**内容类型 只有 type = WMInputTypeOther 时有效
 */
@property(nonatomic,assign) WMInputContentType contentType;

/**选项 数组元素是 NSString
 */
@property(nonatomic,strong) NSArray *options;

/**选中的选项 数组元素是 NSString
 */
@property(nonatomic,strong) NSMutableArray *selectedOptions;

/**选项组合
 */
@property(nonatomic,copy) NSString *selectedOptionsString;

/**需要上传的地址信息
 */
@property(nonatomic,copy) NSString *area;

/**图形验证码链接
 */
@property(nonatomic,copy) NSString *codeURL;

/**类型
 */
@property(nonatomic,assign) WMInputType type;

/**标题宽度
 */
@property(nonatomic,assign) CGFloat titleWidth;

/**cell类型
 */
@property(nonatomic,strong) WMInputCell *cell;

/**通过类型创建
 */
+ (instancetype)infoWithType:(WMInputType) type;

/**获取注册信息列表
 *@param 包含注册信息的字典
 *@return 数组元素是 WMInputInfo
 */
+ (NSArray*)inputInfosFromDictionary:(NSDictionary*) dic;

@end

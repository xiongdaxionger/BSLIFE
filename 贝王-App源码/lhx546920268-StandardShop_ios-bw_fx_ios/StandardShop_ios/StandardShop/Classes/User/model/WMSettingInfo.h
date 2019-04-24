//
//  WMSettingInfo.h
//  WestMailDutyFee
//
//  Created by 罗海雄 on 15/8/26.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

//边距
#define WMSettingCellMargin 10.0

//视图间隔
#define WMSettingCellControlInterval 5.0

//高度
#define WMSettingCellHeight 45.0

//字体
#define WMSettingCellFont [UIFont fontWithName:MainFontName size:15.0]

//标题宽度
#define WMSettingCellTitleWidth 70.0

//箭头宽度
#define WMSettingCellArrowWidth 10.0

//头像cell高度
#define WMSettingHeadImageCellHeight 40.0

/**设置信息类型
 */
typedef NS_ENUM(NSInteger, WMSettingType)
{

    ///其他
    WMSettingTypeOther = -1,

    ///头像
    WMSettingTypeHeadImage = 0,
    
    ///账号
    WMSettingTypeAccount,
    
    ///手机号
    WMSettingTypePhoneNumber,
    
    ///邮箱
    WMSettingTypeEmail,
    
    ///昵称
    WMSettingTypeName,
    
    ///性别
    WMSettingTypeSex,
};

///输入内容类型
typedef NS_ENUM(NSInteger, WMSettingContentType)
{
    ///文本输入无限制
    WMSettingContentTypeTextUnlimited,

    ///只能输入数字
    WMSettingContentTypeNumber,

    ///只能输入字母
    WMSettingContentTypeLetter,

    ///只能输入字母和数字
    WMSettingContentTypeLetterAndNumber,

    ///单选
    WMSettingContentTypeRadio,

    ///多选
    WMSettingContentTypeMultipleSelection,

    ///地区
    WMSettingContentTypeArea,

    ///时间
    WMSettingContentTypeDate,

    ///图片
    WMSettingContentTypeImage,
};

/**设置信息cell类型
 */
typedef NS_ENUM(NSInteger, WMSettingCellType)
{
    WMSettingCellTypeTitleContent = 0, ///标题和内容
    WMSettingCellTypeHeadImage = 1, ///头像
    WMSettingCellTypeSwitch = 2, ///开关
};

/**设置列表信息
 */
@interface WMSettingInfo : NSObject

/**用来编辑信息的字段
 */
@property(nonatomic,copy) NSString *key;

/**标题
 */
@property(nonatomic,copy) NSString *title;

/**内容
 */
@property(nonatomic,copy) NSString *content;

/**类型
 */
@property(nonatomic,assign) WMSettingType type;

/**获取内容高度
 */
@property(nonatomic,assign) CGFloat contentHeight;

/**标题宽度
 */
@property(nonatomic,assign) CGFloat titleWidth;

/**内容类型 只有 type = WMInputTypeOther 时有效
 */
@property(nonatomic,assign) WMSettingContentType contentType;

/**选项 数组元素是 NSString
 */
@property(nonatomic,strong) NSArray *options;

/**选中的选项 数组元素是 NSString
 */
@property(nonatomic,strong) NSMutableArray *selectedOptions;

/**选项组合
 */
@property(nonatomic,readonly) NSString *selectedOptionsString;

/**cell类型
 */
@property(nonatomic,assign) WMSettingCellType cellType;

/**是否可以选择
 */
@property(nonatomic,assign) BOOL selectable;

/**获取设置的列表信息
 *@return 数组元素是NSArray ,数组元素是 WMSettingInfo
 */
+ (NSArray*)settingInfos;

/**获取我的资料信息列表
 *@param 包含我的资料信息的字典
 *@return 数组元素是 WMSettingInfo
 */
+ (NSArray*)myInfosFromDictionary:(NSDictionary*) dic;

@end

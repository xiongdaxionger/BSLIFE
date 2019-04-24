//
//  WMSettingInfo.m
//  WestMailDutyFee
//
//  Created by 罗海雄 on 15/8/26.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMSettingInfo.h"
#import "WMUserInfo.h"
#import "WMShippingAddressInfo.h"
#import "WMShippingAddressOperation.h"

@implementation WMSettingInfo

- (id)init
{
    self = [super init];
    if(self)
    {
        self.contentHeight = WMSettingCellFont.lineHeight;
        self.cellType = WMSettingCellTypeTitleContent;
        self.selectable = YES;
    }
    
    return self;
}

- (void)setTitle:(NSString *)title
{
    if(![_title isEqualToString:title])
    {
        _title = title;
        self.titleWidth = [_title stringSizeWithFont:WMSettingCellFont contraintWith:_width_ - WMSettingCellMargin * 2 - WMSettingCellControlInterval - WMSettingCellArrowWidth].width;
    }
}

- (void)setContent:(NSString *)content
{
    if(![_content isEqualToString:content])
    {
        _content = content;
        
        UIFont *font = WMSettingCellFont;
        CGFloat height = [_content stringSizeWithFont:font contraintWith:_width_ - WMSettingCellMargin * 2 - WMSettingCellArrowWidth - WMSettingCellControlInterval * 2 - _titleWidth].height;
        
        self.contentHeight = MAX(height, font.lineHeight);
    }
}

- (NSString*)selectedOptionsString
{
    NSMutableString *string = [NSMutableString string];
    for(NSString *str in self.selectedOptions)
    {
        [string appendFormat:@"%@，", str];
    }

    [string removeLastCharacter];
    return string;
}

/**获取设置的列表信息
 *@return 数组元素是NSArray ,数组元素是 WMSettingInfo
 */
+ (NSArray*)settingInfos
{
    NSMutableArray *infos = [NSMutableArray arrayWithCapacity:1];
    
    return infos;
}

/**获取我的资料信息列表
 *@param 包含我的资料信息的字典
 *@return 数组元素是 WMSettingInfo
 */
+ (NSArray*)myInfosFromDictionary:(NSDictionary*) dic
{
    NSDictionary *dataDic = [dic dictionaryForKey:WMHttpData];
    
    [WMUserInfo sharedUserInfo].personCenterInfo.openFenxiao = [[dataDic numberForKey:@"commision_status"] boolValue];
    [WMUserInfo sharedUserInfo].namePrefix = [dataDic sea_stringForKey:@"shopname"];
    
    NSArray *attrs = [dataDic arrayForKey:@"attr"];
    NSMutableArray *infos = [NSMutableArray arrayWithCapacity:attrs.count];

    for(NSDictionary *dict in attrs)
    {
        NSString *key = [dict sea_stringForKey:@"attr_column"];

        WMSettingType type = [WMSettingInfo typeForKey:key];

        WMSettingInfo *info = [[WMSettingInfo alloc] init];
        info.title = [dict sea_stringForKey:@"attr_name"];
        info.content = [dict sea_stringForKey:@"attr_value"];
        info.selectable = [[dict sea_stringForKey:@"attr_edit"] boolValue];
        info.type = type;
        info.key = key;

        [infos addObject:info];

        switch (type)
        {
            case WMSettingTypeHeadImage :
            {
                if([NSString isEmpty:info.content])
                {
                    info.content = [dataDic sea_stringForKey:@"addUploadImg"];
                }
                
                info.contentHeight = WMSettingHeadImageCellHeight;
                info.cellType = WMSettingCellTypeHeadImage;
               
            }
                break;
            case WMSettingTypeSex :
            {
                info.content = [WMUserInfo sexStringForKey:info.content];
            }
                break;
            case WMSettingTypeOther :
            {
                NSString *inputType = [dict sea_stringForKey:@"attr_type"];
                if([inputType isEqualToString:@"text"])
                {
                    ///文本输入框
                    inputType = [dict sea_stringForKey:@"attr_valtype"];
                }

                info.contentType = [self contentTypeForKey:inputType];


                switch (info.contentType)
                {
                    case WMSettingContentTypeArea :
                    {
                        if(![NSString isEmpty:info.content])
                        {
                            info.content = [WMShippingAddressOperation separateAreaParamFromMainland:info.content];
                        }
                    }
                        break;
                    case WMSettingContentTypeMultipleSelection :
                    {
                        info.key = [NSString stringWithFormat:@"box:%@", info.key];
                        ///多选
                        NSArray *selectedOptions = [dict arrayForKey:@"attr_value"];
                        if(selectedOptions.count > 0)
                        {
                            info.selectedOptions = [NSMutableArray arrayWithArray:selectedOptions];
                            info.content = info.selectedOptionsString;
                        }
                        else
                        {
                            info.content = nil;
                        }
                        info.options = [dict arrayForKey:@"attr_option"];
                    }
                        break;
                    case WMSettingContentTypeRadio :
                    {
                        info.options = [dict arrayForKey:@"attr_option"];
                        if(![NSString isEmpty:info.content])
                        {
                            info.selectedOptions = [NSMutableArray arrayWithObject:info.content];
                        }
                    }
                        break;
                    case WMSettingContentTypeImage :
                    {
                        info.contentHeight = WMSettingHeadImageCellHeight;
                        info.cellType = WMSettingCellTypeHeadImage;
                        
                    }
                        break;
                    default:
                        break;
                }
            }
                break;

            default:
                break;
                
        }
    }
    
    ///账号信息
    NSInteger index = 0;
    for(NSInteger i = 0;i < infos.count;i ++)
    {
        WMSettingInfo *info = [infos objectAtIndex:i];
        if(info.type == WMSettingTypeHeadImage)
        {
            index = i + 1;
            break;
        }
    }
    
    ///账号
    NSDictionary *memDic = [dataDic dictionaryForKey:@"mem"];
    NSString *value = [memDic sea_stringForKey:@"local"];
    WMSettingInfo *info = [[WMSettingInfo alloc] init];
    info.type = WMSettingTypeAccount;
    info.title = @"用户名";
    info.selectable = [NSString isEmpty:value];
    info.content = value;
    [infos insertObject:info atIndex:index];
    index ++;

    
    ///手机号
    value = [memDic sea_stringForKey:@"mobile"];
    info = [[WMSettingInfo alloc] init];
    info.type = WMSettingTypePhoneNumber;
    info.title = @"手机号";
    info.selectable = [NSString isEmpty:value];
    info.content = value;
    [infos insertObject:info atIndex:index];
    index ++;
    
    ///邮箱
    value = [memDic sea_stringForKey:@"email"];

    info = [[WMSettingInfo alloc] init];
    info.type = WMSettingTypeEmail;
    info.title = @"邮箱";
    info.selectable = NO;
    info.content = value;
    [infos insertObject:info atIndex:index];
    index ++;
    
    return infos;
}

/**通过后台返回的字段获取对应的类型
 *@param key 字段
 *@return 字段对应的类型
 */
+ (WMSettingType)typeForKey:(NSString*) key
{
    if([key isEqualToString:@"contact[name]"])
    {
        return WMSettingTypeName;
    }
    else if ([key isEqualToString:@"profile[gender]"])
    {
        return WMSettingTypeSex;
    }
    else if ([key isEqualToString:@"contact[avatar]"])
    {
        return WMSettingTypeHeadImage;
    }

    return WMSettingTypeOther;
}

/**通过后台返回的字段获取对应的类型
 *@param key 字段
 *@return 字段对应的类型
 */
+ (WMSettingContentType)contentTypeForKey:(NSString*) key
{
    if([key isEqualToString:@"number"])
    {
        return WMSettingContentTypeNumber;
    }
    else if ([key isEqualToString:@"alpha"])
    {
        return WMSettingContentTypeLetter;
    }
    else if ([key isEqualToString:@"alphaint"])
    {
        return WMSettingContentTypeLetterAndNumber;
    }
    else if ([key isEqualToString:@"date"])
    {
        return WMSettingContentTypeDate;
    }
    else if ([key isEqualToString:@"region"])
    {
        return WMSettingContentTypeArea;
    }
    else if ([key isEqualToString:@"checkbox"])
    {
        return WMSettingContentTypeMultipleSelection;
    }
    else if ([key isEqualToString:@"select"])
    {
        return WMSettingContentTypeRadio;
    }
    else if ([key isEqualToString:@"image"])
    {
        return WMSettingContentTypeImage;
    }

    return WMSettingContentTypeTextUnlimited;
}

@end

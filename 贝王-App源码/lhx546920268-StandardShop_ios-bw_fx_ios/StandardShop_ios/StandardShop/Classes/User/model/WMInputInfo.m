//
//  WMInputInfo.m
//  StandardShop
//
//  Created by 罗海雄 on 16/6/21.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMInputInfo.h"
#import "WMInputCell.h"
#import "WMImageVerificationCodeView.h"

@implementation WMInputInfo

- (void)setTitle:(NSString *)title
{
    if(![_title isEqualToString:title])
    {
        _title = title;
        self.titleWidth = [_title stringSizeWithFont:WMInputCellFont contraintWith:_width_ - WMInputCellMargin * 2 - WMInputCellInterval].width + 10.0;
    }
}

///标题富文本
- (NSAttributedString*)attributedTitle
{
    if(_title)
    {
//        if(self.required)
//        {
//            NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@*", _title]];
//            [title addAttribute:NSForegroundColorAttributeName value:WMRedColor range:NSMakeRange(title.length - 1, 1)];
//            
//            return title;
//        }
//        else
//        {
            return [[NSAttributedString alloc] initWithString:_title];
       // }
    }
    
    return nil;
}

- (NSString*)content
{
    if([self.cell isKindOfClass:[WMInputTextFieldCell class]])
    {
        WMInputTextFieldCell *cell = (WMInputTextFieldCell*)self.cell;
        return cell.textField.text;
    }
    else if ([self.cell isKindOfClass:[WMInputSelectedCell class]])
    {
        if(self.contentType == WMInputContentTypeArea)
        {
            return self.area;
        }
        else
        {
            WMInputSelectedCell *cell = (WMInputSelectedCell*)self.cell;
            return cell.content;
        }
    }
    else if ([self.cell isKindOfClass:[WMInputSexCell class]])
    {
        WMInputSexCell *cell = (WMInputSexCell*)self.cell;
        return cell.boy_btn.selected ? WMUserInfoBoy : WMUserInfoGirl;
    }
    else if ([self.cell isKindOfClass:[WMInputImageCodeCell class]])
    {
        WMInputImageCodeCell *cell = (WMInputImageCodeCell*)self.cell;
        return cell.codeView.textField.text;
    }

    return nil;
}

- (NSString*)selectedOptionsString
{
    if(!_selectedOptionsString && self.selectedOptions.count > 0)
    {
        NSMutableString *string = [NSMutableString string];
        for(NSString *str in self.selectedOptions)
        {
            [string appendFormat:@"%@，", str];
        }

        [string removeLastCharacter];
        _selectedOptionsString = [string copy];
    }

    return _selectedOptionsString;
}

- (WMInputCell*)cell
{
    if(!_cell)
    {
        switch (self.type)
        {
            case WMInputTypeAccount :
            case WMInputTypePassword :
            case WMInputTypeName :
            {
                WMInputTextFieldCell *cell = [[WMInputTextFieldCell alloc] init];
                cell.titleLabel.attributedText = [self attributedTitle];
                cell.titleWidth = self.titleWidth;

                switch (self.type)
                {
                    case WMInputTypeAccount :
                    {
                        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                    }
                        break;
                    case WMInputTypePassword :
                    {
                        cell.textField.secureTextEntry = YES;
                    }
                        break;
                    default:
                        break;
                }
                
                if(!self.required)
                {
                    cell.textField.placeholder = @"选填";
                }

                _cell = cell;
            }
                break;
            case WMInputTypeSex :
            {
                WMInputSexCell *cell = [[WMInputSexCell alloc] init];
                cell.titleLabel.attributedText = [self attributedTitle];
                cell.titleWidth = self.titleWidth;
                _cell = cell;
            }
                break;
            case WMInputTypeCode :
            {
                WMInputCountDownTextFieldCell *cell = [[WMInputCountDownTextFieldCell alloc] init];
                cell.titleLabel.attributedText = [self attributedTitle];
                cell.titleWidth = self.titleWidth;
                cell.textField.keyboardType = UIKeyboardTypeNumberPad;

                _cell = cell;
            }
                break;
            case WMInputTypeImageCode :
            {
                WMInputImageCodeCell *cell = [[WMInputImageCodeCell alloc] init];
                cell.titleLabel.attributedText = [self attributedTitle];
                cell.titleWidth = self.titleWidth;
                cell.codeView.codeURL = self.codeURL;

                _cell = cell;
            }
                break;
            case WMInputTypeOther :
            {
                switch (self.contentType)
                {
                    case WMInputContentTypeTextUnlimited :
                    case WMInputContentTypeLetter :
                    case WMInputContentTypeNumber :
                    case WMInputContentTypeLetterAndNumber :
                    {
                        WMInputTextFieldCell *cell = [[WMInputTextFieldCell alloc] init];
                        cell.titleLabel.attributedText = [self attributedTitle];
                        cell.titleWidth = self.titleWidth;

                        switch (self.contentType)
                        {
                            case WMInputContentTypeNumber :
                            {
                                cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                            }
                                break;
                            default:
                                break;
                        }
                        
                        if(!self.required)
                        {
                            cell.textField.placeholder = @"选填";
                        }
                        
                        _cell = cell;
                    }
                        break;
                    case WMInputContentTypeArea :
                    case WMInputContentTypeDate :
                    case WMInputContentTypeRadio :
                    case WMInputContentTypeMultipleSelection :
                    {
                        WMInputSelectedCell *cell = [[WMInputSelectedCell alloc] init];
                        cell.titleLabel.attributedText = [self attributedTitle];
                        cell.titleWidth = self.titleWidth;
                        
                        if(!self.required)
                        {
                            cell.placeHolder = @"选填";
                        }

                        _cell = cell;
                    }
                        break;
                }
            }
                break;
        }
    }

    return _cell;
}

/**通过类型创建
 */
+ (instancetype)infoWithType:(WMInputType) type
{
    WMInputInfo *info = [[WMInputInfo alloc] init];
    info.type = type;

    switch (type)
    {
        case WMInputTypeImageCode :
        {
            info.title = @"图形验证码";
        }
            break;
        case WMInputTypeCode :
        {
            info.title = @"验证码";
            info.key = @"vcode";
            info.required = YES;
        }
            break;
        case WMInputTypeAccount :
        {
            info.title = @"手机号";
            info.key = @"pam_account[login_name]";
            info.required = YES;
        }
            break;
        case WMInputTypePassword :
        {
            info.title = @"密码";
            info.key = @"pam_account[login_password]";
            info.required = YES;
        }
            break;
        default:
            break;
    }

    return info;
}

/**通过后台返回的字段获取对应的类型
 *@param key 字段
 *@return 字段对应的类型
 */
+ (WMInputType)typeForKey:(NSString*) key
{
    if([key isEqualToString:@"contact[name]"])
    {
        return WMInputTypeName;
    }
    else if ([key isEqualToString:@"profile[gender]"])
    {
        return WMInputTypeSex;
    }

    return WMInputTypeOther;
}

/**通过后台返回的字段获取对应的类型
 *@param key 字段
 *@return 字段对应的类型
 */
+ (WMInputContentType)contentTypeForKey:(NSString*) key
{
    if([key isEqualToString:@"number"])
    {
        return WMInputContentTypeNumber;
    }
    else if ([key isEqualToString:@"alpha"])
    {
        return WMInputContentTypeLetter;
    }
    else if ([key isEqualToString:@"alphaint"])
    {
        return WMInputContentTypeLetterAndNumber;
    }
    else if ([key isEqualToString:@"date"])
    {
        return WMInputContentTypeDate;
    }
    else if ([key isEqualToString:@"region"])
    {
        return WMInputContentTypeArea;
    }
    else if ([key isEqualToString:@"checkbox"])
    {
        return WMInputContentTypeMultipleSelection;
    }
    else if ([key isEqualToString:@"select"])
    {
        return WMInputContentTypeRadio;
    }

    return WMInputContentTypeTextUnlimited;
}

/**获取注册信息列表
 *@param 包含注册信息的字典
 *@return 数组元素是 WMInputInfo
 */
+ (NSArray*)inputInfosFromDictionary:(NSDictionary*) dic
{
    NSArray *array = [dic arrayForKey:@"attr"];
    NSMutableArray *infos = [NSMutableArray arrayWithCapacity:array.count + 3];

    ///注册必填的信息
    [infos addObject:[WMInputInfo infoWithType:WMInputTypeAccount]];

    ///图形验证码
    if([[dic numberForKey:@"valideCode"] boolValue])
    {
        NSString *codeURL = [dic sea_stringForKey:@"code_url"];
        WMInputInfo *info = [WMInputInfo infoWithType:WMInputTypeImageCode];
        info.codeURL = codeURL;
        WMInputImageCodeCell *cell = (WMInputImageCodeCell*)info.cell;
        cell.codeView.textField.leftView = nil;
        cell.codeView.textField.placeholder = nil;
        [infos addObject:info];
    }

    [infos addObject:[WMInputInfo infoWithType:WMInputTypeCode]];
    [infos addObject:[WMInputInfo infoWithType:WMInputTypePassword]];

    ///可选的信息
    for(NSDictionary *dict in array)
    {
        NSString *key = [dict sea_stringForKey:@"attr_column"];

        WMInputType type = [WMInputInfo typeForKey:key];
        WMInputInfo *info = [WMInputInfo infoWithType:type];
        info.title = [dict sea_stringForKey:@"attr_name"];
        info.required = [[dict sea_stringForKey:@"attr_required"] boolValue];
        info.type = type;
        info.key = key;
        [infos addObject:info];

        if(type == WMInputTypeOther)
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
                case WMInputContentTypeMultipleSelection :
                {
                    info.key = [NSString stringWithFormat:@"box:%@", info.key];
                }
                case WMInputContentTypeRadio :
                {
                    info.options = [dict arrayForKey:@"attr_option"];
                }
                    break;
                    
                default:
                    break;
            }
        }
    }

    return infos;
}

@end

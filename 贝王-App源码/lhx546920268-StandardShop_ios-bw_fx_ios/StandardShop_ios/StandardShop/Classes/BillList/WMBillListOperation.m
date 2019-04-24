//
//  WMBillListOperation.m
//  StandardFenXiao
//
//  Created by mac on 15/12/4.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import "WMBillListOperation.h"

#import "SeaDropDownMenu.h"
#import "WMBillListViewController.h"

#import "WMBillInfoModel.h"
#import "WMUserOperation.h"

@implementation WMBillListOperation
+ (SeaDropDownMenu *)returnDropDownViewWith:(WMBillListViewController *)controller{
    
    SeaDropDownMenuItem *listOne = [[SeaDropDownMenuItem alloc] init];
    
    listOne.title = @"收入";
    
    SeaDropDownMenuItem *listTwo = [[SeaDropDownMenuItem alloc] init];
        
    listTwo.title = @"支出";
    
    SeaDropDownMenu *dropDownMenu = [[SeaDropDownMenu alloc] initWithFrame:CGRectMake(0, 0, _width_, SeaDropDownMenuHeight) items:@[listOne,listTwo]];
    
    dropDownMenu.delegate = controller;
    
    dropDownMenu.listHighLightColor = [UIColor blackColor];
    
    dropDownMenu.selectedIndex = 0;
    
    dropDownMenu.buttonHighlightTitleColor = [UIColor redColor];
    
    dropDownMenu.buttonNormalTitleColor = [UIColor grayColor];
    
    dropDownMenu.keepHighlightWhenDismissList = YES;
    
    dropDownMenu.buttonTitleFont = [UIFont fontWithName:MainFontName size:14.0];
    
    dropDownMenu.listTitleFont = [UIFont fontWithName:MainFontName size:14.0];
    
    return dropDownMenu;
}

/**返回选中的二级账单状态
 */
+ (NSString *)returnSecondSelectStatusWithIndex:(NSInteger)select firstIndex:(NSInteger)firstIndex{
    
    if (firstIndex == 0) {
        
        switch (select) {
            case 0:
                return @"in";
                break;
            case 1:
                return @"fin";
                break;
            case 2:
                return @"act";
                break;
            case 3:
                return @"order_in";
                break;
            case 4:
                return @"cz";
                break;
            case 5:
                return @"collect";
                break;
            default:
                break;
        }
    }
    else{
        
        switch (select) {
            case 0:
                return @"out";
                break;
            case 1:
                return @"tx";
                break;
            case 2:
                return @"purchase";
                break;
            default:
                break;
        }
    }
    
    return nil;
}

/**返回选中的二级账单标题
 */
+ (NSString *)returnSecondSelectTitleItem:(SeaDropDownMenuItem *)item{
    
    return item.title;
    
//    return [item.titleLists objectAtIndex:item.selectedIndex];
}

/**获取账单数据 参数
 @param 账单的状态 NSString
 @param 页码 NSInteger
 @param 每页数量 NSInteger
 */
+ (NSDictionary *)returnBillListParamWithStatus:(NSString *)payStatus pageNum:(NSInteger)page_num isCommisionOrder:(BOOL)isCommisionOrder{
    
    return @{WMHttpMethod:@"b2c.member.balance",@"type":payStatus,@"page":@(page_num),@"is_fx":isCommisionOrder ? @"true" : @"false"};
}
/**获取账单数据 结果
 *return 字典 key为info时数组 元素是WMBillInfoModel key为total时为总数
 */
+ (NSDictionary *)returnBillListInfosWithData:(NSData *)data{
    
    NSDictionary *dict = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if ([WMUserOperation resultFromDictionary:dict]) {
        
        NSDictionary *dataDict = [dict dictionaryForKey:WMHttpData];
        
        long long count = [WMUserOperation totalSizeFromDictionary:dataDict];
        
        NSArray *infos = [WMBillInfoModel billListInfoArrWith:[dataDict arrayForKey:@"advlogs"]];
        
        return @{@"info":infos,@"total":@(count)};
    }
    else{
        
        [WMUserOperation errorMsgFromDictionary:dict alertErrorMsg:NO];
    }
    
    return nil;
}
@end

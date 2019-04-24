//
//  WMAreaInfo.h
//  WuMei
//
//  Created by 罗海雄 on 15/7/22.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import <Foundation/Foundation.h>

/**地区信息
 */
@interface WMAreaInfo : NSObject<NSCopying>

/**id
 */
@property(nonatomic,assign) long long Id;

/**名称
 */
@property(nonatomic,copy) NSString *name;

/**所属子类信息 数组元素是 WMAreaInfo
 */
@property(nonatomic,strong) NSMutableArray *childAreaInfos;

/**通过字典创建
 *@param treeDic 包含地区结构的字典
 *@param infoDic 包含所有地区信息的字典
 *@param areaId 地区id
 *@return 如果存在，则返回对应的地区信息，否则返回nil
 */
+ (instancetype)infoFromTreeDic:(NSDictionary*) treeDic infoDic:(NSDictionary*) infoDic areaId:(NSString*) areaId;

@end

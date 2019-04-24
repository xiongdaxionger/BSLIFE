//
//  WMStoreListInfo.h
//  StandardShop
//
//  Created by Hank on 2018/6/11.
//  Copyright © 2018年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

///自提门店数据模型
@interface WMStoreListInfo : NSObject

///门店ID
@property (copy,nonatomic) NSString *branchID;

///门店名称
@property (copy,nonatomic) NSString *name;

///备注
@property (copy,nonatomic) NSString *memo;

///省份
@property (copy,nonatomic) NSString *province;

///城市
@property (copy,nonatomic) NSString *city;

///地区
@property (copy,nonatomic) NSString *area;

///详细地址
@property (copy,nonatomic) NSString *address;

///最终级区ID
@property (copy,nonatomic) NSString *areaValueID;

///距离
@property (copy,nonatomic) NSString *distance;

///负责人
@property (copy,nonatomic) NSString *uname;

///联系电话
@property (copy,nonatomic) NSString *mobile;

///纬度
@property (copy,nonatomic) NSString *latitude;

///经度
@property (copy,nonatomic) NSString *longitude;

///营业时间
@property (copy,nonatomic) NSString *openTime;

///门店logo
@property (copy,nonatomic) NSString *storeLogo;

///完整地址
@property (copy,nonatomic) NSString *completeAddress;

///解析数据
+ (NSArray<WMStoreListInfo *> *)parseInfosArrWithDictsArr:(NSArray *)dictsArr;

@end

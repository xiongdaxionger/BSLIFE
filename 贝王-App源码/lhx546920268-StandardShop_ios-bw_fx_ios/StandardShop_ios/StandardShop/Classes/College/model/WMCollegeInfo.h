//
//  WMCollege.h
//  WestMailDutyFee
//
//  Created by YUYE on 15/8/31.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

/**学院分类信息
 */
@interface WMCollegeCategoryInfo : NSObject

/**分类id
 */
@property(nonatomic, strong) NSString *Id;

/**分类名称
 */
@property(nonatomic, strong) NSString *name;

/**学院信息 数组元素是 WMCollegeInfo
 */
@property(nonatomic, strong) NSMutableArray *infos;

///页码
@property(nonatomic,assign) int curPage;

@end

@class WMCollegeDetailInfo;

/**学院信息
 */
@interface WMCollegeInfo : NSObject

///学院信息Id
@property(nonatomic,copy)NSString *collegeId;

///标题
@property(nonatomic,copy)NSString *title;

///时间
@property(nonatomic,copy)NSString *pubtime;

///图片路径
@property(nonatomic,copy)NSString *iamgeUrlString;

///简介
@property(nonatomic,copy)NSString *introduction;

///学院详情路径
@property(nonatomic,copy)NSString *detailUrl;

///学院详情
@property(nonatomic,strong) WMCollegeDetailInfo *detailInfo;

/**简介高度
 */
@property(nonatomic,assign) CGFloat introHeight;

///从字典中获取学院信息
+ (WMCollegeInfo *)decodeCollegeWithData:(NSDictionary*)data;

@end

/**学院详情信息
 */
@interface WMCollegeDetailInfo : NSObject

///图片列表，数组元素是图片路径 NSString，通过解析html内容获取
@property(nonatomic, strong) NSArray *images;

///html内容详情
@property(nonatomic, copy) NSString *htmlDetail;

///详情文本内容
@property(nonatomic, copy) NSString *detailContent;

@end

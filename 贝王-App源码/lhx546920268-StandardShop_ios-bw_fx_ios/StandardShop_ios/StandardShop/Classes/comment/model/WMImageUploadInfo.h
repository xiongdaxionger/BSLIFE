//
//  WMImageUploadInfo.h
//  StandardShop
//
//  Created by 罗海雄 on 16/6/29.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMImageInfo.h"

///图片上传信息
@interface WMImageUploadInfo : NSObject

///图片信息
@property(nonatomic,strong) WMImageInfo *imageInfo;

///上传进度
@property(nonatomic,assign) float progress;

///是否上传失败
@property(nonatomic,assign) BOOL uploadFail;

///是否正在上传
@property(nonatomic,assign) BOOL uploading;

/**获取封面参数
 *@param infos 数组元素是 WMImageUploadInfo
 *@return 封面参数
 */
+ (NSString*)imagesParamFromInfos:(NSArray*) infos;

/**获取配图参数
 *@param infos 数组元素是 WMImageUploadInfo
 *@return 配图参数
 */
+ (NSString*)descriptionsParamFromInfos:(NSArray*) infos;

@end

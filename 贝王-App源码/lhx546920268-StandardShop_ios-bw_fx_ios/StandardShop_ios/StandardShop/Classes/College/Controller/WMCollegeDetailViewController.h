//
//  WMCollegeDetailViewController.h
//  WestMailDutyFee
//
//  Created by 罗海雄 on 15/10/19.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//


@class WMCollegeInfo;

/**学院详情
 */
@interface WMCollegeDetailViewController : SeaWebViewController<UIActionSheetDelegate>

/**通过学院信息初始化
 *@param info 学院信息
 *@return 一个实例
 */
- (id)initWithInfo:(WMCollegeInfo*) info;

@end

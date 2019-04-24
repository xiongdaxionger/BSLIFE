//
//  WMPartnerDetailHeaderView.h
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/3.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMPartnerInfo;

///会员详情表头
@interface WMPartnerDetailHeaderView : UIView

/**构造方法
 *@param info 客户信息
 *@return 一个已经设置好大小的实例
 */
- (instancetype)initWithPartnerInfo:(WMPartnerInfo*) info;

@end

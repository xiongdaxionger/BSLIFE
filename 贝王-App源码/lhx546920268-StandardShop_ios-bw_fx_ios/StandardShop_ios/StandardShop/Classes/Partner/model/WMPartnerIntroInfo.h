//
//  WMPartnerIntroInfo.h
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/3.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

//边距
#define WMPartnerIntroCellMargin 15.0

//视图间隔
#define WMPartnerIntroCellControlInterval 5.0

//高度
#define WMPartnerIntroCellHeight 45.0

//字体
#define WMPartnerIntroCellFont [UIFont fontWithName:MainFontName size:15.0]

//标题宽度
#define WMPartnerIntroCellTitleWidth 70.0

/**会员简介列表信息
 */
@interface WMPartnerIntroInfo : NSObject

///标题
@property(nonatomic,copy) NSString *title;

///内容
@property(nonatomic,copy) NSString *content;

/**获取内容高度
 */
@property(nonatomic,assign) CGFloat contentHeight;

/**标题宽度
 */
@property(nonatomic,assign) CGFloat titleWidth;

/**构造方法
 */
+ (instancetype)infoWithTitle:(NSString*) title content:(NSString*) content;

@end

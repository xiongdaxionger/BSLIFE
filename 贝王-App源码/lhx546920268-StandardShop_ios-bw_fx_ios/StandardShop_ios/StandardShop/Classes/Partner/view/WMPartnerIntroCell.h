//
//  WMPartnerDetailIntroCell.h
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/3.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//


@class WMPartnerIntroInfo, WMPartnerLevelView;

///会员简介列表
@interface WMPartnerIntroCell : UITableViewCell

/**信息标题
 */
@property(nonatomic,readonly) UILabel *titleLabel;

/**信息内容
 */
@property(nonatomic,readonly) UILabel *contentLabel;

/**获取内容高度
 */
@property(nonatomic,assign) CGFloat contentHeight;

/**标题宽度
 */
@property(nonatomic,assign) CGFloat titleWidth;

/**简介信息
 */
@property(nonatomic,strong) WMPartnerIntroInfo *info;

@end

/**
 *  会员简介等级
 */
@interface WMPartnerIntroLevelCell : UITableViewCell

/**信息标题
 */
@property(nonatomic,readonly) UILabel *titleLabel;

/**标题宽度
 */
@property(nonatomic,assign) CGFloat titleWidth;

/**会员等级
 */
@property(nonatomic,readonly) WMPartnerLevelView *levelView;

@end

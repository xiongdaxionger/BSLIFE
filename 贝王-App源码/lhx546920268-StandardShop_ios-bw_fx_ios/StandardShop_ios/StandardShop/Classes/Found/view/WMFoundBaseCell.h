//
//  WMFoundBaseCell.h
//  WanShoes
//
//  Created by 罗海雄 on 16/3/22.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMFoundListInfo;

///边距
#define WMFoundBaseCellMargin 8.0

///行宽高比例
#define WMFoundBaseCellWithHeightScale (12.0 / 5.0)

///行高
#define WMFoundBaseCellHeight ((_width_ - WMFoundBaseCellMargin * 2) / WMFoundBaseCellWithHeightScale)

///发现列表基础cell
@interface WMFoundBaseCell : UITableViewCell

///发现列表信息
@property (strong, nonatomic) WMFoundListInfo *info;

@end

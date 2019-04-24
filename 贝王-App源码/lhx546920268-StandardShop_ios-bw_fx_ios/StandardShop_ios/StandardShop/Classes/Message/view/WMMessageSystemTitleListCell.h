//
//  WMMessageSystemTitleListCell.h
//  StandardShop
//
//  Created by 罗海雄 on 16/7/15.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

///边距
#define WMMessageSystemTitleListCellMargin 10.0

///高度
#define WMMessageSystemTitleListCellHeight 35.0

///系统消息标题
@interface WMMessageSystemTitleListCell : UITableViewCell

///标题
@property(nonatomic,readonly) UILabel *titleLabel;

@end

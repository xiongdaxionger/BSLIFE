//
//  WMTopupPayCell.h
//  WestMailDutyFee
//
//  Created by 罗海雄 on 15/8/31.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

//cell高度
#define WMTopupThirdPayCellHeight 70.0

/**充值第三方支付方式cell
*/
@interface WMTopupThirdPayCell : UITableViewCell

/**图标
 */
@property (weak, nonatomic) IBOutlet UIImageView *icon_imageView;

/**标题
 */
@property (weak, nonatomic) IBOutlet UILabel *title_label;

/**子标题
 */
@property (weak, nonatomic) IBOutlet UILabel *subtitle_label;

/**打钩选择状态
 */
@property (weak, nonatomic) IBOutlet UIImageView *tick_imageView;

@end

///高度
#define WMTopupSectionHeaderHeight 30.0

///充值section头部
@interface WMTopupSectionHeader : UITableViewHeaderFooterView

///标题
@property (readonly, nonatomic) UILabel *titleLabel;

@end
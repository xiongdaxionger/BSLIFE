//
//  WMCollegeTableViewCell.h
//  WestMailDutyFee
//
//  Created by YUYE on 15/8/31.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMCollegeInfo,WMCollegeTableViewCell;

/**学院列表代理
 */
@protocol WMCollegeCellDelegate <NSObject>

///查看学院详情
- (void)collegeCellDidLookDetail:(WMCollegeTableViewCell*) cell;

@end

/**学院列表cell
 */
@interface WMCollegeTableViewCell : UITableViewCell

/**白色背景
 */
@property (weak, nonatomic) IBOutlet UIView *white_bgView;

/**标题
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/**时间
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

/**图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *collegeIamgeView;

/**简介
 */
@property (weak, nonatomic) IBOutlet UILabel *introductionLabel;

/**简介高度约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *intro_label_height_constraint;

/**阅读全文按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *readCollegeDetailBtn;

/**学院信息
 */
@property (nonatomic, strong) WMCollegeInfo *info;

@property (nonatomic, weak) id<WMCollegeCellDelegate> delegate;

/**cell高度
 */
+ (CGFloat)rowHeightForInfo:(WMCollegeInfo*) college;

@end

//
//  WMCollecMoneyShareViewController.h
//  WestMailDutyFee
//
//  Created by 罗海雄 on 15/9/10.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

@class WMShareActionSheetContentView, WMCollectMoneyInfo;

/**收钱分享
 */
@interface WMCollecMoneyShareViewController : SeaViewController

/**顶部白色背景
 */
@property (weak, nonatomic) IBOutlet UIView *top_bgView;

/**顶部白色背景高度约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top_bgView_heightConstraint;

/**标题
 */
@property (weak, nonatomic) IBOutlet UILabel *title_label;

/**收款名称标题
 */
@property (weak, nonatomic) IBOutlet UILabel *name_title_label;

/**收款内容
 */
@property (weak, nonatomic) IBOutlet UILabel *name_content_label;

/**收款金额
 */
@property (weak, nonatomic) IBOutlet UILabel *amount_label;

/**分享标题
 */
@property (weak, nonatomic) IBOutlet UILabel *share_title_label;

/**分享内容视图
 */
@property (weak, nonatomic) IBOutlet WMShareActionSheetContentView *share_content_view;

/**收款信息
 */
@property (strong, nonatomic) WMCollectMoneyInfo *collectMoneyInfo;

@end

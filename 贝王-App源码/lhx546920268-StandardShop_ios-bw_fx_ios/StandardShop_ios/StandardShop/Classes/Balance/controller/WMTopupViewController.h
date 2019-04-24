//
//  WMTopupViewController.h
//  WestMailDutyFee
//
//  Created by 罗海雄 on 15/8/31.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

@class WMTopupInfo;

/**充值
 */
@interface WMTopupViewController : SeaTableViewController<UIAlertViewDelegate>

/**充值信息
 */
@property(nonatomic,strong) WMTopupInfo *topupInfo;

@end

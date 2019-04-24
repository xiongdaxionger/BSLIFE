//
//  WMSelectMemberViewCell.h
//  StandardFenXiao
//
//  Created by mac on 15/12/6.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XTableCellConfigExDelegate.h"
#define WMSelectMemberViewCellIden @"WMSelectMemberViewCellIden"
#define WMSelectMemberViewCellHegiht 53
/**选择会员代客下单
 */
@interface WMSelectMemberViewCell : UITableViewCell<XTableCellConfigExDelegate>
/**会员名称
 */
@property (weak, nonatomic) IBOutlet UILabel *memberNameLabel;
@end

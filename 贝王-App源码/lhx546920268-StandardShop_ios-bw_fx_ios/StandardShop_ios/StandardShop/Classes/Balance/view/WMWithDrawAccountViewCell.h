//
//  WMWithDrawAccountViewCell.h
//  StandardFenXiao
//
//  Created by mac on 15/12/3.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMWithDrawAccountInfo;
#define WMWithDrawAccountViewCellHeight 90
#define WMWithDrawAccountViewCellIden @"WMWithDrawAccountViewCellIden"

@interface WMWithDrawAccountViewCell : UITableViewCell
/**提现账户的图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
/**账号
 */
@property (weak, nonatomic) IBOutlet UILabel *typeNameLabel;
/**账号的类型名称
 */
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

- (void)confirmWithAccountInfo:(WMWithDrawAccountInfo *)info;
@end

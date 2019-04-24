//
//  WMBillListViewCell.h
//  StandardFenXiao
//
//  Created by mac on 15/12/4.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMBillInfoModel;
#define WMBillListViewCellIden @"WMBillListViewCellIden"
#define WMBillListViewCellHeight 80
/**账单显示
 */
@interface WMBillListViewCell : UITableViewCell
/**账单图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *billImageView;
/**账单的内容
 */
@property (weak, nonatomic) IBOutlet UILabel *billContentLabel;
/**账单的价格
 */
@property (weak, nonatomic) IBOutlet UILabel *billPriceLabel;
/**账单产生时间
 */
@property (weak, nonatomic) IBOutlet UILabel *billTimeLabel;
/**配置数据
 */
- (void)configureWithModel:(WMBillInfoModel *)infoModel;
@end

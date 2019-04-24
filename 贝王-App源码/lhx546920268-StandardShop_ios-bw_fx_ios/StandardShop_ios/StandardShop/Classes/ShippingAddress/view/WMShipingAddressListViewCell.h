//
//  WMShipingAddressListViewCell.h
//  WestMailDutyFee
//
//  Created by mac on 15/12/2.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

///行高
#define WMShipingAddressListViewCellHeight 65

@class WMShipingAddressListViewCell,WMShippingAddressInfo;

@protocol WMShipingAddressListViewCellDelegate <NSObject>

/**编辑收货地址
 */
- (void)shippingAddressListCellDidEdit:(WMShipingAddressListViewCell*) cell;

@end

@interface WMShipingAddressListViewCell : UITableViewCell

/**收货人的姓名
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

/**收货人的手机
 */
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

/**详细地址
 */
@property (weak, nonatomic) IBOutlet UILabel *deatilAddLabel;

/**编辑按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *editButton;

/**代理
 */
@property (nonatomic,weak) id<WMShipingAddressListViewCellDelegate> delegate;

@property (strong, nonatomic) WMShippingAddressInfo *info;

@end

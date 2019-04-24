//
//  WMShippingAddressEditViewController.h
//  WuMei
//
//  Created by 罗海雄 on 15/7/22.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

@class WMShippingAddressInfo;

/**收货地址编辑， 新增或修改
 */
@interface WMShippingAddressEditViewController : SeaTableViewController<UITextFieldDelegate, UITextViewDelegate>

/**以收货地址信息初始化，新增传nil
 */
- (id)initWithInfo:(WMShippingAddressInfo*) info;

/**选中的会员的ID
 */
@property (copy,nonatomic) NSString *selectMemberID;

/**商品中是否包含保税商品
 */
@property (assign,nonatomic) BOOL hasFreeGood;

/**能否删除地址
 */
@property (assign,nonatomic) BOOL canDeleteAddress;

@end

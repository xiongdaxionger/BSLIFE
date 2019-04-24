//
//  WMShipingAddressListViewCell.m
//  WestMailDutyFee
//
//  Created by mac on 15/12/2.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import "WMShipingAddressListViewCell.h"
#import "WMShippingAddressInfo.h"

@implementation WMShipingAddressListViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.editButton setTitleColor:WMRedColor forState:UIControlStateNormal];
    [self.editButton addTarget:self action:@selector(editAddress:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)setInfo:(WMShippingAddressInfo *)info
{
    _info = info;
    
    self.nameLabel.text = info.consignee;
    
    self.phoneLabel.text = info.displayPhoneNumber;

    if (info.isDefaultAdr)
    {
        self.deatilAddLabel.text = [NSString stringWithFormat:@"[默认]%@",info.addressCombination];
    }
    else
    {
        self.deatilAddLabel.text = info.addressCombination;
    }
}

//编辑收货地址
- (void)editAddress:(UIButton*) button
{
    if([self.delegate respondsToSelector:@selector(shippingAddressListCellDidEdit:)])
    {
        [self.delegate shippingAddressListCellDidEdit:self];
    }
}


@end

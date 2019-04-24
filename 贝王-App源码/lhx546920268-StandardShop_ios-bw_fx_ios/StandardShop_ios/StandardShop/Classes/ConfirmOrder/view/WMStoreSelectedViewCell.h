//
//  WMStoreSelectedViewCell.h
//  StandardShop
//
//  Created by Hank on 2018/6/11.
//  Copyright © 2018年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTableCellConfigExDelegate.h"

#define WMStoreSelectedViewCellIden @"WMStoreSelectedViewCellIden"
///选中的门店
@interface WMStoreSelectedViewCell : UITableViewCell<XTableCellConfigExDelegate>

///自提门店名称
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

///自提门店地址
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

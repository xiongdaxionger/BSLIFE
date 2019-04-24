//
//  WMStoreListViewCell.h
//  StandardShop
//
//  Created by Hank on 2018/6/11.
//  Copyright © 2018年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMStoreListInfo;
///门店列表
@interface WMStoreListViewCell : UITableViewCell

///门店名称
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;

///门店联系人
@property (weak, nonatomic) IBOutlet UILabel *contactLabel;

///地址
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

///门店电话
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;

///门店定位
@property (weak, nonatomic) IBOutlet UIButton *locationButton;

///距离
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

///点击事件
- (IBAction)phoneButtonAction:(UIButton *)sender;

- (IBAction)locationButtonAction:(UIButton *)sender;

///定位回调
@property (copy,nonatomic) void(^locationCallBack)(WMStoreListInfo *info);

///电话回调
@property (copy,nonatomic) void(^phoneCallBack)(WMStoreListInfo *info);

///门店信息
@property (strong,nonatomic) WMStoreListInfo *info;
@end

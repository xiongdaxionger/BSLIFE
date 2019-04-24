//
//  wuliutbViewController.h
//  WuMei
//
//  Created by mac on 15/7/29.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

///物流
@interface WMLogisticsViewController : SeaTableViewController

///配送ID/订单ID
@property(nonatomic,strong) NSString *deliveryID;

//是否是订单
@property (assign,nonatomic) BOOL isOrder;
@end

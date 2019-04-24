//
//  WMGoodCommentAddViewController.h
//  StandardShop
//
//  Created by 罗海雄 on 16/6/29.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "SeaTableViewController.h"

@class WMGoodInfo;

///添加商品评论
@interface WMGoodCommentAddViewController : SeaTableViewController

///商品信息
@property(nonatomic,strong) WMGoodInfo *goodInfo;

///订单id
@property(nonatomic,copy) NSString *orderId;

///评价成功回调
@property(nonatomic,copy) void(^commentDidFinsihHandler)(void);

@end

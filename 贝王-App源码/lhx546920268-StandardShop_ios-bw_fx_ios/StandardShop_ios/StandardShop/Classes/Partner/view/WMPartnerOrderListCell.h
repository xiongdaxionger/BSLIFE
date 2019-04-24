//
//  WMPartnerOrderListCell.h
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/3.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

///高度
#define WMPartnerOrderListCellHeight 86.0

@class WMOrderGoodInfo;

/**会员 订单列表
 */
@interface WMPartnerOrderListCell : UITableViewCell

///商品图片
@property (weak, nonatomic) IBOutlet UIImageView *good_imageView;

///商品名称
@property (weak, nonatomic) IBOutlet UILabel *name_label;

///金额，付款和收入
@property (weak, nonatomic) IBOutlet UILabel *amount_label;

///订单信息
@property (strong, nonatomic) WMOrderGoodInfo *info;


@end

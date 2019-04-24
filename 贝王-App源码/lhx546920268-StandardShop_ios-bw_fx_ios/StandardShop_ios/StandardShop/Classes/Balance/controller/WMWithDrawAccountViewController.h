//
//  WMWithDrawAccountViewController.h
//  StandardFenXiao
//
//  Created by mac on 15/12/3.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import "SeaViewController.h"

///提现账户列表
@interface WMWithDrawAccountViewController : SeaViewController

/**选择回调
 */
@property (copy,nonatomic) void(^selectAccountCallBakc)(NSString *accountName,NSString *accountID);

/**选中的indexPath
 */
@property (strong,nonatomic) NSIndexPath *selectIndex;

@end

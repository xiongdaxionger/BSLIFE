//
//  WMBillListViewController.h
//  StandardFenXiao
//
//  Created by mac on 15/12/4.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import "SeaTableViewController.h"

#import "SeaDropDownMenu.h"
/**账单列表
 */
@interface WMBillListViewController : SeaTableViewController<SeaDropDownMenuDelegate>
/**账单的状态
 */
@property (copy,nonatomic) NSString *billPayStatus;
/**页码
 */
@property (assign,nonatomic) NSInteger page_num;
/**选中的标题
 */
@property (copy,nonatomic) NSString *selectTitle;
/**一级菜单
 */
@property (assign,nonatomic) NSInteger firstIndex;
/**是否为分销
 */
@property (assign,nonatomic) BOOL isCommisionOrder;
@end

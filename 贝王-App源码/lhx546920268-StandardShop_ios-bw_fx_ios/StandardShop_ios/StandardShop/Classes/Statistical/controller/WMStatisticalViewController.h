//
//  WMStatisticalViewController.h
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/3.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "SeaViewController.h"

/**统计
 */
@interface WMStatisticalViewController : SeaViewController

///要打开的统计信息，section 访客、收入、订单，row 周、年、月
@property(nonatomic,strong) NSIndexPath *showedIndexPath;

@end

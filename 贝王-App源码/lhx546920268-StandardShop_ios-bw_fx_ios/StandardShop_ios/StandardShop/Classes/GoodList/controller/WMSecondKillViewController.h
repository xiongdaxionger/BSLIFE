//
//  WMSecondKillViewController.h
//  SuYan
//
//  Created by 罗海雄 on 16/4/14.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "SeaTableViewController.h"

///秒杀专区
@interface WMSecondKillViewController : SeaTableViewController

///打开时要显示的场次id
@property(nonatomic,copy) NSString *secondKillId;

///秒杀图片
@property(nonatomic,copy) NSString *secondKillImageURL;

@end

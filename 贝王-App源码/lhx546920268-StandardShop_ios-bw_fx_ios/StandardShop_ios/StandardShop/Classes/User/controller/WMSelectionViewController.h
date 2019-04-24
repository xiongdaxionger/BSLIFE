//
//  WMSelectionViewController.h
//  StandardShop
//
//  Created by 罗海雄 on 16/7/11.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "SeaTableViewController.h"

///用户信息选择，用户注册和个人信息修改
@interface WMSelectionViewController : SeaTableViewController

///是否可以多选
@property(nonatomic,assign) BOOL allowsMultipleSelection;

///选项 数组元素是NSString
@property(nonatomic,strong) NSArray *options;

///已选的 数组元素是NSString
@property(nonatomic,copy) NSMutableArray *selectedOptions;

///完成回调 selectedOptions 选中的内容
@property(nonatomic,copy) void(^completionHandler)(NSMutableArray *selectedOptions);

@end

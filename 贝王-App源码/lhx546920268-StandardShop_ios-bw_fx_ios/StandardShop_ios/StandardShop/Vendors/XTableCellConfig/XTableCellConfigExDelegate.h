//
//  XTableCellConfigExDelegate.h
//  WeiXueProject
//
//  Created by TBXark on 15/5/9.
//  Copyright (c) 2015年 TBXark. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XTableCellConfigExDelegate <NSObject>

@optional

- (void)configureCellWithModel:(id)model;

- (void)cellIsSelectAtIndexPath:(NSIndexPath *)indexPath
                      tableView:(UITableView *)tableView
                 viewController:(UIViewController *)viewController;


@end

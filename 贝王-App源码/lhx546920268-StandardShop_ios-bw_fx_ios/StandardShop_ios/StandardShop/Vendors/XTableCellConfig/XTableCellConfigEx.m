//
//  XTableCellConfigEx.m
//  WeiXueProject
//
//  Created by TBXark on 15/5/9.
//  Copyright (c) 2015年 TBXark. All rights reserved.
//

#import "XTableCellConfigEx.h"

#define kXTableCellConfigExIden @"XTableCellConfigExIden"

@implementation XTableCellConfigEx

+ (instancetype)cellConfigWithClassName:(Class)className
                           heightOfCell:(CGFloat)heightOfCell
                              tableView:(UITableView *)tableView
                                  isNib:(BOOL)isNib
{
    XTableCellConfigEx *config = [XTableCellConfigEx new];
    
    
    config.className = className;
    config.heightOfCell = heightOfCell;
    
    NSString *classsStr = NSStringFromClass(className);
    
    if (isNib) {
        UINib *nib = [UINib nibWithNibName:classsStr bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:classsStr];
    } else {
        [tableView registerClass:className forCellReuseIdentifier:classsStr];
    }
    
    return config;
}

- (id)cellOfCellConfigWithTableView:(UITableView *)tableView
                                         indexPath:(NSIndexPath *)indexPath;

{
    NSString *classsStr = NSStringFromClass(_className);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:classsStr forIndexPath:indexPath];
    return cell;
}


+ (instancetype)headerFooterViewWith:(Class)className
                           tableView:(UITableView *)tableView
{
    XTableCellConfigEx *config = [XTableCellConfigEx new];
    
    
    config.className = className;
    
    NSString *classsStr = NSStringFromClass(className);

    [tableView registerClass:className forHeaderFooterViewReuseIdentifier:classsStr];
    
    return config;
}

- (id)headerFooterConfigWithTableView:(UITableView *)tableView
{
    NSString *classsStr = NSStringFromClass(_className);
    return [tableView dequeueReusableHeaderFooterViewWithIdentifier:classsStr];
}


@end

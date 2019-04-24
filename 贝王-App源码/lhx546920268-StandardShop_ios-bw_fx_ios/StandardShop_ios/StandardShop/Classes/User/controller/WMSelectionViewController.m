//
//  WMSelectionViewController.m
//  StandardShop
//
//  Created by 罗海雄 on 16/7/11.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMSelectionViewController.h"

@interface WMSelectionViewController ()

@end

@implementation WMSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.backItem = YES;

    self.style = UITableViewStyleGrouped;

    if(!self.selectedOptions)
    {
        self.selectedOptions = [NSMutableArray array];
    }

    [self initialization];

    if(self.allowsMultipleSelection)
    {
        [self setBarItemsWithTitle:@"完成" icon:nil action:@selector(finish:) position:SeaNavigationItemPositionRight];
    }
}

- (void)setSelectedOptions:(NSMutableArray *)selectedOptions
{
    if(_selectedOptions != selectedOptions)
    {
        _selectedOptions = [selectedOptions mutableCopy];
    }
}

///完成
- (void)finish:(id) sender
{
    !self.completionHandler ?: self.completionHandler(self.selectedOptions);
    [self back];
}

#pragma mark- UITableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.options.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.tintColor = _appMainColor_;
    }

    NSString *title = [self.options objectAtIndex:indexPath.row];
    cell.textLabel.text = title;
    cell.accessoryType = [self.selectedOptions containsObject:title] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSString *title = [self.options objectAtIndex:indexPath.row];

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell.accessoryType == UITableViewCellAccessoryCheckmark)
    {
        if(self.allowsMultipleSelection)
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            [self.selectedOptions removeObject:title];
        }
    }
    else
    {
        [self.selectedOptions addObject:title];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;

        if(!self.allowsMultipleSelection)
        {
            if(self.selectedOptions.count > 1)
            {
                [self.selectedOptions removeObjectsInRange:NSMakeRange(0, self.selectedOptions.count - 1)];
            }
            !self.completionHandler ?: self.completionHandler(self.selectedOptions);
            [self back];
        }
    }
}

@end

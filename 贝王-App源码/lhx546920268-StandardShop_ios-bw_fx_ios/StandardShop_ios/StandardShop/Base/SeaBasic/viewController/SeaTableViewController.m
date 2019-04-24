//
//  SeaTableViewController.m

//

#import "SeaTableViewController.h"
#import "SeaBasic.h"

@interface SeaTableViewController ()


@end

@implementation SeaTableViewController

/**构造方法
 *@param style 列表风格
 *@return 一个初始化的 SeaTableViewController 对象
 */
- (id)initWithStyle:(UITableViewStyle) style
{
    self = [super initWithNibName:nil bundle:nil];
    if(self)
    {
        _separatorEdgeInsets = UIEdgeInsetsMake(0, 15.0, 0, 0);
        _style = style;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithStyle:UITableViewStylePlain];
}


#pragma mark- public method

/**初始化视图 子类必须调用该方法
 */
- (void)initialization
{
    CGRect frame = CGRectMake(0, 0, _width_, self.contentHeight);
        
    _tableView = [[UITableView alloc] initWithFrame:frame style:_style];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundView = nil;
    
    if (@available(iOS 11.0, *)) {
        [_tableView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    
    _tableView.sea_emptyViewDelegate = self;
    self.scrollView = _tableView;
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"fuZaCellIden"];
    
    [self.view addSubview:_tableView];
}

#pragma mark- tableView 代理

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setSeparatorInset:self.separatorEdgeInsets];
    
    if([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:self.separatorEdgeInsets];
    }
}

- (void)viewDidLayoutSubviews
{
    [self.tableView setSeparatorInset:self.separatorEdgeInsets];
    
    if([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView setLayoutMargins:self.separatorEdgeInsets];
    }
}


@end

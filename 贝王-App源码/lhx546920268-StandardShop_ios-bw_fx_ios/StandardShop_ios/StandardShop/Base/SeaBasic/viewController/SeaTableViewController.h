//
//  SeaTableViewController.h
//  Sea

//

#import "SeaScrollViewController.h"

/**列表控制视图
 */
@interface SeaTableViewController : SeaScrollViewController<UITableViewDelegate,UITableViewDataSource>

/**信息列表
 */
@property(nonatomic,readonly) UITableView *tableView;

/**列表风格
 */
@property(nonatomic,assign) UITableViewStyle style;

/**分割线位置 default is '(0, 15.0, 0, 0)'
 */
@property(nonatomic,assign) UIEdgeInsets separatorEdgeInsets;

/**构造方法
 *@param style 列表风格
 *@return 一个初始化的 SeaTableViewController 对象
 */
- (id)initWithStyle:(UITableViewStyle) style;


@end

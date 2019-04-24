//
//  WMPushSearchViewController.h
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/23.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import "SeaTableViewController.h"

/**搜索父类，会跳到另一个页面
 */
@interface WMPushSearchViewController : SeaTableViewController<SeaHttpRequestDelegate,UISearchBarDelegate>

///网络请求 已初始化
@property(nonatomic,strong) SeaHttpRequest *httpRequest;

///数据源，数组元素根据子类变化 已初始化
@property(nonatomic,strong) NSMutableArray *infos;

///搜索栏
@property(nonatomic,strong) UISearchBar *searchBar;

///点击搜索 子类重写该方法
- (void)didSearchWithText:(NSString*) text;

@end

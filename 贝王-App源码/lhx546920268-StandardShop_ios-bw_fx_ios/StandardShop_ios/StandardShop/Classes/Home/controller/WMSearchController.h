//
//  WMSearchController.h
//  StandardShop
//
//  Created by 罗海雄 on 16/6/22.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

///用于放在导航栏的搜索控制器
@interface WMSearchController : NSObject

///搜索栏要显示的内容 default is 'nil'
@property(nonatomic,copy) NSString *searchContent;

///搜索栏
@property(nonatomic,readonly) UISearchBar *searchBar;

///搜索回调
@property(nonatomic,copy) void(^searchHandler)(NSString *searchKey);

///结束搜索回调
@property(nonatomic,copy) void(^searchDidEndHandler)(void);

///开始搜索回调
@property(nonatomic,copy) void(^searchDidBeginHandler)(void);

///设置透明度
@property(nonatomic,assign) CGFloat alpha;

///是否需要保留搜索内容 default is 'NO'
@property(nonatomic,assign) BOOL keepSearchContent;

/**构造方法
 *@param viewController 搜索栏所在的视图
 *@return 一个实例
 */
- (instancetype)initWithViewController:(UIViewController*) viewController;

///搜索
- (void)search;

///关闭联想
- (void)closeAssociate;

@end

///搜索列表文本cell
@interface WMSearchTextCell : UICollectionViewCell

///标题
@property(nonatomic,readonly) UILabel *title_label;

@end

@class WMSearchSectionHeader;

///搜索列表 section头部代理
@protocol WMSearchSectionHeaderDelegate <NSObject>

///删除
- (void)searchSectionHeaderDidDelete:(WMSearchSectionHeader*) header;

@end

///搜索列表 section头部
@interface WMSearchSectionHeader : UICollectionReusableView

///标题
@property(nonatomic,readonly) UIButton *title_btn;

///删除按钮
@property(nonatomic,readonly) UIButton *delete_btn;

@property(nonatomic,weak) id<WMSearchSectionHeaderDelegate> delegate;

@end

///搜索列表 section 底部
@interface WMSearchSectionFooter : UICollectionReusableView

///标题
@property(nonatomic,readonly) UILabel *title_label;

@end

///搜索视图，有搜索记录
@interface WMSearchViewController : SeaCollectionViewController

///关联的搜索控制器
@property(nonatomic,weak) WMSearchController *searchController;

///添加搜索记录
- (void)addHistory:(NSString*) history;

@end

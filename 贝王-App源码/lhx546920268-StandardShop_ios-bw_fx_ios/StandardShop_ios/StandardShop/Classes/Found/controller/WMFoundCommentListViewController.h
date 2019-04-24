//
//  WMFoundCommentListViewController.h
//  WanShoes
//
//  Created by 罗海雄 on 16/3/23.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "SeaTableViewController.h"

@class WMFoundListInfo;

///文章、发现详情、评论列表
@interface WMFoundCommentListViewController : SeaTableViewController<UIWebViewDelegate>

///文章id 如果是通过 WMFoundListInfo 初始化，此值不需要设置
@property(nonatomic,copy) NSString *articleId;

/**构造方法
 *@param info 发现信息
 *@return 一个实例
 */
- (instancetype)initWithInfo:(WMFoundListInfo*) info;

@end

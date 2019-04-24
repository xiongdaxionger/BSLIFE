//
//  WMArticleViewController.h
//  WuMei
//
//  Created by 罗海雄 on 15/8/17.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

/**文章
 */
@interface WMArticleViewController : SeaWebViewController

/**文章id
 */
@property(nonatomic,copy) NSString *articleId;

/**文章内容，如果有，则不会通过文章id获取它的内容
 */
@property(nonatomic,copy) NSString *content;

@end

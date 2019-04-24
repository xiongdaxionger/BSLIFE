//
//  WMGoodCommentViewController.h
//  StandardShop
//
//  Created by 罗海雄 on 16/6/1.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "SeaTableViewController.h"

///商品评论列表
@interface WMGoodCommentViewController : SeaTableViewController

/**构造方法
 *@param goodId 商品id
 *@return 一个实例
 */
- (instancetype)initWithGoodId:(NSString*) goodId;

@end

//
//  WMGoodTagTableViewCell.h
//  StandardShop
//
//  Created by mac on 16/6/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XTableCellConfigExDelegate.h"

#define WMGoodTagTableViewCellIden @"WMGoodTagTableViewCellIden"
#define WMGoodTagTableViewCellHeight 44.0
//额外内容宽度--用于计算高度
#define WMGoodTagExtraWidth 16.0
//标签内容的额外宽度
#define WMGoodTagContentExtraWidth 48.0
@class JCTagListView;
/**商品标签
 */
@interface WMGoodTagTableViewCell : UITableViewCell<XTableCellConfigExDelegate>
/**标签视图
 */
@property (weak, nonatomic) IBOutlet JCTagListView *goodTagListView;
/**数据配置
 */
- (void)configureCellWithModel:(id)model;
@end

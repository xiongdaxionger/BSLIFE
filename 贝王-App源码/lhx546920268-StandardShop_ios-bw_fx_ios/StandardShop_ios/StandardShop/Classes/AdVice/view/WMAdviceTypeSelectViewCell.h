//
//  WMAdviceTypeSelectViewCell.h
//  StandardShop
//
//  Created by mac on 16/6/2.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMAdviceTypeInfo;
//单元格ID
#define WMAdviceTypeSelectViewCellIden @"WMAdviceTypeSelectViewCellIden"
//单元格高度
#define WMAdviceTypeSelectViewCellHeight 44.0
/**咨询类型选择单元格
 */
@interface WMAdviceTypeSelectViewCell : UITableViewCell
/**类型名称
 */
@property (weak, nonatomic) IBOutlet UILabel *adviceTypeNameLabel;
/**勾选按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *adviceSelectButton;
/**配置数据显示
 */
- (void)configureAdviceTypeInfo:(WMAdviceTypeInfo *)info;
@end

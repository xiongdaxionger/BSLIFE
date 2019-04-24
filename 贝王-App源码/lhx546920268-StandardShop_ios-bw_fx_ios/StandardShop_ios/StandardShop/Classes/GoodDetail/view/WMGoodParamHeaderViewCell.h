//
//  WMGoodParamHeaderViewCell.h
//  StandardShop
//
//  Created by mac on 16/6/17.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WMGoodParamHeaderViewCellIden @"WMGoodParamHeaderViewCellIden"
#define WMGoodParamHeaderViewCellHeight 44
#define WMGoodParamHeaderViewCellExtraHeight 23
/**规格参数组名内容显示
 */
@interface WMGoodParamHeaderViewCell : UITableViewCell
/**组名文本
 */
@property (weak, nonatomic) IBOutlet UILabel *paramGroupNameLabel;
/**配置数据
 */
- (void)configureWithModel:(NSString *)groupName;
@end

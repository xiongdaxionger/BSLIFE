//
//  WMGoodParamContentViewCell.h
//  StandardShop
//
//  Created by mac on 16/6/17.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMGoodDetailParamValueInfo;
//规格参数名称的固定宽度
#define WMGoodParamContentNameWidth 70
//额外宽度
#define WMGoodParamContentExtraWidth 94
//额外高度
#define WMGoodParamContentExtraHeight 23
#define WMGoodParamContentViewCellIden @"WMGoodParamContentViewCellIden"
/**规格参数的内容显示
 */
@interface WMGoodParamContentViewCell : UITableViewCell
/**规格参数的名称文本
 */
@property (weak, nonatomic) IBOutlet UILabel *paramContentNameLabel;
/**规格参数的内容文本
 */
@property (weak, nonatomic) IBOutlet UILabel *paramContentLabel;
/**线条视图
 */
@property (weak, nonatomic) IBOutlet UIView *lineView;
/**线条宽度
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewWidth;


/**配置数据
 */
- (void)configureWithModel:(WMGoodDetailParamValueInfo *)info;
@end

//
//  WMShippingTipViewCell.h
//  WanShoes
//
//  Created by mac on 16/3/15.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#define WMShippingTipViewCellIden @"WMShippingTipViewCellIden"
#define WMShippingTipViewCellHeight 44
@class WMShippingMethodInfo;

@protocol WMShippingTipViewCellDelegate <NSObject>

/**选中物流保价
 */
- (void)selectExpressProtectSelectCell:(UITableViewCell *)cell;

/**取消选中物流保价
 */
- (void)unSelectExpressProtectCell:(UITableViewCell *)cell;
@end
#import <UIKit/UIKit.h>
/**配送方式展示
 */
@interface WMShippingTipViewCell : UITableViewCell
/**快递方式
 */
@property (weak, nonatomic) IBOutlet UILabel *tittleLabel;
/**右侧箭头
 */
@property (weak, nonatomic) IBOutlet UIImageView *rightArrowImage;
/**物流保价选择
 */
@property (weak, nonatomic) IBOutlet UIButton *expressProtectButton;
/**物流保价信息
 */
@property (weak, nonatomic) IBOutlet UILabel *expressProtectInfoLabel;
/**物流保价信息的左侧位置
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *expressInfoLeft;

/**协议
 */
@property (weak,nonatomic) id<WMShippingTipViewCellDelegate>delegate;
/**配置数据
 */
- (void)configureWithString:(WMShippingMethodInfo *)infoString;
@end

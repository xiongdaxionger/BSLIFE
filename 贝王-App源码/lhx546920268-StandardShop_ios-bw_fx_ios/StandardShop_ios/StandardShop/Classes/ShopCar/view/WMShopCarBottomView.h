//
//  WMShopCarBottomView.h
//  WestMailDutyFee
//
//  Created by qsit on 15/8/27.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMShopCarInfo;
/**右边距
 */
#define WMShopCarBottomRightMargin 10.0
/**上边距
 */
#define WMShopCarBottomTopMargin 5.0

@interface WMShopCarBottomView : UIView

/**点击结算按钮
 */
@property (copy,nonatomic) void (^payButtonClick)(UIButton *button);
/**点击全选按钮
 */
@property (copy,nonatomic) void (^selectAllClick)(BOOL isSelectAll);
/**点击删除
 */
@property (copy,nonatomic) void (^deleteButtonClick)(UIButton *button);

/**初始化
 */
- (instancetype)initWithFrame:(CGRect)frame shopCarModel:(WMShopCarInfo *)model;
/**全选图片按钮
 */
@property (strong,nonatomic) UIButton *selectAllImageButton;
/**全选按钮
 */
@property (strong,nonatomic) UIButton *selectAllButton;
/**价格文本
 */
@property (strong,nonatomic) UILabel *priceLabel;
/**节省文本
 */
@property (strong,nonatomic) UILabel *promotionLabel;
/**结算按钮
 */
@property (strong,nonatomic) UIButton *payButton;
/**删除按钮
 */
@property (strong,nonatomic) UIButton *deleteButton;
/**是否编辑状态
 */
@property (assign,nonatomic) BOOL isEdit;
/**更改总价/节省价/购买数量
 */
- (void)changeBuyInfoWithShopCarInfo:(WMShopCarInfo *)info;
@end

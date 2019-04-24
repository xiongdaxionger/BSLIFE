//
//  WMShippingAddressEditCell.h
//  WuMei
//
//  Created by 罗海雄 on 15/7/22.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import <UIKit/UIKit.h>

//边距
#define WMShippingAddressEditCellMargin 15.0

//每行高度
#define WMShippingAddressEditCellRowHeight 48.0

//新增收货地址cell

/**单行输入框
 */
@interface WMShippingAddressEditSingleInputCell : UITableViewCell

/**标题
 */
@property(nonatomic,readonly) UILabel *titleLabel;

@property(nonatomic,readonly) UITextField *textField;

@end


/**多行输入框
 */
@interface WMShippingAddressEditMultiInputCell : UITableViewCell

/**标题
 */
@property(nonatomic,readonly) UILabel *titleLabel;

@property(nonatomic,readonly) UITextView *textView;

@end

/**地区选择
 */
@interface WMShippingAddressEditCell : UITableViewCell

/**标题
 */
@property(nonatomic,readonly) UILabel *titleLabel;

/**内容
 */
@property(nonatomic,readonly) UILabel *contentLabel;

@end

/**默认收货地址
 */
@interface WMShippingAddressDefaultCell : UITableViewCell

///默认按钮
@property(nonatomic,readonly) UIButton *defaultButton;

@end
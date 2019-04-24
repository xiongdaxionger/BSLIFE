//
//  ValuesCommonViewCell.h
//  WuMei
//
//  Created by qsit on 15/7/21.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ValuesCommonViewCellDelegate <NSObject>

/**选中某个规格后的回调
 */
- (void)textSpecValueSelectWithProductID:(NSString *)productID;

@end

@class JCTagListView;
@class WMGoodDetailSpecInfo;
#define ValuesCommonViewCellIden @"ValuesCommonViewCellIden"
#define ValuesCommonViewCellExtraHeight 44
#define ValuesCommonTagExtraWidth 30.0
/**文字规格选择
 */
@interface ValuesCommonViewCell : UITableViewCell
/**属性名称
 */
@property (weak, nonatomic) IBOutlet UILabel *valuesNameLabel;
/**属性展示视图
 */
@property (weak, nonatomic) IBOutlet JCTagListView *valuesListView;
/**数据
 */
@property (strong,nonatomic) WMGoodDetailSpecInfo *specInfo;
/**代理
 */
@property (weak,nonatomic) id<ValuesCommonViewCellDelegate>delegate;
/**配置数据
 */
- (void)configureCellWithModel:(WMGoodDetailSpecInfo *)model;
@end

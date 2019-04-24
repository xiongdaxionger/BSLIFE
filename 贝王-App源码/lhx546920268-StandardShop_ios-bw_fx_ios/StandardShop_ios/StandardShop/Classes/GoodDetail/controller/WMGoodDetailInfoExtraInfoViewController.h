//
//  WMGoodDetailInfoExtraInfoViewController.h
//  StandardShop
//
//  Created by mac on 16/6/12.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "SeaTableViewController.h"

/**商品详情页扩展属性显示控制器
 */
@interface WMGoodDetailInfoExtraInfoViewController : SeaViewController
/**扩展属性数组--元素是字典,key为name对应扩展属性名称,key为value对应扩展属性内容
 */
@property (strong,nonatomic) NSArray *extraInfosArr;
/**切换动画
 */
@property (strong,nonatomic) SeaPartialPresentTransitionDelegate *p_delegate;
/**显示/隐藏
 */
- (void)dismissSelf;

@end

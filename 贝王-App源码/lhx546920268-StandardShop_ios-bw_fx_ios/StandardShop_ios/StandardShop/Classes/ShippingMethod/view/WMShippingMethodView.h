//
//  WMShippingMethodView.h
//  WanShoes
//
//  Created by mac on 16/3/15.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMShippingMethodView;

@protocol WMShippingMethodViewProtocol <NSObject>

/**取消选择
 */
- (void)shippingMethodViewCancelSelect;

@end

@interface WMShippingMethodView : UIView

/**代理
 */
@property (weak,nonatomic) id<WMShippingMethodViewProtocol>delegate;
@end

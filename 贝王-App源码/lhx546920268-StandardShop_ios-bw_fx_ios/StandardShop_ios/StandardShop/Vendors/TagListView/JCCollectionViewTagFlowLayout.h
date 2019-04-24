//
//  JCCollectionViewTagFlowLayout.h
//  JCTagListView
//
//  Created by 李京城 on 15/7/3.
//  Copyright (c) 2015年 李京城. All rights reserved.
//

#import <UIKit/UIKit.h>

/**标签视图的排版
 */
@interface JCCollectionViewTagFlowLayout : UICollectionViewFlowLayout
/**单个的高度
 */
@property (assign,nonatomic) CGFloat sizeHeight;
/**配置
 */
- (void)setup;
@end

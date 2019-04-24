//
//  JCTagCell.h
//  JCTagListView
//
//  Created by 李京城 on 15/7/3.
//  Copyright (c) 2015年 李京城. All rights reserved.
//

#import <UIKit/UIKit.h>

//标签图片大小
#define WMTagImageSize 28.0
//样式
typedef NS_ENUM(NSInteger, StyleType){
    
    //纯文本
    StyleTypeText = 1,
    
    //图片和文本
    StyleTypeImageText = 2,
};

@interface JCTagCell : UICollectionViewCell
/**文本内容显示
 */
@property (nonatomic, strong) UILabel *titleLabel;
/**图片
 */
@property (nonatomic, strong) UIImageView *tagImage;
/**类型
 */
@property (assign,nonatomic) StyleType type;
/**标签高度
 */
@property (assign,nonatomic) CGFloat cellHeight;






@end

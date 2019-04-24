//
//  WMGoodCategorySectionHeader.h
//  StandardShop
//
//  Created by 罗海雄 on 16/6/27.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

///大小
#define WMGoodCategorySectionHeaderHeight 40.0

@class WMCategoryInfo;

///分类section头部
@interface WMGoodCategorySectionHeader : UICollectionReusableView

///标题
@property (readonly, nonatomic) UILabel *title_label;

@end

@class WMGoodCategorySectionImageHeader;

@protocol WMGoodCategorySectionImageHeaderDelegate <NSObject>

///点击分类图片
- (void)goodCategorySectionImageHeaderDidTapImage:(WMGoodCategorySectionImageHeader*) header;

@end

///分类section头部，用于二级分类没有次级分类，显示该分类的图片
@interface WMGoodCategorySectionImageHeader : UICollectionReusableView

///section位置
@property (assign, nonatomic) NSInteger section;

///关联的分类
@property (strong, nonatomic) WMCategoryInfo *info;

///标题
@property (readonly, nonatomic) UILabel *title_label;

///图片
@property (readonly, nonatomic) UIImageView *imageView;

@property (weak, nonatomic) id<WMGoodCategorySectionImageHeaderDelegate> delegate;

///通过collectionView宽度获取header大小
+ (CGSize)sizeForWidth:(CGFloat) width;

@end

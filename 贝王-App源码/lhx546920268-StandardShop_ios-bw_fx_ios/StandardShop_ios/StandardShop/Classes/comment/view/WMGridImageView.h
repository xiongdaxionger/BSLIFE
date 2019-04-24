//
//  WMGridImageView.h
//  StandardShop
//
//  Created by 罗海雄 on 16/6/2.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMGridImageView;

///九宫格图片布局代理
@protocol WMGridImageViewDelegate <NSObject>

@optional

///一张图片时图片加载完成，要重新布局，只有showWithOriginalScaleWhenOnlyOneImage为YES时才会调用
- (void)gridImageViewDidLayoutAgain:(WMGridImageView*) view;

///点击某张图片
- (void)gridImageView:(WMGridImageView*) view didSelectAtIndex:(NSInteger) index ;

@end

///九宫格图片布局 使用的时候通过init 初始化，高度和宽度会根据图片数量和每行图片数量自动调整，可在xib中使用	
@interface WMGridImageView : UIView

///图片每行最大数量 default is '3'
@property(nonatomic,assign) int maxCountPerRow;

///图片间隔 default is '5'
@property(nonatomic,assign) CGFloat interval;

///图片大小 default is '75.0'
@property(nonatomic,assign) int imageSize;

///如果图片只有一张，是否按图片原来尺寸的比例显示，default is 'NO'
@property(nonatomic,assign) BOOL showWithOriginalScaleWhenOnlyOneImage;

///图片只有一张时，按图片原来尺寸的比例显示的最大尺寸，default is "CGSizeMake(imageSize * maxCountPerRow + (maxCountPerRow - 1) * interval, imageSize * maxCountPerRow + (maxCountPerRow - 1) * interval)"
@property(nonatomic,assign) CGSize maxImageSizeWhenOnlyOneImage;

///可见的视图，数组元素是 UIImageView，建议一个viewController 只有一个，用来复用的
@property(nonatomic,strong) NSMutableSet *visibleCells;

///留在复用的视图，数组元素是 UIImageView，建议一个viewController 只有一个，用来复用的
@property(nonatomic,strong) NSMutableSet *reusedCells;

///要显示的图片，数组元素是图片路径 NSString，如果和以前的images不一样，会调用reloadData
@property(nonatomic,strong) NSArray *images;

@property(nonatomic,weak) id<WMGridImageViewDelegate> delegate;


///刷新数据
- (void)reloadData;

///获取cell
- (UIImageView*)cellForIndex:(NSInteger) index;

/**通过图片数量获取视图高度 使用默认的图片间隔和每行图片数量
 */
+ (CGFloat)heightForImageCount:(NSInteger) count imageSize:(CGFloat) imageSize;

/**通过图片数量、图片间隔和每行图片数量获取视图高度
 */
+ (CGFloat)heightForImageCount:(NSInteger) count imageSize:(CGFloat) imageSize interval:(CGFloat) interval countPerRow:(int) countPerRow showWithOriginalScaleWhenOnlyOneImage:(BOOL) flag;

@end

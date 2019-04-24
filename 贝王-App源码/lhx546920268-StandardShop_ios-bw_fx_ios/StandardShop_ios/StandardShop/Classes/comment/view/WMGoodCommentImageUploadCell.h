//
//  WMGoodCommentImageUploadCell.h
//  StandardShop
//
//  Created by 罗海雄 on 16/6/29.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

/**图片添加
 */
@interface WMImageUploadSelectedItem : UICollectionViewCell

///添加按钮
@property(nonatomic,readonly) UIButton *addButton;

@end

@class WMImageUploadItem;

@protocol WMImageUploadItemDelegate <NSObject>

///删除
- (void)imageUploadItemDidDelete:(WMImageUploadItem*) item;

///点击上传失败按钮
- (void)imageUploadItemDidUploadFail:(WMImageUploadItem *)item;

@end

/**编辑 图片 collectionView cell
 */
@interface WMImageUploadItem : UICollectionViewCell

///图片
@property(nonatomic,readonly) UIImageView *imageView;

///删除按钮
@property(nonatomic,readonly) UIButton *deleteButton;

///上传进度
@property(nonatomic,readonly) SeaProgressView *progressView;

///上传失败按钮
@property(nonatomic,readonly) UIButton *uploadFailButton;

///是否正在编辑
@property(nonatomic,assign) BOOL editing;

@property(nonatomic,weak) id<WMImageUploadItemDelegate> delegate;

/**是否正在编辑
 */
//@property(nonatomic,assign) BOOL editing;

/**设置编辑状态
 *@param flag 是否动画
 */
//- (void)setEditing:(BOOL)editing animated:(BOOL) flag;

@end



@class WMGoodCommentImageUploadCell;

///商品选中代理
@protocol WMGoodCommentImageUploadCellDelegate<NSObject>

///高度改变
- (void)goodCommentImageUploadCellHeightDidChange:(WMGoodCommentImageUploadCell*) cell;

@end


///商品评价图片上传
@interface WMGoodCommentImageUploadCell : UITableViewCell<UICollectionViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

///图片集合
@property(nonatomic,readonly) UICollectionView *collectionView;

///图片最大选择数量
@property(nonatomic,readonly) NSInteger maxCount;

///数据源，数组元素是 WMImageUploadInfo
@property(nonatomic,strong) NSMutableArray *infos;

///图片最大尺寸 default is '1024 * 1024'
@property(nonatomic,assign) CGSize maxImageSize;

///关联的ViewController
@property(nonatomic,weak) UIViewController *viewController;

///选中的cell
@property(nonatomic,copy) NSIndexPath *selectedIndexPath;

/**编辑的item
 */
@property(nonatomic,copy) NSIndexPath *editedIndexPath;


@property(nonatomic,weak) id<WMGoodCommentImageUploadCellDelegate> delegate;

///重新布局
- (void)layoutViews;

///行高
- (CGFloat)rowHeight;

/**构造方法
 *@param maxCount 图片最大选择数量
 */
- (instancetype)initWithMaxCount:(NSInteger)maxCount;

@end

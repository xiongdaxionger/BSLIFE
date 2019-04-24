//
//  WMGoodCommentImageUploadCell.m
//  StandardShop
//
//  Created by 罗海雄 on 16/6/29.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodCommentImageUploadCell.h"
#import "WMTabBarController.h"
#import "WMImageUploadInfo.h"
#import "WMCommentOperation.h"
#import "SeaCollectionViewDraggableLayout.h"

///边距
#define WMGoodCommentAddCellMargin 15.0

@implementation WMImageUploadSelectedItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addButton.backgroundColor = WMRedColor;
        _addButton.frame = CGRectMake(0, 0, self.width, self.height);
        [_addButton setImage:[UIImage imageNamed:@"comment_image_add"] forState:UIControlStateNormal];
        [self.contentView addSubview:_addButton];
        
    }
    return self;
}

@end

@implementation WMImageUploadItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.contentView.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        [self.contentView addSubview:_imageView];
        
        CGFloat size = 30.0;
        UIImage *image = [UIImage imageNamed:@"comment_image_delete"];
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.frame = CGRectMake(self.width - size + image.size.width / 2.0, - image.size.height / 2.0 + 1.0, size, size);
        [_deleteButton setImage:image forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteItem:) forControlEvents:UIControlEventTouchUpInside];
        [_deleteButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [_deleteButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        _deleteButton.hidden = NO;
        [self.contentView addSubview:_deleteButton];
        
        ///进度条
        _progressView = [[SeaProgressView alloc] initWithFrame:_imageView.frame style:SeaProgressViewStyleRoundCakesFromFull];
        _progressView.progressColor = [_appMainColor_ colorWithAlphaComponent:0.5];
        _progressView.trackColor = [UIColor whiteColor];
        _progressView.userInteractionEnabled = NO;
        [self.contentView addSubview:_progressView];
        
        ///上传失败按钮
        _uploadFailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_uploadFailButton setTitle:@"上传\n失败" forState:UIControlStateNormal];
        [_uploadFailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_uploadFailButton addTarget:self action:@selector(uploadFail:) forControlEvents:UIControlEventTouchUpInside];
        _uploadFailButton.titleLabel.font = [UIFont fontWithName:MainFontName size:14.0];
        _uploadFailButton.frame = _imageView.frame;
        _uploadFailButton.titleLabel.numberOfLines = 2;
        _uploadFailButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self.contentView addSubview:_uploadFailButton];
        
        [self.contentView bringSubviewToFront:_deleteButton];
    }
    
    return self;
}

///删除
- (void)deleteItem:(id) sender
{
    if([self.delegate respondsToSelector:@selector(imageUploadItemDidDelete:)])
    {
        [self.delegate imageUploadItemDidDelete:self];
    }
}

///上传失败
- (void)uploadFail:(id) sender
{
    if([self.delegate respondsToSelector:@selector(imageUploadItemDidUploadFail:)])
    {
        [self.delegate imageUploadItemDidUploadFail:self];
    }
}

- (void)setEditing:(BOOL)editing
{
    if(_editing != editing)
    {
        _editing = editing;
        _deleteButton.hidden = _editing;
    }
}

/**设置编辑状态
 *@param flag 是否动画
 */
//- (void)setEditing:(BOOL)editing animated:(BOOL) flag
//{
//    if(_editing != editing)
//    {
//        _editing = editing;
//
//        if(flag)
//        {
//            if(editing)
//            {
//                _deleteButton.hidden = NO;
//            }
//            [UIView animateWithDuration:_animatedDuration_ animations:^(void){
//
//                CGFloat scale = editing ? 1.0 : 0.1;
//
//                _deleteButton.transform = CGAffineTransformMakeScale(scale, scale);
//
//            }completion:^(BOOL finish){
//
//                if(!editing)
//                {
//                    _deleteButton.hidden = YES;
//                }
//            }];
//        }
//        else
//        {
//            _deleteButton.hidden = !editing;
//            CGFloat scale = editing ? 1.0 : 0.1;
//            _deleteButton.transform = CGAffineTransformMakeScale(scale, scale);
//        }
//    }
//}

@end

///每行数量
#define WMGoodCommentImageUploadCellCountPerRow (_width_ == 320.0 ? 4 : 5)


///最低高度
#define WMGoodCommentImageUploadCellMinHeight ((_width_ - WMGoodCommentAddCellMargin * (WMGoodCommentImageUploadCellCountPerRow + 1)) / WMGoodCommentImageUploadCellCountPerRow + WMGoodCommentAddCellMargin * 2)

@interface WMGoodCommentImageUploadCell ()<SeaAlbumDelegate,SeaNetworkQueueDelegate,WMImageUploadItemDelegate,SeaCollectionViewDraggableLayoutDelegate>

///网络请求队列
@property(nonatomic,strong) SeaNetworkQueue *queue;

@end

@implementation WMGoodCommentImageUploadCell

/**构造方法
 *@param maxCount 图片最大选择数量
 */
- (instancetype)initWithMaxCount:(NSInteger)maxCount
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WMImageUploadSelectedCell"];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _infos = [[NSMutableArray alloc] initWithCapacity:maxCount];
        _maxImageSize = CGSizeMake(1242 / 3.0, 2208.0 / 3.0);
        
        _maxCount = maxCount;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0, 0, _width_, WMGoodCommentImageUploadCellMinHeight) collectionViewLayout:[self flowLayout]];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[WMImageUploadItem class] forCellWithReuseIdentifier:@"WMImageUploadItem"];
        [_collectionView registerClass:[WMImageUploadSelectedItem class] forCellWithReuseIdentifier:@"WMImageUploadSelectedItem"];
        _collectionView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_collectionView];
        
    }
    
    return self;
}

- (void)dealloc
{
    [_queue cancelAllRequest];
}

///行高
- (CGFloat)rowHeight
{
    int itemPerRow = WMGoodCommentImageUploadCellCountPerRow;
    
    int count = (int)(_infos.count == _maxCount ? self.infos.count : (self.infos.count + 1));
    
    int row = 0;
    if(count % itemPerRow == 0)
    {
        row = count / itemPerRow;
    }
    else
    {
        row = count / itemPerRow + 1;
    }
    
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    return WMGoodCommentAddCellMargin * 2 + layout.itemSize.height * row + layout.minimumLineSpacing * (row - 1);
}

///根据屏幕创建layout
- (UICollectionViewFlowLayout*)flowLayout
{
    CGFloat minSize = (WMGoodCommentImageUploadCellMinHeight - WMGoodCommentAddCellMargin * 2);
    CGFloat interval = WMGoodCommentAddCellMargin;
    
    SeaCollectionViewDraggableLayout *layout = [[SeaCollectionViewDraggableLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(interval, interval, interval, interval);
    layout.minimumLineSpacing = interval;
    layout.minimumInteritemSpacing = interval;
    layout.itemSize = CGSizeMake(minSize, minSize);
    return layout;
}

///重新布局
- (void)layoutViews
{
    self.collectionView.height = [self rowHeight];
}

#pragma mark - SeaCollectionViewDraggableLayout delegate

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didMoveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    id theFromItem = [self.infos objectAtIndex:indexPath.item];
    
    [self.infos removeObjectAtIndex:indexPath.item];
    
    [self.infos insertObject:theFromItem atIndex:toIndexPath.item];
}

- (void)collectionView:(UICollectionView *)collectionView layoutDidEndEdit:(UICollectionViewLayout *)collectionViewLayout fromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    ///判断item有没有移动
    //    if([fromIndexPath isEqual:toIndexPath])
    //    {
    //        self.editedIndexPath = fromIndexPath;
    //
    //        return;
    //    }
    
    self.editedIndexPath = nil;
    [self.collectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willBeginMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    //取消前面选中的编辑
    //    if(self.editedIndexPath != nil && ![self.editedIndexPath isEqual:indexPath] && self.editedIndexPath.row < self.infos.count)
    //    {
    //        WMImageUploadItem *cell = (WMImageUploadItem*)[collectionView cellForItemAtIndexPath:self.editedIndexPath];
    //        [cell setEditing:NO animated:YES];
    //    }
    //
    WMImageUploadItem *cell = (WMImageUploadItem*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.editing = YES;
    self.editedIndexPath = indexPath;
}

- (BOOL)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row < self.infos.count;
}

- (BOOL)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout canMoveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    return toIndexPath.row < self.infos.count;
}

#pragma mark- UICollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return (_infos.count >= _maxCount ? self.infos.count : (self.infos.count + 1));
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < _infos.count)
    {
        WMImageUploadItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"WMImageUploadItem" forIndexPath:indexPath];
        item.delegate = self;
        
        WMImageUploadInfo *info = [_infos objectAtIndex:indexPath.row];
        if(info.imageInfo.image)
        {
            [item.imageView sea_setImageWithURL:nil];
            item.imageView.image = info.imageInfo.image;
        }
        else
        {
            [item.imageView sea_setImageWithURL:info.imageInfo.imageURL];
        }
        item.editing = NO;
        
        // item.deleteButton.hidden = ![self.editedIndexPath isEqual:indexPath];
        item.progressView.openProgress = info.uploading;
        item.progressView.progress = info.progress;
        item.uploadFailButton.hidden = !info.uploadFail;
        
        return item;
    }
    else
    {
        WMImageUploadSelectedItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"WMImageUploadSelectedItem" forIndexPath:indexPath];
        
        ///判断是否已添加点击事件
        NSArray *actions = [item.addButton actionsForTarget:self forControlEvent:UIControlEventTouchUpInside];
        if(!actions && actions.count == 0)
        {
            [item.addButton addTarget:self action:@selector(addImage:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        return item;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.editedIndexPath)
    {
        //        WMImageUploadItem *item = (WMImageUploadItem*)[collectionView cellForItemAtIndexPath:self.editedIndexPath];
        //        [item setEditing:NO animated:YES];
        //        self.editedIndexPath = nil;
    }
}

#pragma mark- WMImageUploadItem delegate

///删除
- (void)imageUploadItemDidDelete:(WMImageUploadItem *)item
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:item];
    [self deleteImageForIndexPath:indexPath];
}

///上传失败
- (void)imageUploadItemDidUploadFail:(WMImageUploadItem *)item
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:item];
    if(self.editedIndexPath)
    {
        [self collectionView:self.collectionView didSelectItemAtIndexPath:indexPath];
    }
    else
    {
        self.selectedIndexPath = indexPath;
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"上传失败" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"重新上传", @"删除", nil];
        actionSheet.destructiveButtonIndex = 1;
        [actionSheet showInView:self.viewController.view];
    }
}

#pragma mark- UIActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"重新上传"])
    {
        [self uploadImageForIndex:self.selectedIndexPath.row];
        [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:self.selectedIndexPath]];
    }
    else if ([title isEqualToString:@"删除"])
    {
        [self deleteImageForIndexPath:self.selectedIndexPath];
    }
    else  if([title isEqualToString:@"拍照"])
    {
        [self camera];
    }
    else if([title isEqualToString:@"从手机相册选择"])
    {
        [self album];
    }
}

///删除图片
- (void)deleteImageForIndexPath:(NSIndexPath*) indexPath
{
    if([self.editedIndexPath isEqual:indexPath])
    {
        self.editedIndexPath = nil;
    }
    [self cancelUploadForIndex:indexPath.row];
    [self.infos removeObjectAtIndex:indexPath.row];
    [self.collectionView performBatchUpdates:^(void){
        
        [self.collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
        if(self.infos.count + 1 == _maxCount)
        {
            ///添加上传图片按钮
            [self.collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:self.infos.count inSection:0]]];
        }
    }completion:^(BOOL finish){
        
        if([self.delegate respondsToSelector:@selector(goodCommentImageUploadCellHeightDidChange:)])
        {
            [self layoutViews];
            [self.delegate goodCommentImageUploadCellHeightDidChange:self];
        }
    }];
}

///添加图片
- (void)addImage:(id) sender
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册选择", nil];
    [actionSheet showInView:self.viewController.view];
}

#pragma mark- 拍照

//拍照
- (void)camera
{
    if([UIImagePickerController canUseCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.viewController presentViewController:picker animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:NO completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if(image)
    {
        [self dealwithImages:[NSArray arrayWithObject:image]];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark- 相册

- (void)album
{
    ///点击添加图片
    SeaAlbumAssetsViewController *album = [[SeaAlbumAssetsViewController alloc] init];
    album.delegate = self;
    album.maxSelectedCount = (int)(_maxCount - _infos.count);
    album.target = SeaAlbumAssetsViewControllerTargetSelected;
    [album showInViewController:self.viewController animated:YES completion:nil];
}

#pragma mark- SeaAlbumAssetsViewController delegate

///相册图片选择完成
- (void)albumDidFinishSelectImages:(NSArray *)images
{
    [self dealwithImages:images];
}

///处理图片
- (void)dealwithImages:(NSArray*) images
{
    self.viewController.showNetworkActivity = YES;
    self.viewController.requesting = YES;
    
    WeakSelf(self);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        NSInteger index = weakSelf.infos.count;
        
        ///获取压缩的图片
        NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:images.count];
        for(UIImage *image in images)
        {
            NSLog(@"image scale %f", image.scale);
            NSLog(@"image %@", NSStringFromCGSize(image.size));
            
            UIImage *tmpImage = [image aspectFitthumbnailWithSize:weakSelf.maxImageSize];
            
            if(tmpImage)
            {
                [imageArray addObject:tmpImage];
            }
            
            NSLog(@"tmpImage scale %f", tmpImage.scale);
            NSLog(@"tmpImage %@", NSStringFromCGSize(tmpImage.size));
        }
        
        
        ///把图片写入临时文件
        NSDictionary *files = [SeaFileManager writeImages:imageArray inTemporaryFileWithCompressedScale:WMCommentImageScale];
        
        CGFloat size = (WMGoodCommentImageUploadCellMinHeight - WMGoodCommentAddCellMargin * 2);
        ///创建
        for(NSInteger i = 0;i < imageArray.count;i ++)
        {
            NSString *file = [files objectForKey:[NSNumber numberWithInteger:i]];
            if(file)
            {
                WMImageUploadInfo *info = [[WMImageUploadInfo alloc] init];
                info.imageInfo.locationImageURL = file;
                UIImage *image = [imageArray objectAtIndex:i];
                info.imageInfo.image = [image aspectFillThumbnailWithSize:CGSizeMake(size, size)];
                [weakSelf.infos addObject:info];
            }
        }
        
        dispatch_main_async_safe(^(void){
            
            weakSelf.viewController.showNetworkActivity = NO;
            weakSelf.viewController.requesting = NO;
            
            [weakSelf uploadFromIndex:index];
            
            [weakSelf.collectionView reloadData];
            
            if([weakSelf.delegate respondsToSelector:@selector(goodCommentImageUploadCellHeightDidChange:)])
            {
                [weakSelf layoutViews];
                [weakSelf.delegate goodCommentImageUploadCellHeightDidChange:weakSelf];
            }
        });
    });
}

#pragma mark- SeaNetworkQueue delegate

///上传进度条
- (void)networkQueue:(SeaNetworkQueue *)quque didUpdateUploadProgress:(float)progress downloadProgress:(float)downlodProgress identifier:(NSString *)identifier
{
    progress *= 0.98;
    NSInteger index = 0;
    WMImageUploadInfo *info = [self imageInfoForIdentifier:identifier index:&index];
    info.progress = progress;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    WMImageUploadItem *item = (WMImageUploadItem*)[self.collectionView cellForItemAtIndexPath:indexPath];
    item.progressView.progress = progress;
}

///上传失败
- (void)networkQueue:(SeaNetworkQueue *)quque requestDidFailWithError:(NSInteger)error identifier:(NSString *)identifier
{
    NSInteger index = 0;
    WMImageUploadInfo *info = [self imageInfoForIdentifier:identifier index:&index];
    info.progress = 0;
    info.uploadFail = YES;
    info.uploading = NO;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
}

///上传完成
- (void)networkQueue:(SeaNetworkQueue *)quque requestDidFinishWithData:(NSData *)data identifier:(NSString *)identifier
{
    NSInteger index = 0;
    WMImageUploadInfo *info = [self imageInfoForIdentifier:identifier index:&index];
    info.progress = 1.0;
    
    
    WMImageInfo *imageInfo = [WMCommentOperation uploadImageResultFromData:data];
    
    if(imageInfo)
    {
        info.imageInfo.imageId = imageInfo.imageId;
        info.imageInfo.imageURL = imageInfo.imageURL;
    }
    else
    {
        info.uploadFail = YES;
    }
    
    info.uploading = NO;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
}

- (void)networkQueueDidFinish:(SeaNetworkQueue *)queue
{
    
}

- (SeaNetworkQueue*)queue
{
    if(!_queue)
    {
        self.queue = [[SeaNetworkQueue alloc] initWithDelegate:self];
        self.queue.showRequestProgress = YES;
        self.queue.shouldCancelAllRequestWhenOneFail = NO;
    }
    
    return _queue;
}

///从某个位置开始上传图片
- (void)uploadFromIndex:(NSInteger) index;
{
    for(NSInteger i = index;i < self.infos.count;i ++)
    {
        [self uploadImageForIndex:i];
    }
}

///上传某个图片
- (void)uploadImageForIndex:(NSInteger) index
{
    WMImageUploadInfo *info = [self.infos objectAtIndex:index];
    
    info.uploadFail = NO;
    info.uploading = YES;
    [self.queue addRequestWithURL:SeaNetworkRequestURL param:[WMCommentOperation uploadImageParam] files:[NSArray arrayWithObject:info.imageInfo.locationImageURL] filesKey:WMUploadImageKey identifier:info.imageInfo.locationImageURL];
    [self.queue startDownload];
}

///取消上传
- (void)cancelUploadForIndex:(NSInteger) index
{
    WMImageUploadInfo *info = [self.infos objectAtIndex:index];
    if(info.imageInfo.locationImageURL)
    {
        [self.queue cancelRequestWithIdentifier:info.imageInfo.locationImageURL];
    }
}

///通过请求标识获取图片信息
- (WMImageUploadInfo*)imageInfoForIdentifier:(NSString*) identifier index:(NSInteger*) index
{
    WMImageUploadInfo *info = nil;
    
    NSInteger forIndex = 0;
    for(WMImageUploadInfo *tmp in self.infos)
    {
        if([tmp.imageInfo.locationImageURL isEqualToString:identifier])
        {
            info = tmp;
            break;
        }
        forIndex ++;
    }
    
    
    if(index != nil)
    {
        *index = forIndex;
    }
    
    return info;
}

@end

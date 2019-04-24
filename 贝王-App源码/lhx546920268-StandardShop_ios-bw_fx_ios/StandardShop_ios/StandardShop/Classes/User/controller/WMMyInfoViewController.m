//
//  WMMyInfoViewController.m
//  AKYP
//
//  Created by 罗海雄 on 15/11/25.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMMyInfoViewController.h"
#import "WMSettingInfo.h"
#import "WMSettingCell.h"
#import "WMUserInfo.h"
#import "WMUserInfoModifyController.h"
#import "WMUserOperation.h"
#import "SeaAlertController.h"
#import "WMAreaSelectViewController.h"
#import "UBPicker.h"
#import "WMShippingAddressOperation.h"
#import "WMShippingAddressInfo.h"
#import "WMSelectionViewController.h"
#import "WMBindPhoneNumberViewController.h"

@interface WMMyInfoViewController ()<SeaHttpRequestDelegate,WMAreaSelectViewControllerDelegate,UBPickerDelegate>

///我的资料信息，数组元素是 WMSettingInfo
@property(nonatomic,strong) NSArray *infos;

/**选中的cell
 */
@property(nonatomic,strong) NSIndexPath *selectedIndexPath;

///网络请求
@property(nonatomic,strong) SeaHttpRequest *httpRequest;

///新的所在地
@property(nonatomic,copy) NSString *modifyArea;

///新的生日
@property(nonatomic,copy) NSString *modifyBirthday;

///旧的选项 数组元素是NSString
@property(nonatomic,strong) NSMutableArray *selectedOptions;

///新的性别
@property(nonatomic,copy) NSString *sex;

/**正在上传的图片
 */
@property(nonatomic,strong) UIImage *uploadImage;

/**显示的图片大小
 */
@property(nonatomic,assign) CGSize imageSize;

/**正在上传的图片文件 数组元素是 文件路径 NSString
 */
@property(nonatomic,strong) NSArray *imageFiles;

/**生日选择
 */
@property(nonatomic,strong) UBPicker *picker;

@end

@implementation WMMyInfoViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

#pragma mark- life cycle

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.httpRequest = [[SeaHttpRequest alloc] initWithDelegate:self];
    
    self.backItem = YES;
    self.title = @"我的资料";
    
    [self reloadDataFromNetwork];
}

- (void)initialization
{
    self.style = UITableViewStyleGrouped;
    [super initialization];
    
    self.tableView.backgroundColor = _SeaViewControllerBackgroundColor_;
    self.tableView.rowHeight = 45.0;
    
    ///个人资料改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoDidModify:) name:WMUserInfoDidModifyNotification object:nil];

    ///重新登录成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin:) name:WMLoginSuccessNotification object:nil];
}

#pragma mark- 通知

//修个用户信息完成
- (void)userInfoDidModify:(NSNotification*) notification
{
    if([notification.object isEqual:self])
        return;

    [self.tableView reloadData];
}

///重新登录成功
- (void)userDidLogin:(NSNotification*) notification
{
    if(!self.tableView)
    {
        [self reloadDataFromNetwork];
    }
}

#pragma mark- UITableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _infos.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMSettingInfo *info = [self.infos objectAtIndex:indexPath.row];
    
    UIFont *font = WMSettingCellFont;
    CGFloat y = (WMSettingCellHeight - font.lineHeight) / 2.0;
    
    return info.contentHeight + y * 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMSettingInfo *info = [self.infos objectAtIndex:indexPath.row];
    
    switch (info.cellType)
    {
        case WMSettingCellTypeHeadImage :
        {
            static NSString *cellIdentifier = @"headImage";
            WMSettingHeadImageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if(cell == nil)
            {
                cell = [[WMSettingHeadImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }

            self.imageSize = cell.headImageView.bounds.size;
            cell.titleLabel.text = info.title;
            [cell.headImageView sea_setImageWithURL:info.content];
            
            return cell;
        }
            break;
        case WMSettingCellTypeTitleContent :
        {
            static NSString *cellIdentifier = @"titleContent";
            WMSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if(cell == nil)
            {
                cell = [[WMSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            
            cell.titleLabel.text = info.title;
            cell.titleWidth = info.titleWidth;
            cell.contentHeight = info.contentHeight;
            
            ///分销用户昵称加上前缀
            if(info.type == WMSettingTypeName && ![NSString isEmpty:info.content] && [WMUserInfo sharedUserInfo].personCenterInfo.openFenxiao && ![NSString isEmpty:[WMUserInfo sharedUserInfo].namePrefix])
            {
                cell.contentLabel.text = [NSString stringWithFormat:@"%@%@", [WMUserInfo sharedUserInfo].namePrefix, info.content];
            }
            else
            {
                cell.contentLabel.text = info.content;
            }

            if(info.selectable)
            {
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                cell.arrowImageView.hidden = NO;
            }
            else
            {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.arrowImageView.hidden = YES;
            }
            
            return cell;
        }
            break;
        default :
            break;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.selectedIndexPath = indexPath;
    WMSettingInfo *info = [self.infos objectAtIndex:indexPath.row];
    if(!info.selectable)
        return;
    
    switch (info.type)
    {
        case WMSettingTypeOther :
        {
            switch (info.contentType)
            {
                case WMSettingContentTypeArea :
                {
                    WMAreaSelectViewController *area = [[WMAreaSelectViewController alloc] init];
                    area.delegate = self;
                    area.rootViewController = self;
                    [self.navigationController pushViewController:area animated:YES];
                }
                    break;
                case WMSettingContentTypeDate :
                {
                    [self pickerBirthday];
                }
                    break;
                case WMSettingContentTypeMultipleSelection :
                case WMSettingContentTypeRadio :
                {
                    WMSelectionViewController *selection = [[WMSelectionViewController alloc] init];
                    selection.options = info.options;
                    selection.selectedOptions = info.selectedOptions;
                    selection.allowsMultipleSelection = info.contentType == WMSettingContentTypeMultipleSelection;
                    selection.title = info.title;

                    WeakSelf(self);
                    selection.completionHandler = ^(NSMutableArray *selectedOptions){

                        weakSelf.selectedOptions = [info.selectedOptions mutableCopy];
                        info.selectedOptions = selectedOptions;
                        NSString *content = info.selectedOptionsString;
                        ///内容改变
                        if(![content isEqualToString:info.content])
                        {
                            weakSelf.httpRequest.identifier = WMModifyUserInfoIdentifier;
                            weakSelf.showNetworkActivity = YES;
                            weakSelf.requesting = YES;

                            NSMutableDictionary *dic = nil;

                            ///多选
                            if(info.contentType == WMSettingContentTypeMultipleSelection)
                            {
                                dic = [NSMutableDictionary dictionaryWithCapacity:info.selectedOptions.count];
                                for(int i = 0;i < info.selectedOptions.count;i ++)
                                {
                                    NSString *str  = [info.selectedOptions objectAtIndex:i];
                                    [dic setObject:str forKey:[NSString stringWithFormat:@"%@[%d]", info.key, i]];
                                }

                                if(info.selectedOptions.count == 0)
                                {
                                    [dic setObject:@"" forKey:info.key];
                                }
                            }
                            else
                            {
                                ///单选
                                dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:content, info.key, nil];
                            }

                            [weakSelf.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMUserOperation modifyUserInfoParamWithDictionary:dic]];
                        }
                    };
                    [self.navigationController pushViewController:selection animated:YES];
                }
                    break;
                case WMSettingContentTypeLetter :
                case WMSettingContentTypeNumber :
                case WMSettingContentTypeTextUnlimited :
                case WMSettingContentTypeLetterAndNumber :
                {
                    WMUserInfoModifyController *modify = [[WMUserInfoModifyController alloc] init];
                    modify.settingInfo = info;
                    [self.navigationController pushViewController:modify animated:YES];
                }
                    break;
                case WMSettingContentTypeImage :
                {
                    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册选择", nil];
                    [actionSheet showInView:self.view];
                }
                    break;
            }
        }
            break;
        case WMSettingTypeName :
        case WMSettingTypeAccount :
        {
            WMUserInfoModifyController *modify = [[WMUserInfoModifyController alloc] init];
            modify.settingInfo = info;
            [self.navigationController pushViewController:modify animated:YES];
        }
            break;
        case WMSettingTypeHeadImage :
        {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册选择", nil];
            [actionSheet showInView:self.view];
        }
            break;
        case WMSettingTypeSex :
        {
            
            SeaAlertController *alertController = [[SeaAlertController alloc] initWithTitle:@"性别选择" message:nil style:SeaAlertControllerStyleAlert cancelButtonTitle:nil otherButtonTitles:@"男", @"女", nil];
            alertController.titleTextColor = MainGrayColor;
            alertController.titleFont = [UIFont fontWithName:MainFontName size:16.0];
            alertController.buttonTextColor = alertController.titleTextColor;
            alertController.butttonFont = alertController.titleFont;
            
            WeakSelf(self);
            alertController.selectionHandler = ^(NSInteger index){
                
                [weakSelf handleSelectedSexResult:index];
            };
            [alertController show];
        }
            break;
        case WMSettingTypePhoneNumber :
        {
            WMBindPhoneNumberViewController *phone = [[WMBindPhoneNumberViewController alloc] init];
            phone.settingInfo = info;
            [self.navigationController pushViewController:phone animated:YES];
        }
            break;
        default:
            break;
    }
}

///处理性别选择结果
- (void)handleSelectedSexResult:(NSInteger) index
{
    switch (index)
    {
        case 0 :
        {
            self.sex = WMUserInfoBoy;
        }
            break;
        case 1 :
        {
            self.sex = WMUserInfoGirl;
        }
            break;
        default:
            break;
    }

    WMSettingInfo *info = [self.infos objectAtIndex:self.selectedIndexPath.row];
    NSString *sex = [WMUserInfo sexStringForKey:self.sex];
    
    if([sex isEqualToString:info.content])
        return;

    self.showNetworkActivity = YES;
    self.requesting = YES;

    self.httpRequest.identifier = WMModifyUserInfoIdentifier;
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMUserOperation modifyUserInfoParamWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:self.sex, info.key, nil]]];
}

#pragma mark- UIActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"拍照"])
    {
        [self camera];
    }
    else if([title isEqualToString:@"从手机相册选择"])
    {
        [self album];
    }
    else if ([title isEqualToString:@"退出账号"])
    {
        self.requesting = YES;
        self.showNetworkActivity = YES;
        
        self.httpRequest.identifier = WMLogoutIdentifier;
        [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMUserOperation logoutParams]];
    }
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
        [self.navigationController presentViewController:picker animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:NO completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    WMSettingInfo *settingInfo = [self.infos objectAtIndex:self.selectedIndexPath.row];

    if(settingInfo.type == WMSettingTypeHeadImage)
    {
        SeaImageCropSettings *settings = [[SeaImageCropSettings alloc] init];
        settings.image = image;
        settings.cropSize = CGSizeMake(WMHeadImageSize, WMHeadImageSize);

        SeaImageCropViewController *imageCrop = [[SeaImageCropViewController alloc] initWithSettings:settings];
        imageCrop.delegate = self;
        [self.navigationController pushViewController:imageCrop animated:YES];
    }
    else
    {
        image = [image aspectFitthumbnailWithSize:CGSizeMake(1024, 1024)];

        self.imageFiles = [SeaFileManager writeImageInTemporaryFile:[NSArray arrayWithObject:image] withCompressedScale:0.9];
        self.uploadImage = image;

        [self uploadSelectedImage];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark- 相册

- (void)album
{
    WMSettingInfo *settingInfo = [self.infos objectAtIndex:self.selectedIndexPath.row];
    SeaAlbumAssetsViewController *album = [[SeaAlbumAssetsViewController alloc] init];
    album.delegate = self;
    album.maxSelectedCount = 1;
    if(settingInfo.type == WMSettingTypeHeadImage)
    {
        album.target = SeaAlbumAssetsViewControllerHeadImage;
    }
    [album showInViewController:self animated:YES completion:nil];
}

#pragma mark- SeaAlbumDelegate

- (void)albumDidFinishSelectImages:(NSArray *)images
{
    
    UIImage *image = [images firstObject];
    WMSettingInfo *settingInfo = [self.infos objectAtIndex:self.selectedIndexPath.row];
    if(settingInfo.type != WMSettingTypeHeadImage)
    {
        image = [image aspectFitthumbnailWithSize:CGSizeMake(1024, 1024)];
    }

    self.imageFiles = [SeaFileManager writeImageInTemporaryFile:images withCompressedScale:0.9];
    self.uploadImage = image;

    [self uploadSelectedImage];
}

///上传图片
- (void)uploadSelectedImage
{
    self.requesting = YES;
    self.showNetworkActivity = YES;
    WMSettingInfo *settingInfo = [self.infos objectAtIndex:self.selectedIndexPath.row];

    self.httpRequest.identifier = WMUploadImageIdentifier;
    
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL paraDic:[WMUserOperation uploadImageParams] files:self.imageFiles filesKey:settingInfo.key];
}

#pragma mark- WMAreaSelectViewController delegate

- (void)areaSelectViewController:(WMAreaSelectViewController *)view didSelectArea:(NSString *)area
{
    WMSettingInfo *settingInfo = [self.infos objectAtIndex:self.selectedIndexPath.row];
    if(![area isEqualToString:settingInfo.content])
    {
        self.modifyArea = area;
        self.requesting = YES;
        self.showNetworkActivity = YES;

        NSString *value = [WMShippingAddressOperation combineAreaParamFromInfos:view.selectedInfos];

        self.httpRequest.identifier = WMModifyUserInfoIdentifier;
        [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMUserOperation modifyUserInfoParamWithDictionary:[NSDictionary dictionaryWithObject:value forKey:settingInfo.key]]];
    }
}

#pragma mark- http

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
    self.showNetworkActivity = NO;
    self.requesting = NO;
    
    if([request.identifier isEqualToString:WMModifyUserInfoIdentifier] || [request.identifier isEqualToString:WMUploadImageIdentifier])
    {
        WMSettingInfo *info = [self.infos objectAtIndex:self.selectedIndexPath.row];
        [self alerBadNetworkMsg:[NSString stringWithFormat:@"修改%@失败", info.title]];

        switch (info.contentType)
        {
            case WMSettingContentTypeMultipleSelection :
            case WMSettingContentTypeRadio :
            {
                info.selectedOptions = self.selectedOptions;
            }
                break;
                
            default:
                break;
        }

        return;
    }


    if([request.identifier isEqualToString:WMEditableUserInfoIdentifier])
    {
        [self failToLoadData];
        return;
    }
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{
    self.showNetworkActivity = NO;
    self.requesting = NO;
    
    if([request.identifier isEqualToString:WMModifyUserInfoIdentifier])
    {
        if([WMUserOperation modifyUserInfoResultFromData:data])
        {
            WMSettingInfo *info = [self.infos objectAtIndex:self.selectedIndexPath.row];
            
            switch (info.type)
            {
                case WMSettingTypeSex :
                {
                    info.content = [WMUserInfo sexStringForKey:self.sex];
                }
                    break;
                case WMSettingTypeOther :
                {
                    switch (info.contentType)
                    {
                        case WMSettingContentTypeArea :
                        {
                            info.content = self.modifyArea;
                        }
                            break;
                        case WMSettingContentTypeDate :
                        {
                            info.content = self.modifyBirthday;
                        }
                            break;
                        case WMSettingContentTypeRadio :
                        case WMSettingContentTypeMultipleSelection :
                        {
                            info.content = info.selectedOptionsString;
                        }
                            break;
                        default:
                            break;
                    }
                }
                    break;
                default:
                    break;
            }
            
            [self userInfoDidChange];
        }
        else
        {
            WMSettingInfo *info = [self.infos objectAtIndex:self.selectedIndexPath.row];
            [self alertMsg:[NSString stringWithFormat:@"修改%@失败", info.title]];
        }
        
        return;
    }
    
    if([request.identifier isEqualToString:WMUploadImageIdentifier])
    {
        NSString *url = [WMUserOperation uploadImageResultFromData:data];
        if(url)
        {
            WMSettingInfo *info = [self.infos objectAtIndex:self.selectedIndexPath.row];
            [[SeaImageCacheTool sharedInstance] cacheImage:self.uploadImage withURL:url thumbnailSize:self.imageSize saveToMemory:YES];

            info.content = url;
            info.contentHeight = WMSettingHeadImageCellHeight;
            
            if(info.type == WMSettingTypeHeadImage)
            {
                WMUserInfo *userInfo = [WMUserInfo sharedUserInfo];
                userInfo.headImageURL = url;

                [userInfo saveUserInfoToUserDefaults];
            }

            [self userInfoDidChange];
        }
        
        return;
    }

    if([request.identifier isEqualToString:WMEditableUserInfoIdentifier])
    {
        self.loading = NO;
        NSArray *infos = [WMUserOperation editableUserInfoFromData:data];
        if(infos)
        {
            self.infos = infos;
            [self initialization];
        }
        else
        {
            [self failToLoadData];
        }
    }
}

- (void)reloadDataFromNetwork
{
    self.loading = YES;
    self.httpRequest.identifier = WMEditableUserInfoIdentifier;
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMUserOperation editableUserInfoParams]];
}

#pragma mark- UBPicker

///选择生日
- (void)pickerBirthday
{
    self.picker = [[UBPicker alloc] initWithSuperView:self.view style:UBPickerStyleBirthDay];

    WMSettingInfo *info = [self.infos objectAtIndex:self.selectedIndexPath.row];

    NSDate *date = nil;
    if(info.content)
    {
        date = [NSDate dateFromString:info.content format:DateFromatYMd];
    }
    
    if(!date)
    {
        date = [NSDate dateWithTimeIntervalSinceNow:- 365 * 24 * 60 * 60 * 16];
    }
    
    self.picker.datePicker.date = date;
    
    self.picker.delegate = self;
    [self.picker showWithAnimated:YES completion:nil];
}

- (void)picker:(UBPicker *)picker didFinisedWithConditions:(NSDictionary *)conditions
{
    NSString *birthday = [conditions objectForKey:@(picker.style)];

    WMSettingInfo *info = [self.infos objectAtIndex:self.selectedIndexPath.row];
    if(![birthday isEqualToString:info.content])
    {
        self.modifyBirthday = birthday;
        self.requesting = YES;
        self.showNetworkActivity = YES;

        WMSettingInfo *info = [self.infos objectAtIndex:self.selectedIndexPath.row];
        self.httpRequest.identifier = WMModifyUserInfoIdentifier;
        [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMUserOperation modifyUserInfoParamWithDictionary:[NSDictionary dictionaryWithObject:birthday forKey:info.key]]];
    }
}

///用户信息改变
- (void)userInfoDidChange
{
    [[NSNotificationCenter defaultCenter] postNotificationName:WMUserInfoDidModifyNotification object:nil];

    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:self.selectedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

@end

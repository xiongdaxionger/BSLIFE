//
//  WMShareActionSheet.h
//  WestMailDutyFee
//
//  Created by 罗海雄 on 15/8/28.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMShareActionSheet,
SeaViewController,
WMGoodInfo,
WMIntegralSignInInfo,
WMFoundListInfo,
WMDistributionInfo,
WMCollegeInfo,
WMCollectMoneyInfo;

/**分享弹窗子视图
 */
@interface WMShareActionSheetCell : UICollectionViewCell

/**图标
 */
@property(nonatomic,readonly) UIImageView *iconImageView;

/**标题
 */
@property(nonatomic,readonly) UILabel *titleLabel;

@end

/**分享类型
 */
typedef NS_ENUM(NSInteger, WMShareType)
{
    ///商品H5 链接
    WMShareTypeGoodH5 = 0,
    
    ///积分签到
    WMShareTypeIntegralSignIn,

    ///发现文章
    WMShareTypeFound,

    ///分销推广
    WMShareTypePromote,

    ///学院
    WMShareTypeCollege,
    
    ///邀请注册
    WMShareTypeInviteRegister,
    
    ///收钱
    WMShareTypeCollectMoney,
    
    ///添加会员
    WMShareTypeAddPartner,
};

/**分享方式
 */
typedef NS_ENUM(NSInteger, WMShareWay)
{
    ///微信
    WMShareWayWeixin = 0,
    
    ///微信朋友圈
    WMShareWayWeixinTimeline,
    
    ///QQ
    WMShareWayQQ,
    
    ///qq空间
    WMShareWayQQZone,
    
    ///新浪微博
    WMShareWaySina,

    ///发短信
    WMShareWaySendShortMsg,
    
    ///复制链接
    WMShareWayCopyLink,

    ///二维码
    WMShareWayQRCode,
};

/**分类内容视图
 */
@interface WMShareActionSheetContentView : UIView

/**商品信息，如果shareType = WMShareTypeGoodH5 时需要传
 */
@property(nonatomic,strong) WMGoodInfo *goodInfo;

/**收钱信息
 */
@property(nonatomic,strong) WMCollectMoneyInfo *collectMoneyInfo;

/**分享类型
 */
@property(nonatomic,assign) WMShareType shareType;

/**分享链接
 */
@property(nonatomic,copy) NSString *shareURL;

/**分享标题
 */
@property(nonatomic,copy) NSString *shareTitle;

/**分享内容
 */
@property(nonatomic,copy) NSString *shareContent;

///分销信息
@property(nonatomic,strong) WMDistributionInfo *distributionInfo;

///学院信息
@property(nonatomic,strong) WMCollegeInfo *collegeInfo;

/**签到信息
 */
@property(nonatomic,strong) WMIntegralSignInInfo *integralSignInInfo;

/**发现信息
 */
@property(nonatomic,strong) WMFoundListInfo *foundListInfo;

/**邀请注册二维码
 */
@property(nonatomic,strong) UIImage *inviteRegisterImage;

/**点击某个按钮分享
 */
@property(nonatomic,copy) void(^didShareHandler)(NSInteger index);

/**按钮标题
 */
@property(nonatomic,readonly) UIFont *titleFont;

/**跳转导航栏
 */
@property(nonatomic,weak) UINavigationController *navigationController;

@end

@protocol WMShareActionSheetDelegate <NSObject>

/**准备分享
 */
- (void)shareActionSheetWillShare:(WMShareActionSheet*) shareActionSheet;

/**分享完成
 */
- (void)shareActionSheetDidFinishShare:(WMShareActionSheet*) shareActionSheet;


@end

/**分享弹出
 */
@interface WMShareActionSheet : UIView

/**分享内容视图
 */
@property(nonatomic,readonly) WMShareActionSheetContentView *shareContentView;


/**显示
 */
- (void)show;

@end

//
//  base.h
//  Sea
//
//

#import "SeaUtlities.h"
#import "SeaUtilities.h"
#import "SeaViewControllerHeaders.h"
#import "SeaViewHeaders.h"
#import "SeaCacheCrash.h"
#import "SeaAlbumAssetsViewController.h"
#import "SeaImageCropViewController.h"
#import "SeaImageBrowser.h"
#import "SeaDetectVersion.h"
#import "SeaHttpRequest.h"
#import "SeaNetworkQueue.h"
#import "SeaFileManager.h"
#import "SeaImageCacheTool.h"
#import "SeaUserDefaults.h"
#import "ChineseToPinyin.h"
#import "SeaBasicInitialization.h"
#import "SeaPresentTransitionDelegate.h"
#import "SeaPartialPresentTransitionDelegate.h"

//基本信息头文件

#ifndef SeaBase_h
#define SeaBase_h

//发布(release)的项目不打印日志
#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#define SeaDebug 1
#else
#define NSLog(...) {}
#define SeaDebug 0
#endif


//不需要在主线程上使用 dispatch_get_main_queue
#define dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}


//获取当前系统版本
#define _ios11_0_ ([[UIDevice currentDevice].systemVersion floatValue] >= 11.0)
#define _ios10_0_ ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0)
#define _ios9_0_ ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0)
#define _ios8_0_ ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
#define _ios7_0_ ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
#define _ios6_1_ ([[UIDevice currentDevice].systemVersion floatValue] >= 6.1)
#define _ios6_0_ ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
#define _ios5_1_ ([[UIDevice currentDevice].systemVersion floatValue] >= 5.1)
#define _ios5_0_ ([[UIDevice currentDevice].systemVersion floatValue] >= 5.0)

//手机屏幕的宽度和高度
#define _width_ MIN([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)
#define _height_ MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width)


//工具条高度
#define _toolBarHeight_ 44.0

//视图主要背景颜色
#define _SeaViewControllerBackgroundColor_ [SeaBasicInitialization sea_backgroundColor]

/**按钮背景颜色
 */
#define WMButtonBackgroundColor [SeaBasicInitialization sea_buttonBackgroundColor]

/**不能点击的按钮背景颜色
 */
#define WMButtonDisableBackgroundColor [UIColor colorWithWhite:0.90 alpha:1.0]

//app主色调
#define _appMainColor_ [SeaBasicInitialization sea_appMainColor]

//导航栏背景颜色
#define _navigationBarBackgroundColor_ [SeaBasicInitialization sea_navigationBarColor]

///状态栏样式
#define WMStatusBarStyle [SeaBasicInitialization sea_statusBarStyle]

///导航栏tintColor
#define WMTintColor [SeaBasicInitialization sea_tintColor]

///按钮标题颜色
#define WMButtonTitleColor [SeaBasicInitialization sea_buttonTitleColor]

//网络状态不好加载数据失败提示信息
#define _alertMsgWhenBadNetwork_ [SeaBasicInitialization sea_alertMsgWhenBadNetwork]

//分割线颜色
#define _separatorLineColor_ [SeaBasicInitialization sea_separatorLineColor]
#define _separatorLineWidth_ [SeaBasicInitialization sea_separatorLineWidth]

//主要字体名称
#define MainFontName [SeaBasicInitialization sea_mainFontName]

//数字字体、英文字体
#define MainNumberFontName [SeaBasicInitialization sea_mainNumberFontName]

///主题红色
#define WMRedColor [UIColor colorFromHexadecimal:@"f73030"]
//主题黄色
#define WMYellowColor [UIColor colorWithRed:251.0 / 255.0 green:182.0 / 255.0 blue:43.0 / 255.0 alpha:1.0]

//主要字体颜色
#define MainLightGrayColor [UIColor colorWithRed:153.0 / 255.0 green:153.0 / 255.0 blue:153.0 / 255.0 alpha:1.0] ///#999999
#define MainDeepGrayColor [UIColor colorWithRed:51.0 / 255.0 green:51.0 / 255.0 blue:51.0 / 255.0 alpha:1.0] ///#333333
#define MainGrayColor [SeaBasicInitialization sea_mainTextColor]///#666666
#define MainTextColor MainGrayColor

//灰色背景颜色
#define MainDefaultBackColor [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0]

//字体大小
#define MainFontSize22 (25.0 / 3.0) ///22号字体
#define MainFontSize30 (33.0 / 3.0) ///30号字体
#define MainFontSize34 (37.0 / 3.0) ///34号字体
#define MainFontSize36 (39.0 / 3.0) ///36号字体
#define MainFontSize46 (49.0 / 3.0) ///46号字体
#define MainFontSize40 (43.0 / 3.0) ///40号字体
#define MainFontSize50 (53.0 / 3.0) ///50号字体
#define MainFontSize56 (59 / 3.0) ///56号字体

//设计稿比例
#define WMDesignScale (_width_ / 414.0)


/**域名
 */
static NSString *const SeaNetworkDomainName = @"www.ibwang.cn";

/**所有网络请求的路径
 */
static NSString *const SeaNetworkRequestURL = @"http://www.ibwang.cn/index.php/mobile/";

/**网络请求签名token
 */
static NSString *const SeaNetworkECStoreSignatureToken = @"c04b237488bfa8680f9bc99ede8f7c6e0684ba336b0733c6d13b037d52e615b0";

//c04b237488bfa8680f9bc99ede8f7c6e0684ba336b0733c6d13b037d52e615b0 www.ibwang.cn 贝王商城
//054f46cfc94e1600241052f022af21bbe15551488b9eb5347b27c404740d9ec0 www.huangjiamuai.com 皇家母爱

#endif

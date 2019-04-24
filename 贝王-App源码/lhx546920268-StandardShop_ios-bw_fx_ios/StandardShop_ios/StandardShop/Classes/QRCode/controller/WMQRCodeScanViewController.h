//
//  WMQRCodeScanViewController.h
//  WestMailDutyFee
//
//  Created by 罗海雄 on 15/8/26.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "SeaViewController.h"

/**扫描类型
 */
typedef NS_ENUM(NSInteger, WMCodeScaneType)
{
    ///所有
    WMCodeScaneTypeAll = 0,
    
    ///只是二维码
    WMCodeScaneTypeQRCode = 1,
    
    ///条形码
    WMCodeScaneTypeBarCode = 2,
};

/**二维码扫描
 */
@interface WMQRCodeScanViewController : SeaViewController

///类型 default is 'WMCodeScaneTypeQRCode'
@property(nonatomic,assign) WMCodeScaneType type;

///扫描结果回调
@property(nonatomic,copy) void(^codeScanHandler)(NSString *result);

@end

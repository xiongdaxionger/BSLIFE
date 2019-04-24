//
//  WMGoodInterface.h
//  WestMailDutyFee
//
//  Created by 罗海雄 on 15/9/14.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

///有关商品的宏定义

#ifndef WestMailDutyFee_WMGoodInterface_h
#define WestMailDutyFee_WMGoodInterface_h

/**商品收藏通知 userInfo 有两个值， key 为 WMGoodCollectStatus，值是 bool， key 为 WMGoodOperationGoodId，值是商品Id NSString
 */
#define WMGoodCollectDidChangeNotification @"WMGoodCollectDidChangeNotification"

/**收藏状态 bool
 */
#define WMGoodCollectStatus @"status"

/**商品id
 */
#define WMGoodOperationGoodId @"goodId"

//商品图片信息
#define WMBigImageURL @"big_url" //大图
#define WMSmallImageURL @"thisuasm_url" //小图
#define WMMidImageURL @"small_url" //中图
#define WMImageArray @"item_imgs" //商品图片数组，数组元素是 NSDictionary
#define WMGoodRectImageURL @"ipad_image_url" //商品长方形图

//商品限时特卖
#define WMGoodPromotionTypeValue 2
#define WMGoodPromotionType @"type_id"

#define WMHomeDialogTime @"dialog_time"


#endif

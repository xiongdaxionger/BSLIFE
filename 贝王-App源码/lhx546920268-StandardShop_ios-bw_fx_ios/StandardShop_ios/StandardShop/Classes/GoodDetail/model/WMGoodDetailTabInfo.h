//
//  WMGoodDetailTabInfo.h
//  StandardShop
//
//  Created by mac on 16/6/6.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

//图文详情自定义标签类型
typedef NS_ENUM(NSInteger, GoodGraphicDetailType){
    
    //图文详情--显示web
    GoodGraphicDetailTypeWeb = 0,
    
    //规格参数
    GoodGraphicDetailTypeParam = 1,
    
    //销售记录
    GoodGraphicDetailTypeSellLog = 2,
};
/**商品详情的Tab信息
 */
@interface WMGoodDetailTabInfo : NSObject
/**名称
 */
@property (copy,nonatomic) NSString *tabName;
/**内容
 */
@property (copy,nonatomic) NSString *tabContent;
/**类型
 */
@property (assign,nonatomic) GoodGraphicDetailType type;
/**图文详情的高度
 */
@property (assign,nonatomic) CGFloat graphicHeight;
/**批量初始化
 */
+ (NSArray *)returnGoodTabInfoArrWithDictArr:(NSArray *)arr;
@end

//
//  WMHomeViewController.h
//  MoblieFX
//
//  Created by 罗海雄 on 15/11/13.
//  Copyright © 2015年 qianseit. All rights reserved.
//

/**首页
 */
@interface WMHomeViewController : SeaCollectionViewController<UISearchBarDelegate>

///首页信息，数组元素是 WMHomeInfo
@property(nonatomic,strong) NSMutableArray *infos;

///获取秒杀图面
+ (NSString*)secondKillImageURL;

@end

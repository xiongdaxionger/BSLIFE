//
//  WMAddressSelectViewController.h
//  WuMei
//
//  Created by 罗海雄 on 15/7/22.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

@class WMAreaInfo, WMAreaSelectViewController;

@protocol WMAreaSelectViewControllerDelegate <NSObject>

@optional

/**选中某个地区组合，省市区组合
 */
- (void)areaSelectViewController:(WMAreaSelectViewController*) view didSelectArea:(NSString*) area;

@end

/** 省份，市、区 选择
 */
@interface WMAreaSelectViewController : SeaTableViewController

/**已选得地区信息 数组元素是  WMAreaInfo
 */
@property(nonatomic,strong) NSMutableArray *selectedInfos;

/**层级
 */
@property(nonatomic,assign) int level;

/**地区信息 数组元素是  WMAreaInfo
 */
@property(nonatomic,strong) NSMutableArray *infos;

/**root 地址选择完成后会回到的ViewController
 */
@property(nonatomic,weak) UIViewController *rootViewController;

@property(nonatomic,weak) id<WMAreaSelectViewControllerDelegate> delegate;

@end

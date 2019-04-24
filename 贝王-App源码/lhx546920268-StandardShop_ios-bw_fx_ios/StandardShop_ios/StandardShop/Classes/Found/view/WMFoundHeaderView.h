//
//  WMFoundHeaderView.h
//  WanShoes
//
//  Created by 罗海雄 on 16/3/22.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMFoundHeaderView, WMFoundCategoryInfo;

///发现表头代理
@protocol WMFoundHeaderViewDelegate <NSObject>

///点击某个
- (void)foundHeaderView:(WMFoundHeaderView*) view didSelctedCategoryInfo:(WMFoundCategoryInfo*) info;

@end

///发现表头
@interface WMFoundHeaderView : UIView

@property (weak, nonatomic) id<WMFoundHeaderViewDelegate> delegate;

///类目信息，数组元素是 WMFoundCategoryInfo
@property (strong, nonatomic) NSArray *infos;


@end

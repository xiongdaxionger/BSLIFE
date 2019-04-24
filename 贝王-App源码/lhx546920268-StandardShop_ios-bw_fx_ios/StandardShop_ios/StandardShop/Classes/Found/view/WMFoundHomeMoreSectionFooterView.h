//
//  WMFoundHomeMoreSectionFooterView.h
//  SuYan
//
//  Created by 罗海雄 on 16/4/29.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMFoundHomeMoreSectionFooterView;

///大小
#define WMFoundHomeMoreSectionFooterViewSize CGSizeMake(_width_, 45.0)

///查看更多代理
@protocol WMFoundHomeMoreSectionFooterViewDelegate <NSObject>

///查看更多
- (void)foundHomeMoreSectionFooterViewDidTapMore:(WMFoundHomeMoreSectionFooterView*) view;

@end

///查看更多底部
@interface WMFoundHomeMoreSectionFooterView : UICollectionReusableView

///关联的section
@property(nonatomic,assign) NSInteger section;

///更多按钮
@property(nonatomic,readonly) UIButton *more_btn;

@property(nonatomic,weak) id<WMFoundHomeMoreSectionFooterViewDelegate> delegate;

@end

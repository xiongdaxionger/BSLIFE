//
//  WMGoodCommentScoreProgressView.h
//  StandardShop
//
//  Created by 罗海雄 on 16/6/28.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

///商品评价评分进度cell
@interface WMGoodCommentScoreProgressCell : UIView

///分数进度 0 ~ 1.0
@property(nonatomic,assign) float progress;

@end

///商品评价评分进度
@interface WMGoodCommentScoreProgressView : UIView

///评分 最大是5
@property(nonatomic,assign) float score;

@end

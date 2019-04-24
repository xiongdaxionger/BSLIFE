//
//  WMGoodCommentScoreView.h
//  StandardShop
//
//  Created by 罗海雄 on 16/6/2.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

///最大评分
#define WMGoodCommentScoreMax 5

///商品评分视图
@interface WMGoodCommentScoreView : UIView

///评分 最大是5
@property(nonatomic,assign) NSInteger score;

///是否可编辑 default is 'NO'
@property(nonatomic,assign) BOOL editable;

@end

//
//  WMHomeSectionFooterView.h
//  StandardShop
//
//  Created by 罗海雄 on 16/11/18.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

///高度
#define WMHomeSectionFooterViewHeight _separatorLineWidth_

///首页section底部
@interface WMHomeSectionFooterView : UICollectionReusableView

///分割线
@property (weak, nonatomic) IBOutlet UIView *line;
@end

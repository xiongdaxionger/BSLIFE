//
//  TypeCollectionViewCell.h
//  WuMei
//
//  Created by qsit on 15/7/30.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kTypeCollectionViewCellIden @"TypeCollectionViewCellIden"

///意见反馈类型
@interface WMFeedBackTypeCell : UICollectionViewCell

///类型名称
@property (weak, nonatomic) IBOutlet UILabel *typeContentLabel;

//勾选图片
@property (weak, nonatomic) IBOutlet UIImageView *selectImage;

- (void)configureWithInfo:(NSDictionary *)dict select:(BOOL)select;

@end

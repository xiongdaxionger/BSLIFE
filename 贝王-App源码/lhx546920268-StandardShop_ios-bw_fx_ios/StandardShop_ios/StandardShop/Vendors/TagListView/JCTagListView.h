//
//  JCTagListView.h
//  JCTagListView
//
//  Created by 李京城 on 15/7/3.
//  Copyright (c) 2015年 李京城. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JCTagCell.h"
typedef void (^JCTagListViewBlock)(NSInteger index);

@interface JCTagListView : UIView

@property (nonatomic, strong) UIColor *tagStrokeColor;// default: lightGrayColor

@property (nonatomic, strong) UIColor *tagTextColor;// default: darkGrayColor

@property (nonatomic, strong) UIColor *tagBackgroundColor;// default: clearColor

@property (nonatomic, strong) UIColor *tagSelectedBackgroundColor;// default: rgb(217,217,217)

@property (nonatomic, strong) UIColor *tagSelectedTextColor;// 默认白色

@property (nonatomic, assign) CGFloat tagCornerRadius;// default: 10

@property (nonatomic, assign) CGFloat sizeHeight; // 默认28.0

@property (nonatomic, assign) BOOL canSeletedTags;

@property (nonatomic, strong) NSArray *tags;

@property (nonatomic, assign) NSInteger lastSelectRow;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (assign,nonatomic) StyleType type;

- (void)setup;

- (void)setCompletionBlockWithSeleted:(JCTagListViewBlock)completionBlock;

@end

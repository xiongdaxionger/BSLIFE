//
//  FeedBackContentViewCell.h
//  WuMei
//
//  Created by qsit on 15/7/30.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//
#define kFeedBackContentViewCellHeight 257
#import <UIKit/UIKit.h>
#import "XTableCellConfigExDelegate.h"
#import "SeaTextView.h"

///意见反馈内容
@interface WMFeedBackContentCell : UITableViewCell<XTableCellConfigExDelegate>

///标题
@property (weak, nonatomic) IBOutlet UILabel *feedBackContentTitle;

///输入框
@property (weak, nonatomic) IBOutlet SeaTextView *contentTextView;

@end

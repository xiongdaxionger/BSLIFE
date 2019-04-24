//
//  WMMoreAdviceViewCell.m
//  StandardShop
//
//  Created by mac on 16/6/2.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMMoreAdviceViewCell.h"

#import "WMAdviceQuestionInfo.h"


@implementation WMMoreAdviceViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.moreLabel.font = [UIFont fontWithName:MainFontName size:15.0];
    
    self.moreLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMore)];
    
    [self.moreLabel addGestureRecognizer:tap];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


- (void)configureCellWithModel:(id)model{
    
    WMAdviceQuestionInfo *questionInfo = (WMAdviceQuestionInfo *)model;
    
    if (questionInfo.isShowMoreOpen) {
        
        self.moreLabel.text = @"点击收起";
    }
    else{
        
        self.moreLabel.text = @"点击查看更多";
    }
}

- (void)showMore{
    
    if (self.callBack) {
        
        self.callBack(self);
    }
}



















@end

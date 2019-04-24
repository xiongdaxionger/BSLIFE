//
//  TypeCollectionViewCell.m
//  WuMei
//
//  Created by qsit on 15/7/30.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "WMFeedBackTypeCell.h"


@implementation WMFeedBackTypeCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    _typeContentLabel.layer.cornerRadius = 5;
    
    _typeContentLabel.font = [UIFont fontWithName:MainFontName size:13];
    
    _typeContentLabel.textAlignment = NSTextAlignmentCenter;
    
    _typeContentLabel.backgroundColor = [UIColor whiteColor];
    
    _typeContentLabel.textColor = MainGrayColor;
}

- (void)configureWithInfo:(NSDictionary *)dict select:(BOOL)select{
    
    _typeContentLabel.text = [dict sea_stringForKey:@"name"];
    
    self.selectImage.hidden = !select;
    
    if (select) {
        
        [self.typeContentLabel makeBorderWidth:1.0 Color:WMRedColor CornerRadius:0.0];
    }
    else{
        
        [self.typeContentLabel makeBorderWidth:0.0 Color:[UIColor clearColor] CornerRadius:0.0];
    }
}



@end

//
//  JCTagCell.m
//  JCTagListView
//
//  Created by 李京城 on 15/7/3.
//  Copyright (c) 2015年 李京城. All rights reserved.
//

#import "JCTagCell.h"

@implementation JCTagCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
                
        self.layer.borderWidth = 1.0f;
        
        self.tagImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.cellHeight, self.cellHeight)];
        
        self.tagImage.image = [UIImage imageNamed:@"red_tick"];
        
        [self.contentView addSubview:self.tagImage];
        
        self.tagImage.hidden = (self.type == StyleTypeText);
        
        CGFloat width = (self.type == StyleTypeText) ? 0.0 : self.cellHeight;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(width, 0, self.bounds.size.width - width, self.cellHeight)];
        
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        self.titleLabel.textColor = [UIColor darkGrayColor];
        
        self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        
        [self.contentView addSubview:self.titleLabel];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = (self.type == StyleTypeText) ? 0.0 : self.cellHeight;
    
    self.tagImage.hidden = (self.type == StyleTypeText);
    
    self.tagImage.frame = CGRectMake(0, 0, self.cellHeight, self.cellHeight);
    
    self.titleLabel.frame = CGRectMake(width, 0, self.bounds.size.width - width, self.cellHeight);
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.titleLabel.text = @"";
}

@end

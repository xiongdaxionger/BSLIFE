//
//  WMCollegeTableViewCell.m
//  WestMailDutyFee
//
//  Created by YUYE on 15/8/31.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMCollegeTableViewCell.h"
#import "WMCollegeInfo.h"

@implementation WMCollegeTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.titleLabel.font = [UIFont fontWithName:MainFontName size:17.0];
    self.timeLabel.font = [UIFont fontWithName:MainFontName size:15];
    self.introductionLabel.font = [UIFont fontWithName:MainFontName size:15];
    self.readCollegeDetailBtn.titleLabel.font = [UIFont fontWithName:MainFontName size:15];
    
    CGFloat width = _width_ - 10.0 * 4;
    self.collegeIamgeView.sea_thumbnailSize = CGSizeMake(width, width / 2.0);
    self.collegeIamgeView.sea_originContentMode = UIViewContentModeScaleAspectFit;
    
    self.readCollegeDetailBtn.enabled = NO;
    [self.readCollegeDetailBtn addTarget:self action:@selector(readCollegeDetailAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setInfo:(WMCollegeInfo *)info
{
    if(_info != info)
    {
        _info = info;
        
        [self.titleLabel setText:info.title];
        
        [self.collegeIamgeView sea_setImageWithURL:info.iamgeUrlString];
        self.introductionLabel.text = info.introduction;
        self.intro_label_height_constraint.constant = info.introHeight;
        
        [self.timeLabel setText:info.pubtime];
    }
}

///查看详情
- (void)readCollegeDetailAction:(id) sender
{
    if([self.delegate respondsToSelector:@selector(collegeCellDidLookDetail:)])
    {
        [self.delegate collegeCellDidLookDetail:self];
    }
}

/**cell高度
 */
+ (CGFloat)rowHeightForInfo:(WMCollegeInfo*) college
{
    CGFloat width = _width_ - 10.0 * 4;
    if(college.introHeight == 0)
    {
        college.introHeight = [college.introduction stringSizeWithFont:[UIFont fontWithName:MainFontName size:15] contraintWith:width].height;
        college.introHeight = MIN(42, college.introHeight);
    }
    
    
    return 5.0 + 15 + 21 + 5 + 21 + 8 + width / 2.0 + 8.0 + college.introHeight  + 20.0 + 1.0 + 45.0 + 10.0;
}

@end

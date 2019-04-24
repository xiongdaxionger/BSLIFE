//
//  WMMessageConsultQuestionViewCell.m
//  StandardShop
//
//  Created by mac on 16/8/1.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMMessageConsultQuestionViewCell.h"

@implementation WMMessageConsultQuestionViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.contentLabel.layer.cornerRadius = 3.0;
    
    self.contentLabel.layer.masksToBounds = YES;
    
    self.qusetionContentLabel.font = [UIFont fontWithName:MainFontName size:15.0];
}

- (void)configureWithContentString:(NSString *)content{
    
    self.qusetionContentLabel.text = content;
}



@end

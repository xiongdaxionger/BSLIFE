//
//  WMRefundInfoViewCell.m
//  StandardFenXiao
//
//  Created by mac on 15/12/17.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import "WMRefundInfoViewCell.h"

#import "UITableViewCell+addLineForCell.h"

@implementation WMRefundInfoViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self addLineForBottomWithBottomFloat:self.infoTittle.bottom + 6.0];
    
    self.infoContent.font = [UIFont fontWithName:MainFontName size:13.0];
    
    self.infoTittle.font = [UIFont fontWithName:MainFontName size:13.0];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


- (void)configureCellWithModel:(id)model{
    
    id content = [model objectForKey:@"content"];
    
    if ([content isKindOfClass:[NSMutableAttributedString class]]) {
        
        self.infoContent.attributedText = (NSAttributedString *)content;
    }
    else{
        
        self.infoContent.text = formatStringPrice((NSString *)content);
    }

    self.infoTittle.text = [model objectForKey:@"title"];    
}

@end

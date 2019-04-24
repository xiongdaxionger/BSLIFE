//
//  WMShakingDialog.m
//  WanShoes
//
//  Created by 罗海雄 on 16/3/16.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMShakingDialog.h"

@implementation WMShakingDialog


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.act_view.hidesWhenStopped = YES;
    self.text_label.font = [UIFont fontWithName:MainFontName size:17.0];
    self.hidden = NO;
    _status = WMShakingStatusHidden;
}

- (void)setStatus:(WMShakingStatus)status
{
    _status = status;
    switch (_status)
    {
        case WMShakingStatusHidden :
        {
            self.hidden = YES;
            [self.act_view startAnimating];
        }
            break;
        case WMShakingStatusFail :
        {
            self.hidden = NO;
            [self.act_view stopAnimating];
            self.text_label_centerXLayoutConstraint.constant = 0;
            
            self.text_label.text = [NSString stringWithFormat:@"%@，请重试", _alertMsgWhenBadNetwork_];
        }
            break;
        case WMShakingStatusLoading :
        {
            self.hidden = NO;
            [self.act_view startAnimating];
            self.text_label_centerXLayoutConstraint.constant = -15.0;
            self.text_label.text = [NSString stringWithFormat:@"正在摇一摇..."];
        }
            break;
    }
}


@end

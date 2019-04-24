//
//  FeedBackContentViewCell.m
//  WuMei
//
//  Created by qsit on 15/7/30.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "WMFeedBackContentCell.h"
#import "UITableViewCell+addLineForCell.h"

#import "WMRefundMoneyDetailViewController.h"
#import "WMRefundGoodDetailViewController.h"

@interface WMFeedBackContentCell ()<UITextViewDelegate>
/**退款控制器
 */
@property (weak,nonatomic) WMRefundMoneyDetailViewController *moneyDetail;
/**退货控制器
 */
@property (weak,nonatomic) WMRefundGoodDetailViewController *goodDetail;
@end
@implementation WMFeedBackContentCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self addLineForTop];

    _contentTextView.layer.cornerRadius = 5;
    
    _contentTextView.layer.shadowColor = _separatorLineColor_.CGColor;
    
    _contentTextView.layer.shadowOffset = CGSizeMake(0, 2);
    
    _contentTextView.layer.shadowOpacity = 0.8;
    
    _contentTextView.placeholderFont = [UIFont fontWithName:MainFontName size:14];
    
    _contentTextView.returnKeyType = UIReturnKeyDone;
    
    _contentTextView.delegate = self;
        
    _contentTextView.maxCount = 200.0;
    
    _feedBackContentTitle.font = [UIFont fontWithName:MainFontName size:13];
}

- (void)configureCellWithModel:(id)model{

    if ([model isKindOfClass:[WMRefundMoneyDetailViewController class]]){
        
        _feedBackContentTitle.text = @"详细描述";
        
        _contentTextView.placeholder = @"请描述遇到的问题以及详细的退款理由，不超过200字";
        
        _moneyDetail = (WMRefundMoneyDetailViewController *)model;
    }
    else if ([model isKindOfClass:[WMRefundGoodDetailViewController class]]){
        
        _feedBackContentTitle.text = @"详细描述";
        
        _contentTextView.placeholder = @"请描述遇到的问题以及详细的退换理由，不超过200字";

        _goodDetail = (WMRefundGoodDetailViewController *)model;
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    
    if (_moneyDetail){
        
        _moneyDetail.detailReason = textView.text;
    }
    else if (_goodDetail){
        
        _goodDetail.detailReason = textView.text;
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    if (_goodDetail) {
        
        [_goodDetail.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
    else if (_moneyDetail){
        
        [_moneyDetail.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];

    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    [_contentTextView textDidChange];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    
    return [_contentTextView shouldChangeTextInRange:range replacementText:text];
}


@end

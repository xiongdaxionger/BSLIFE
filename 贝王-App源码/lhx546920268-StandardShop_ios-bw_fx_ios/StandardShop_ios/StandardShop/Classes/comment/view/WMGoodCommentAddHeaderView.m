//
//  WMGoodCommentAddHeaderView.m
//  StandardShop
//
//  Created by 罗海雄 on 16/6/29.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodCommentAddHeaderView.h"
#import "WMImageVerificationCodeView.h"
#import "WMGoodCommentScoreView.h"

@interface WMGoodCommentAddHeaderView ()<UITextViewDelegate>

@end

@implementation WMGoodCommentAddHeaderView

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, _width_, 85 + _separatorLineWidth_ + 80.0)];
    if(self)
    {
        self.backgroundColor = [UIColor whiteColor];

        CGFloat margin = 15.0;

        CGFloat height = 85.0;	
        _goodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(margin, margin, height - margin * 2, height - margin * 2)];
        _goodImageView.sea_originContentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_goodImageView];

        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_goodImageView.right + margin, _goodImageView.top, 70.0, _goodImageView.height)];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont fontWithName:MainFontName size:15.0];
        [self addSubview:_titleLabel];

        _scoreView = [[WMGoodCommentScoreView alloc] initWithFrame:CGRectMake(_titleLabel.right, _titleLabel.top + (_titleLabel.height - 20.0) / 2.0, 100.0, 20.0)];
        _scoreView.score = WMGoodCommentScoreMax;
        _scoreView.editable = YES;
        [self addSubview:_scoreView];

        ///分割线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _goodImageView.bottom + margin, self.width, _separatorLineWidth_)];
        line.backgroundColor = _separatorLineColor_;
        [self addSubview:line];

        ///输入框
        _textView = [[SeaTextView alloc] initWithFrame:CGRectMake(0, line.bottom, self.width, 80.0)];
        _textView.limitable = YES;
        _textView.delegate = self;
        _textView.maxCount = WMGoodCommentContentInputLimitMax;
        _textView.placeholder = @"请输入您对该商品的评价";
        _textView.font = [UIFont fontWithName:MainFontName size:15.0];
        [_textView setDefaultInputAccessoryViewWithTarget:self action:@selector(reconverKeyboard:)];
        [self addSubview:_textView];
    }

    return self;
}

///回收键盘
- (void)reconverKeyboard:(id) sender
{
    [self.textView resignFirstResponder];
}

/**需要图形验证码
 *@param codeURL 图形验证码链接
 */
- (void)addImageCode:(NSString*) codeURL
{
    ///分割线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _textView.bottom, self.width, _separatorLineWidth_)];
    line.backgroundColor = _separatorLineColor_;
    [self addSubview:line];

    _imageCodeView = [[WMImageVerificationCodeView alloc] initWithFrame:CGRectMake(0, line.bottom, self.width, 45.0)];
    _imageCodeView.codeURL = codeURL;
    _imageCodeView.textField.placeholder = @"请输入图形验证码";
    _imageCodeView.textField.font = _textView.font;
    _imageCodeView.textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8.0, _imageCodeView.height)];
    [self addSubview:_imageCodeView];

    self.height = _imageCodeView.bottom;
}


#pragma mark- UITextView delegate

- (void)textViewDidChange:(UITextView *)textView
{
    [self.textView textDidChange];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return [self.textView shouldChangeTextInRange:range replacementText:text];
}

@end

//
//  WMShippingAddressEditCell.m
//  WuMei
//
//  Created by 罗海雄 on 15/7/22.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "WMShippingAddressEditCell.h"

///字体
#define WMShippingAddressEditFont [UIFont fontWithName:MainFontName size:15.0]

//箭头宽度
#define WMShippingAddressEditCellArrowWdith  (22 * WMDesignScale)

@implementation WMShippingAddressEditSingleInputCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIFont *font = WMShippingAddressEditFont;
        UIColor *textColor = MainTextColor;
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = font;
        _titleLabel.textColor = textColor;
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleLabelTap:)];
        [_titleLabel addGestureRecognizer:tap];
        [self.contentView addSubview:_titleLabel];
        
        _textField = [[UITextField alloc] init];
        _textField.font = font;
        _textField.textColor = textColor;
        _textField.textAlignment = NSTextAlignmentLeft;
        _textField.translatesAutoresizingMaskIntoConstraints = NO;
        _textField.backgroundColor = [UIColor clearColor];
        [_textField setDefaultInputAccessoryViewWithTarget:self action:@selector(reconverKeyboard)];
        [self.contentView addSubview:_textField];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_titleLabel,_textField);
        
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-%f-[_titleLabel(85.0)]-0-[_textField]-%f-|", WMShippingAddressEditCellMargin, WMShippingAddressEditCellArrowWdith + WMShippingAddressEditCellMargin] options:0 metrics:nil views:views];
        [self.contentView addConstraints:constraints];
        
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[_titleLabel]-%f-|", WMShippingAddressEditCellMargin, WMShippingAddressEditCellMargin] options:0 metrics:nil views:views];
        [self.contentView addConstraints:constraints];
        
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-0-[_textField]-0-|"] options:0 metrics:nil views:views];
        [self.contentView addConstraints:constraints];
    }
    
    return self;
}
- (void)titleLabelTap:(UITapGestureRecognizer *)tap{
    
    [_textField becomeFirstResponder];
}

- (void)reconverKeyboard
{
    [_textField resignFirstResponder];
}

@end

@implementation WMShippingAddressEditMultiInputCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIFont *font = WMShippingAddressEditFont;
        UIColor *textColor = MainTextColor;
        
        CGFloat height = 44;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(WMShippingAddressEditCellMargin, 0, 80.0, 44)];
        _titleLabel.centerY = self.contentView.centerY;
        _titleLabel.font = font;
        _titleLabel.textColor = textColor;
//        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleLabelTapGes:)];
        [_titleLabel addGestureRecognizer:tap];
        [self.contentView addSubview:_titleLabel];
        
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(_titleLabel.right, 0, _width_ - _titleLabel.right - WMShippingAddressEditCellMargin - WMShippingAddressEditCellArrowWdith, height)];
        _textView.font = font;
        _textView.centerY = self.contentView.centerY;
        _textView.textColor = textColor;
        [_textView setDefaultInputAccessoryViewWithTarget:self action:@selector(reconverKeyboard)];
        [self.contentView addSubview:_textView];
    }
    
    return self;
}

- (void)reconverKeyboard
{
    [_textView resignFirstResponder];
}
- (void)titleLabelTapGes:(UITapGestureRecognizer *)tap{
    [_textView becomeFirstResponder];
}

@end

@implementation WMShippingAddressEditCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        
        
        UIFont *font = WMShippingAddressEditFont;
        UIColor *textColor = MainTextColor;
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = font;
        _titleLabel.textColor = textColor;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_titleLabel];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = font;
        _contentLabel.textAlignment = NSTextAlignmentRight;
        _contentLabel.textColor = textColor;
        _contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_contentLabel];
        
        UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_red"]];
        arrow.translatesAutoresizingMaskIntoConstraints = NO;
        arrow.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:arrow];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_titleLabel,_contentLabel,arrow);
        
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-%f-[_titleLabel(85.0)]-0-[_contentLabel]-5-[arrow(%f)]-%f-|", WMShippingAddressEditCellMargin, WMShippingAddressEditCellArrowWdith, WMShippingAddressEditCellMargin] options:0 metrics:nil views:views];
        [self.contentView addConstraints:constraints];
        
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[_titleLabel]-%f-|", WMShippingAddressEditCellMargin, WMShippingAddressEditCellMargin] options:0 metrics:nil views:views];
        [self.contentView addConstraints:constraints];
        
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[_contentLabel]-%f-|", WMShippingAddressEditCellMargin, WMShippingAddressEditCellMargin] options:0 metrics:nil views:views];
        [self.contentView addConstraints:constraints];
        
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[arrow]-%f-|", WMShippingAddressEditCellMargin, WMShippingAddressEditCellMargin] options:0 metrics:nil views:views];
        [self.contentView addConstraints:constraints];
    }
    
    return self;
}

@end

@implementation WMShippingAddressDefaultCell

- (instancetype)init
{
    return [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WMShippingAddressDefaultCell"];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        _defaultButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _defaultButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_defaultButton setImage:[WMImageInitialization untickIcon] forState:UIControlStateNormal];
        [_defaultButton setImage:[WMImageInitialization tickingIcon] forState:UIControlStateSelected];
        [_defaultButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_defaultButton setTitle:@" 设为默认收货地址" forState:UIControlStateNormal];
        [_defaultButton setTitleColor:MainTextColor forState:UIControlStateNormal];
        _defaultButton.titleLabel.font = WMShippingAddressEditFont;
        _defaultButton.userInteractionEnabled = NO;
        [self.contentView addSubview:_defaultButton];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_defaultButton);
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-%f-[_defaultButton]-%f-|", WMShippingAddressEditCellMargin, WMShippingAddressEditCellMargin] options:0 metrics:nil views:views];
        [self.contentView addConstraints:constraints];
        
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-0-[_defaultButton]-0-|"] options:0 metrics:nil views:views];
        [self.contentView addConstraints:constraints];
    }
    
    return self;
}

@end

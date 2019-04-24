//
//  WMNavigationBarRedPointButton.m
//  StandardShop
//
//  Created by 罗海雄 on 16/6/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMNavigationBarRedPointButton.h"

@implementation WMNavigationBarRedPointButton

/**构造方法
 *@param image 图标
 *@return 返回一个实例
 */
- (instancetype)initWithImage:(UIImage*) image
{
    self = [super initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    if(self)
    {
       
        ///ios7 的 imageAssets 不支持 Template
        if(image.renderingMode != UIImageRenderingModeAlwaysTemplate)
        {
            image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        }
        
        ///ios7 的 imageAssets 不支持 Template
        if(image.renderingMode != UIImageRenderingModeAlwaysTemplate)
        {
            image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        }
        
        [self setImage:image forState:UIControlStateNormal];

        CGFloat size = 5.0;
        _redPoint = [[UIView alloc] initWithFrame:CGRectMake(self.width - size, 0, size, size)];
        _redPoint.backgroundColor = [UIColor redColor];
        _redPoint.layer.cornerRadius = size / 2.0;
        _redPoint.layer.borderWidth = 1.0;
        _redPoint.userInteractionEnabled = NO;
        _redPoint.hidden = YES;
        [self addSubview:_redPoint];
        
        self.tintColor = WMTintColor;
    }

    return self;
}

- (void)setTintColor:(UIColor *)tintColor
{
    [super setTintColor:tintColor];
    
    if([tintColor isEqualToColor:[UIColor whiteColor]])
    {
        _redPoint.layer.borderColor = tintColor.CGColor;
        _redPoint.layer.borderWidth = 1.0;
    }
    else
    {
        _redPoint.layer.borderWidth = 0;
    }
}

@end

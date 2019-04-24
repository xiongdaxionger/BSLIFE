//
//  WMFilterCollectionImageViewCell.m
//  StandardFenXiao
//
//  Created by mac on 16/1/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMFilterCollectionImageViewCell.h"

#import "UIView+XQuickStyle.h"
@implementation WMFilterCollectionImageViewCell

- (void)awakeFromNib {
 
    [super awakeFromNib];
    self.brandImage.sea_placeHolderContentMode = UIViewContentModeScaleAspectFit;
    self.brandImage.sea_originContentMode = UIViewContentModeScaleAspectFit;
}

- (void)setSelectStatus:(BOOL)selectStatus{
    
    self.brandImage.layer.borderColor = WMButtonBackgroundColor.CGColor;
    
    self.brandImage.layer.borderWidth = selectStatus ? 1.0 : 0.0;
    
    self.brandImage.layer.masksToBounds = YES;
}

- (void)configureWithImageURL:(NSString *)url{
    
    [self.brandImage sea_setImageWithURL:url];
}
@end

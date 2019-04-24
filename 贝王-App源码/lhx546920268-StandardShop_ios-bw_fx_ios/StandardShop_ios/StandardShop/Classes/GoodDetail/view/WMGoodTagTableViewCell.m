//
//  WMGoodTagTableViewCell.m
//  StandardShop
//
//  Created by mac on 16/6/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodTagTableViewCell.h"
#import "JCTagListView.h"

#import "WMGoodDetailInfo.h"

@implementation WMGoodTagTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    self.isRefresh = YES;
}


- (void)configureCellWithModel:(id)model{
    
    WMGoodDetailInfo *info = (WMGoodDetailInfo *)model;
    
    self.goodTagListView.sizeHeight = 25.0;
    
    self.goodTagListView.tagStrokeColor = [UIColor clearColor];
    
    self.goodTagListView.tagTextColor = WMRedColor;
    
    self.goodTagListView.tagBackgroundColor = [UIColor whiteColor];
    
    self.goodTagListView.tagCornerRadius = 0.0;
    
    [_goodTagListView setup];
    
    _goodTagListView.type = StyleTypeImageText;
        
    [_goodTagListView setTags:info.goodTagsArr];

}

@end

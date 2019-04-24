//
//  WMGoodsAccessRecordListCell.m
//  StandardShop
//
//  Created by 罗海雄 on 2017/11/24.
//  Copyright © 2017年 qianseit. All rights reserved.
//

#import "WMGoodsAccessRecordListCell.h"
#import "WMGoodsAccessRecordInfo.h"

@implementation WMGoodsAccessRecordListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setInfo:(WMGoodsAccessRecordInfo *)info
{
    if(_info != info){
        _info = info;
        [self.goods_imageView sea_setImageWithURL:_info.imageURL];
        self.goods_name_label.text = _info.goodName;
        self.time_label.text = _info.time;
        self.store_name_label.text = _info.store;
        self.count_label.text = [NSString stringWithFormat:@"%d", _info.count];
    }
}

@end

//
//  WMSpecInfoSelectFooterView.m
//  StandardShop
//
//  Created by mac on 16/6/13.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMSpecInfoSelectFooterView.h"
#import "UIView+XQuickControl.h"
#import "WMButtonCollectionViewCell.h"

@interface WMSpecInfoSelectFooterView ()<UICollectionViewDataSource,UICollectionViewDelegate>
/**集合视图的配置
 */
@property (strong,nonatomic) UICollectionViewFlowLayout *layOut;
@end

@implementation WMSpecInfoSelectFooterView

/**初始化
 */
- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

/**配置界面
 */
- (void)configureUI{
    
    CGFloat cellWidth = self.width / self.buttonListArr.count;
    
    _layOut = [UICollectionViewFlowLayout new];
    
    _layOut.itemSize = CGSizeMake(cellWidth, WMSpecInfoSelectFooterViewHeight);
    
    _layOut.minimumInteritemSpacing = CGFLOAT_MIN;
    
    _layOut.minimumLineSpacing = CGFLOAT_MIN;
    
    _layOut.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.width, WMSpecInfoSelectFooterViewHeight) collectionViewLayout:_layOut];
    
    self.collectionView.dataSource = self;
    
    self.collectionView.delegate = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"WMButtonCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:WMButtonCollectionViewCellIden];
    
    [self addSubview:self.collectionView];
}

- (void)updateUI{
    
    CGFloat cellWidth = self.width / self.buttonListArr.count;
    
    _layOut.itemSize = CGSizeMake(cellWidth, WMSpecInfoSelectFooterViewHeight);
    
    [self.collectionView reloadData];
}

#pragma mark - UICollectionView协议
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _buttonListArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WMButtonCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WMButtonCollectionViewCellIden forIndexPath:indexPath];
    
    [cell configureWithDict:[_buttonListArr objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *buttonDict = [_buttonListArr objectAtIndex:indexPath.row];
    
    NSString *buttonType = [buttonDict sea_stringForKey:@"value"];
    
    BOOL fastBuy = NO;
    
    BOOL notify = NO;
    
    BOOL canBuy = NO;
    
    if ([buttonType isEqualToString:@"fastbuy"]) {
        
        fastBuy = YES;
    }
    else if ([buttonType isEqualToString:@"buy"]){
        
        fastBuy = NO;
    }
    else{
        
        return;
    }
    
    notify = [[buttonDict numberForKey:@"show_notify"] boolValue];
    
    canBuy = [[buttonDict numberForKey:@"buy"] boolValue];
    
    if (self.buttonAction) {
        
        self.buttonAction(fastBuy,notify,canBuy,buttonType);
    }
}












@end

//
//  XTableCellConfigEx.h
//  WeiXueProject
//
//  Created by TBXark on 15/5/9.
//  Copyright (c) 2015年 TBXark. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^configureCell)(id cell,id model);

@interface XTableCellConfigEx : NSObject

@property (nonatomic, copy) Class className;
@property (nonatomic, assign) CGFloat heightOfCell;

+ (instancetype)cellConfigWithClassName:(Class)className
                           heightOfCell:(CGFloat)heightOfCell
                              tableView:(UITableView *)tableView
                                  isNib:(BOOL)isNib;

- (id)cellOfCellConfigWithTableView:(UITableView *)tableView
                                         indexPath:(NSIndexPath *)indexPath;

+ (instancetype)headerFooterViewWith:(Class)className
                           tableView:(UITableView *)tableView;

- (id)headerFooterConfigWithTableView:(UITableView *)tableView;


@end

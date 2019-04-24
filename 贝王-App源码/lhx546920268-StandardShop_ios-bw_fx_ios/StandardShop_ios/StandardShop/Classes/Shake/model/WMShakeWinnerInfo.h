//
//  WMShakeWinnerInfo.h
//  StandardShop
//
//  Created by 罗海雄 on 16/8/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

///摇一摇获奖名单信息
@interface WMShakeWinnerInfo : NSObject

///获奖信息
@property(nonatomic,copy) NSString *text;

///获奖信息文字高度
@property(nonatomic,assign) CGFloat textHeight;

@end

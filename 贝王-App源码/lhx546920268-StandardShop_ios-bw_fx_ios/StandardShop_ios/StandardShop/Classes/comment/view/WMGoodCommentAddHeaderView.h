//
//  WMGoodCommentAddHeaderView.h
//  StandardShop
//
//  Created by 罗海雄 on 16/6/29.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMImageVerificationCodeView,WMGoodCommentScoreView,WMGoodCommentScoreInfo;

///商品评价表头
@interface WMGoodCommentAddHeaderView : UIView

///商品图片
@property(nonatomic,readonly) UIImageView *goodImageView;

///标题
@property(nonatomic,readonly) UILabel *titleLabel;

///评分
@property(nonatomic,readonly) WMGoodCommentScoreView *scoreView;

///评价内容输入框
@property(nonatomic,readonly) SeaTextView *textView;

///关联的评分
@property(nonatomic,strong) WMGoodCommentScoreInfo *info;

///图形验证码
@property(nonatomic,readonly) WMImageVerificationCodeView *imageCodeView;

/**需要图形验证码
 *@param codeURL 图形验证码链接
 */
- (void)addImageCode:(NSString*) codeURL;

@end

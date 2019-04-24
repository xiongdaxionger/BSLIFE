//
//  WMGoodCommentHeaderView.m
//  StandardShop
//
//  Created by 罗海雄 on 16/6/1.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodCommentHeaderView.h"
#import "WMGoodCommentOverallInfo.h"
#import "WMGoodCommentScoreProgressView.h"
#import "WMGoodCommentScoreInfo.h"

///评分tag
#define WMGoodCommentHeaderScoreTag 1200
#define WMGoodCommentHeaderScoreTitleTag 1100
#define WMGoodCommentHeaderScoreStarTag 1300

@implementation WMGoodCommentHeaderView

- (instancetype)init
{
    WMGoodCommentHeaderView *view = [[[NSBundle mainBundle] loadNibNamed:@"WMGoodCommentHeaderView" owner:nil options:nil] lastObject];
    view.frame = CGRectMake(0, 0, _width_, 125.0);

    return view;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.total_title_label.font = [UIFont fontWithName:MainFontName size:16.0];
    self.total_score_label.font = [UIFont fontWithName:MainNumberFontName size:20.0];
    self.total_score_label.textColor = WMRedColor;

    self.package_title_label.font = [UIFont fontWithName:MainFontName size:14.0];
    self.package_title_label.textColor = MainGrayColor;
    self.logistics_title_label.font = self.package_title_label.font;
    self.logistics_title_label.textColor = self.package_title_label.textColor;
    self.quality_title_label.font = self.package_title_label.font;
    self.quality_title_label.textColor = self.package_title_label.textColor;

    self.package_score_label.font = [UIFont fontWithName:MainNumberFontName size:14.0];
    self.package_score_label.textColor = self.total_score_label.textColor;
    self.logistics_score_label.font = self.package_score_label.font;
    self.logistics_score_label.textColor = self.package_score_label.textColor;
    self.quality_score_label.font = self.package_score_label.font;
    self.quality_score_label.textColor = self.package_score_label.textColor;

    self.package_title_label.tag = WMGoodCommentHeaderScoreTitleTag;
    self.logistics_title_label.tag = WMGoodCommentHeaderScoreTitleTag + 1;
    self.quality_title_label.tag = WMGoodCommentHeaderScoreTitleTag + 2;

    self.package_score_label.tag = WMGoodCommentHeaderScoreTag;
    self.logistics_score_label.tag = WMGoodCommentHeaderScoreTag + 1;
    self.quality_score_label.tag = WMGoodCommentHeaderScoreTag + 2;

    self.package_progressView.tag = WMGoodCommentHeaderScoreStarTag;
    self.logistics_progressView.tag = WMGoodCommentHeaderScoreStarTag + 1;
    self.quality_progressView.tag = WMGoodCommentHeaderScoreStarTag + 2;
    
}

- (void)setInfo:(WMGoodCommentOverallInfo *)info
{
    if(_info != info)
    {
        _info = info;

        for(NSInteger i = 0;i < info.scoreInfos.count;i ++)
        {
            WMGoodCommentScoreInfo *score = [_info.scoreInfos objectAtIndex:i];
            UILabel *label = [self viewWithTag:WMGoodCommentHeaderScoreTitleTag + i];
            label.text = score.name;

            label = [self viewWithTag:WMGoodCommentHeaderScoreTag + i];
            label.text = [NSString stringWithFormat:@"%.1f", score.score];

            WMGoodCommentScoreProgressView *progressView = (WMGoodCommentScoreProgressView*)[self viewWithTag:WMGoodCommentHeaderScoreStarTag + i];
            progressView.score = score.score;
        }

        for(NSInteger i = info.scoreInfos.count;i < 3;i ++)
        {
            UILabel *label = [self viewWithTag:WMGoodCommentHeaderScoreTitleTag + i];
            label.hidden = YES;

            label = [self viewWithTag:WMGoodCommentHeaderScoreTag + i];
            label.hidden = YES;

            WMGoodCommentScoreProgressView *progressView = (WMGoodCommentScoreProgressView*)[self viewWithTag:WMGoodCommentHeaderScoreStarTag + i];
            progressView.hidden = YES;
        }

        self.total_score_label.text = [NSString stringWithFormat:@"%.1f", _info.totalScore];
        self.total_proressView.score = _info.totalScore;
    }
}

@end

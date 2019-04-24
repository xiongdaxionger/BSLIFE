//
//  WMGuidePage.m
//  WuMei
//
//  Created by 罗海雄 on 15/8/6.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "WMGuidePage.h"
#import "AppDelegate.h"

//保存在UerDefaults中
#define WMGuidePageKey @"WMGuidePageKey"

@interface WMGuidePage ()<UIScrollViewDelegate>

//滚动视图
@property(nonatomic,strong) UIScrollView *scrollView;

//点
@property(nonatomic,strong) UIPageControl *pageControl;

@end

@implementation WMGuidePage

- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, _width_, _height_)];
    if(self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        
        int count = 0;
        
        UIImageView *lastImageView = nil;
        for(int i = 0;i < NSNotFound;i ++)
        {
            UIImage *image = [UIImage bundleImageWithName:[NSString stringWithFormat:@"guide_page_%d@2x", i + 1]];
            
            if(!image)
                break;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_scrollView.width * i, 0, _scrollView.width, _scrollView.height)];
            imageView.image = image;
            [_scrollView addSubview:imageView];
            lastImageView = imageView;
            
            count ++;
        }
        
        ///给最后一个图片添加点击手势
        if(lastImageView)
        {
            lastImageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
            
            [lastImageView addGestureRecognizer:tap];
        }
        
        _scrollView.contentSize = CGSizeMake(_scrollView.width * count, _scrollView.height);
        
        //        CGFloat buttonWidth = 150.0;
        //        CGFloat buttonHeight = 40.0;
        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.height  - 30, self.width, 20.0)];
        
        _pageControl.currentPage = 0;
        
        _pageControl.numberOfPages = count;
        
        _pageControl.hidesForSinglePage = YES;
        
        _pageControl.currentPageIndicatorTintColor = _appMainColor_;
        
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        
        [self addSubview:_pageControl];
        
        //        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        [btn setTitle:@"点击进入" forState:UIControlStateNormal];
        //        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //        btn.layer.cornerRadius = 5.0;
        //        btn.layer.masksToBounds = YES;
        //        btn.layer.borderColor = [UIColor whiteColor].CGColor;
        //        btn.layer.borderWidth = 1.5;
        //        [btn setFrame:CGRectMake((self.width - buttonWidth) / 2.0, _pageControl.bottom + 20.0, buttonWidth, buttonHeight)];
        //        [btn addTarget:self action:@selector(handleTap:) forControlEvents:UIControlEventTouchUpInside];
        //        [self addSubview:btn];
        
        
    }
    
    return self;
}

-(void)show
{
    [[AppDelegate instance].window addSubview:self];
    
    [[NSUserDefaults standardUserDefaults] setObject:appVersion() forKey:WMGuidePageKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)handleTap:(id) sender
{
    if(self.pageControl.currentPage == self.pageControl.numberOfPages - 1)
    {
        if([self.delegate respondsToSelector:@selector(guideWillDisappear:)])
        {
            [self.delegate guideWillDisappear:self];
        }
        
        [UIView animateWithDuration:0.5 animations:^(void){
            self.transform = CGAffineTransformMakeScale(1.5, 1.5);
            self.alpha = 0;
        }
        completion:^(BOOL finish)
        {
             [self removeFromSuperview];
        }];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //[self handleTap:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    if(scrollView.contentOffset.x > scrollView.width * (self.pageControl.numberOfPages - 1) + 30.0)
    //    {
    //        scrollView.delegate = nil;
    //        [self handleTap:nil];
    //    }
    //
    
    
    self.pageControl.currentPage = scrollView.contentOffset.x / scrollView.width;
}

#pragma mark- Class method

///是否需要显示引导页
+ (BOOL)shouldShowGuidePage
{
    NSString *version = appVersion();
    NSString *value = [[NSUserDefaults standardUserDefaults] stringForKey:WMGuidePageKey];
    return ![value isEqualToString:version];
}

@end

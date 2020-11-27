//
//  XQCarousel.m
//  视频和图片的混合轮播
//
//  Created by xzmwkj on 2018/7/10.
//  Copyright © 2018年 WangShuai. All rights reserved.
//

#import "XQCarousel.h"
#import "XQVideoView.h"

@interface XQCarousel ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) XQVideoView *videoView;

@end

@implementation XQCarousel

+ (instancetype)scrollViewFrame:(CGRect)frame imageStringGroup:(NSArray *)imgArray {
    XQCarousel *carousel = [[self alloc] initWithFrame:frame];
    carousel.contentArray = imgArray;
    return carousel;
}

- (void)setContentArray:(NSArray *)contentArray {
    _contentArray = contentArray;
    [self loadUI];
}

- (void)loadUI {
    
    [self addSubview:self.scrollView];
    
    NSInteger count = self.contentArray.count;
    
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width * self.contentArray.count, self.frame.size.height);
    
    for (NSInteger index = 0; index < count; index ++) {
        /** 测试 **/
        if (self.isHasVideo == YES) {
            if (index == 0) {
                [self.scrollView addSubview:self.videoView];
                self.videoView.videoUrl = self.contentArray[index];
            }else {
                [self.scrollView addSubview:[self productionImageView:index]];
            }
        }else{
            [self.scrollView addSubview:[self productionImageView:index]];
        }
    }
    
//    self.pageControl.numberOfPages = self.contentArray.count;
//    [self addSubview:self.pageControl];
}


-(UIImageView *)productionImageView:(NSInteger)index{
    if ([self.scrollView viewWithTag:888+index] != nil) {
        [[self.scrollView viewWithTag:888+index] removeFromSuperview];
    }
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width * index, 0, self.frame.size.width, self.frame.size.height)];
    
    [img sd_setImageWithURL:self.contentArray[index]];
    img.contentMode = UIViewContentModeScaleAspectFit;
    [img setTag:888+index];
    img.clipsToBounds = YES;
    
    return img;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger currentPage = round(scrollView.contentOffset.x / self.frame.size.width);
//    self.pageControl.currentPage = currentPage;
    
    if ([self.delegate respondsToSelector:@selector(carousel:didScrollToIndex:)] == YES) {
        [self.delegate carousel:self didScrollToIndex:currentPage];
    }
    
    
    
    if (self.videoView.isPlay) {
        if (currentPage == 0) {
            [self.videoView start];
        }else {
            [self.videoView stop];
        }
    }
    
}

#pragma mark - setter / getter

-(UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        
    }
    
    return _scrollView;
}

-(XQVideoView *)videoView{
    
    if (_videoView == nil) {
        _videoView = [XQVideoView videoViewFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) videoUrl:nil];
        
    }
    return _videoView;
}


-(UIPageControl *)pageControl{
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc]init];
        _pageControl.frame = CGRectMake(0, self.frame.size.height - 30, self.frame.size.width, 30);
        
        _pageControl.currentPage = 0;
        _pageControl.enabled = NO;
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    }
    
    return _pageControl;
}

@end

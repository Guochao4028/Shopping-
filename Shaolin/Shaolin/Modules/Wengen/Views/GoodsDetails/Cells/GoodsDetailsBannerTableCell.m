//
//  GoodsDetailsBannerTableCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/3/25.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "GoodsDetailsBannerTableCell.h"

#import "GoodsInfoModel.h"


#import "SDCycleScrollView.h"

//#import "XQCarousel.h"
#import "GoodsVideoView.h"

@interface GoodsDetailsBannerTableCell ()<UIScrollViewDelegate, SDCycleScrollViewDelegate, GoodsVideoViewDelegate>

@property(nonatomic, strong)UIScrollView *scrolView;

@property (strong, nonatomic)  SDCycleScrollView *bannerView;

@property(nonatomic, strong)NSArray *imgArray;

//@property(nonatomic, strong)XQCarousel *carousel;

@property (strong, nonatomic) GoodsVideoView *carousel;

@property(nonatomic, strong)UILabel *pageLabel;


@end

@implementation GoodsDetailsBannerTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - methods

-(void)initUI{
    
//    [self.contentView addSubview:self.scrolView];
    
}

//#pragma mark - XQCarouselDelegate
//-(void)carousel:(XQCarousel *)view didScrollToIndex:(NSInteger)index{
////    NSInteger index = scrollView.contentOffset.x/ScreenWidth;
////    scrollView.contentOffset = CGPointMake(index*self.bounds.size.width, 0);
//    NSInteger count = self.model.img_data.count;
//    [self.pageLabel setText: [NSString stringWithFormat:@"%ld/%ld", index+1, count]];
// 
//}

#pragma mark - GoodsVideoViewDelegate
-(void)carousel:(GoodsVideoView *)view didScrollToIndex:(NSInteger)index{
    NSInteger count = self.model.img_data.count;
    [self.pageLabel setText: [NSString stringWithFormat:@"%ld/%ld", index+1, count]];
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    NSInteger count = self.model.img_data.count;
     [self.pageLabel setText: [NSString stringWithFormat:@"%ld/%ld", index+1, count]];
}

#pragma mark - setter / getter


-(void)setModel:(GoodsInfoModel *)model{
    _model = model;
    
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSInteger count = model.img_data.count;
    
    if (model.video_url != nil && model.video_url.length != 0) {
//        
//        NSMutableArray *tem = [NSMutableArray array];
//        
//        for (int i = 0; i < count; i++) {
//            if (i == 0) {
//                [tem addObject:model.video_url];
//            }else{
//                [tem addObject:model.img_data[i]];
//            }
//        }
        [self.contentView addSubview:self.carousel];
        
        [self.carousel setDataArray:model.img_data];
        
        [self.carousel setVideoUrl:model.video_url];
//
//        self.carousel.isHasVideo = YES;
//        self.carousel.contentArray = tem;
        
//        self.carousel.contentSize = CGSizeMake(tem.count * self.frame.size.width, self.frame.size.height);
        
        if (self.bannerView) {
            [self.bannerView setHidden:YES];
        }
       
        
        
    }else{
        
        [self.contentView addSubview:self.bannerView];
        self.bannerView.imageURLStringsGroup = model.img_data;
    }
    
    if (count > 1) {
        [self.contentView addSubview:self.pageLabel];
        if (self.pageLabel.text.length == 0){
            [self.pageLabel setText: [NSString stringWithFormat:@"1/%ld", count]];
        }
    }
}

-(SDCycleScrollView *)bannerView{
    if (_bannerView == nil) {
        _bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth , ScreenWidth) delegate:self placeholderImage:[UIImage imageNamed:@"default_banner"]];
        _bannerView.hidesForSinglePage = YES;
        _bannerView.autoScroll = NO;
        _bannerView.showPageControl = NO;
        _bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    }
    return _bannerView;
}

-(GoodsVideoView *)carousel{
    if (_carousel == nil) {
        _carousel = [[GoodsVideoView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth)];
        [_carousel setDelegate:self];
    }

    return _carousel;
}






-(UILabel *)pageLabel{
    if (_pageLabel == nil) {
        _pageLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 56, ScreenWidth - (22+16), 56, 22)];
        [_pageLabel setFont:kMediumFont(15)];
        [_pageLabel setTextColor:[UIColor whiteColor]];
        [_pageLabel setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.4]];
        [_pageLabel.layer setMasksToBounds:YES];
        [_pageLabel setTextAlignment:NSTextAlignmentCenter];
        [_pageLabel.layer setCornerRadius:11];
    }
    return _pageLabel;
}




@end

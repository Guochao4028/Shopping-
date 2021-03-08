//
//  WengenBannerTableCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/3/18.
//  Copyright © 2020 syqaxldy. All rights reserved.
// banner

#import "WengenBannerTableCell.h"

#import "SDCycleScrollView.h"

#import "WengenBannerModel.h"

@interface WengenBannerTableCell ()<SDCycleScrollViewDelegate>

@property (strong, nonatomic)  SDCycleScrollView *bannerView;

@property(nonatomic, strong)NSArray *imgArray;

@end

@implementation WengenBannerTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



#pragma mark - methods

- (void)initUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.bannerView];
    self.bannerView.imageURLStringsGroup = self.imgArray;
    self.bannerView.showPageControl = YES;
    self.bannerView.currentPageDotColor = [UIColor whiteColor];
    self.bannerView.pageDotColor = [UIColor colorForHex:@"B4B4B4"];

}

- (void)initData{
    NSMutableArray *temList = [NSMutableArray array];
    for (WengenBannerModel *banner in self.dataSource) {
        [temList addObject:banner.imgUrl];
    }
    self.imgArray = temList;
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(pushToOtherViewControllerwithHomeItem:)]) {
        [self.delegate pushToOtherViewControllerwithHomeItem:self.dataSource[index]];
    }
}


#pragma mark - getter / setter

- (void)setDataSource:(NSArray<WengenBannerModel *> *)dataSource{
    _dataSource = dataSource;
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    [self setBackgroundColor:[UIColor clearColor]];
    [self initData];
    [self initUI];
}

- (SDCycleScrollView *)bannerView{
    if (_bannerView == nil) {
        _bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(16, 12, kBannerWidth, kBannerHeight) delegate:self placeholderImage:[UIImage imageNamed:@"default_banner"]];
        _bannerView.layer.masksToBounds = YES;
        _bannerView.layer.cornerRadius = 4;
        _bannerView.hidesForSinglePage = YES;
        _bannerView.showPageControl = NO;
        _bannerView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        _bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    }
    return _bannerView;
}


@end

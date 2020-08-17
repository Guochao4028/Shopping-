//
//  KungfuHomeBannerCell.m
//  Shaolin
//
//  Created by ws on 2020/5/11.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuHomeBannerCell.h"
#import "SDCycleScrollView.h"
#import "WengenBannerModel.h"

@interface KungfuHomeBannerCell () <SDCycleScrollViewDelegate>

@property (strong, nonatomic)  SDCycleScrollView *bannerView;

@end

@implementation KungfuHomeBannerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellSeparatorStyleNone;
        [self.contentView addSubview:self.bannerView];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if (self.bannerTapBlock) {
        self.bannerTapBlock(index);
    }
}


-(SDCycleScrollView *)bannerView{
    if (_bannerView == nil) {
        _bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(16, 12, ScreenWidth - 32, (130)) delegate:self placeholderImage:[UIImage imageNamed:@"default_banner"]];
        _bannerView.layer.masksToBounds = YES;
        _bannerView.layer.cornerRadius = 4;
        _bannerView.hidesForSinglePage = YES;
        _bannerView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        _bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        
        
        
        _bannerView.showPageControl = YES;
        _bannerView.currentPageDotColor = [UIColor whiteColor];
        _bannerView.pageDotColor = [UIColor colorForHex:@"B4B4B4"];
        
    }
    return _bannerView;
}

-(void)setBannerList:(NSArray *)bannerList {
    _bannerList = bannerList;
    
    
    NSMutableArray *temList = [NSMutableArray array];
    for (WengenBannerModel *banner in bannerList) {
        [temList addObject:banner.imgUrl];
    }    
    
    self.bannerView.imageURLStringsGroup = temList;
}

@end

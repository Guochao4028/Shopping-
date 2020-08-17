//
//  WengenStrictSelectionTableCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/3/19.
//  Copyright © 2020 syqaxldy. All rights reserved.
// 首页 ->严选

#import "WengenStrictSelectionTableCell.h"

#import "WengenBannerModel.h"

#import "WengenStrictSelectionItemCollectionCell.h"

static NSString *const kWengenStrictSelectionItemCollectionCellIdentifier = @"WengenStrictSelectionItemCollectionCell";


@interface WengenStrictSelectionTableCell ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *strictSelectionBannerImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;


@end

@implementation WengenStrictSelectionTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
     [self initUI];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - methods

-(void)initUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.pageControl setHidden:YES];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WengenStrictSelectionItemCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:kWengenStrictSelectionItemCollectionCellIdentifier];
    
    [self.collectionView setPagingEnabled:YES];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBannerAction)];
    [self.strictSelectionBannerImageView addGestureRecognizer:tap];
    
    self.strictSelectionBannerImageView.layer.cornerRadius = 5;
    self.strictSelectionBannerImageView.layer.masksToBounds = YES;
    
}

#pragma mark - action

-(void)tapBannerAction{
    if ([self.delegate respondsToSelector:@selector(tapBanner:)]) {
        [self.delegate tapBanner:self.bannerModel];
    }
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.goodsArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((ScreenWidth - (32+5)) / 3, 170);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   WengenStrictSelectionItemCollectionCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:kWengenStrictSelectionItemCollectionCellIdentifier forIndexPath:indexPath];

    cell.model = self.goodsArray[indexPath.row];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if([self.delegate respondsToSelector:@selector(tapStrictSelectionGoodsItem:)]){
        [self.delegate tapStrictSelectionGoodsItem:self.goodsArray[indexPath.row]];
    }
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
   CGFloat pagewidth = ScreenWidth - 32;
    int page = floor((scrollView.contentOffset.x - pagewidth/2)/pagewidth)+1;

    self.pageControl.currentPage = page;
}



#pragma mark - setter / getter

-(void)setGoodsArray:(NSArray<WengenGoodsModel *> *)goodsArray{
    _goodsArray = goodsArray;
    [self.collectionView reloadData];
    
    NSInteger pageNumber = ceilf(goodsArray.count/3.0);
    
    if (pageNumber > 1) {
        [self.pageControl setHidden:NO];
        [self.pageControl setNumberOfPages:pageNumber];
        [self.pageControl setCurrentPage:0];
    }
    
    [self.strictSelectionBannerImageView setImage:[UIImage imageNamed:@"yanxuanbanner"]];
}

-(void)setBannerModel:(WengenBannerModel *)bannerModel{
    _bannerModel = bannerModel;
    
    [self.strictSelectionBannerImageView sd_setImageWithURL:[NSURL URLWithString:bannerModel.imgUrl]];
}



@end

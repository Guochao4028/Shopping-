//
//  RecommendTableCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/3/18.
//  Copyright © 2020 syqaxldy. All rights reserved.
// 新人推荐cell

#import "RecommendTableCell.h"
#import "WengenGoodsModel.h"
#import "RecommendGoodsCollectionViewCell.h"

static NSString *const kRecommendGoodsCollectionViewCellIdentifier = @"RecommendGoodsCollectionViewCell";

@interface RecommendTableCell ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *titleView;

@end

@implementation RecommendTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self initUI];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initUI{
   
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([RecommendGoodsCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:kRecommendGoodsCollectionViewCellIdentifier];
    
    
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTitleView)];
    [self.titleView addGestureRecognizer:tap];
    
}

-(void)tapTitleView{
    if ([self.delegate respondsToSelector:@selector(tapTitleItem)] == YES) {
        [self.delegate tapTitleItem];
    }
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat width = 309 * WIDTHTPROPROTION;
    return CGSizeMake(width, 110);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RecommendGoodsCollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:kRecommendGoodsCollectionViewCellIdentifier forIndexPath:indexPath];

    cell.model = self.dataArray[indexPath.row];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if([self.delegate respondsToSelector:@selector(tapGoodsItem:)]){
        [self.delegate tapGoodsItem:self.dataArray[indexPath.row]];
    }
}

-(void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self.collectionView reloadData];
}

@end

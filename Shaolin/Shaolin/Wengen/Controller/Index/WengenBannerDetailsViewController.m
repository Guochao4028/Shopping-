//
//  WengenBannerDetailsViewController.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/26.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "WengenBannerDetailsViewController.h"

#import "WengenGoodsCollectionCell.h"

#import "WengenNavgationView.h"

#import "GoodsDetailsViewController.h"
#import "DataManager.h"

@interface WengenBannerDetailsViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property(nonatomic, strong)UICollectionView *collectionView;

@property(nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation WengenBannerDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.type isEqualToString:@"Recommend"]) {
        self.titleLabe.text = SLLocalizedString(@"新人推荐");
    } else {
        self.titleLabe.text = SLLocalizedString(@"少林严选");
    }
    // Do any additional setup after loading the view.
    [self initData];
    [self initUI];
}

-(void)initData{
    if ([self.type isEqualToString:@"Recommend"] == YES) {
        [[DataManager shareInstance]getRecommendGoodsCallback:^(NSArray *result) {
            [self.dataArray addObjectsFromArray:result];;
            [self.collectionView reloadData];
        }];
    }else{
        [[DataManager shareInstance]getStrictSelectionGoodsCallback:^(NSArray *result) {
            [self.dataArray addObjectsFromArray:result];;
            [self.collectionView reloadData];
        }];
    }
}

-(void)initUI{
    [self.view addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WengenGoodsCollectionCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"WengenGoodsCollectionCell" forIndexPath:indexPath];
    cell.model = [self.dataArray objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WengenGoodsModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    GoodsDetailsViewController *goodsDetailsVC = [[GoodsDetailsViewController alloc]init];
    goodsDetailsVC.goodsModel = model;
    goodsDetailsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:goodsDetailsVC animated:YES];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat width = (ScreenWidth - 32 - 12.5)/2;
    return CGSizeMake(width, 273);
}

#pragma mark - setter / getgter
-(UICollectionView *)collectionView{
    
    if (_collectionView == nil) {
        CGFloat y = 0;
         UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(0, 16, 0, 16);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, y, ScreenWidth, ScreenHeight - y) collectionViewLayout:layout];
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        
         [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WengenGoodsCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:@"WengenGoodsCollectionCell"];
    }
    return _collectionView;

}

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}


@end

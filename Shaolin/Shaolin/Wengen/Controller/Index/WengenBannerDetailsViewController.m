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

@interface WengenBannerDetailsViewController ()<WengenNavgationViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property(nonatomic, strong)WengenNavgationView *navgationView;

@property(nonatomic, strong)UICollectionView *collectionView;

@property(nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation WengenBannerDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initUI];
}

-(void)initData{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
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
    [self.view addSubview:self.navgationView];
    [self.view addSubview:self.collectionView];
}

#pragma mark - WengenNavgationViewDelegate
-(void)tapBack{
    [self.navigationController popViewControllerAnimated:YES];
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
-(WengenNavgationView *)navgationView{
    if (_navgationView == nil) {
        //状态栏高度
        CGFloat barHeight ;
        /** 判断版本
         获取状态栏高度
         */
        if (@available(iOS 13.0, *)) {
            barHeight = [[[[[UIApplication sharedApplication] keyWindow] windowScene] statusBarManager] statusBarFrame].size.height;
        } else {
            barHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
        }
        _navgationView = [[WengenNavgationView alloc]initWithFrame:CGRectMake(0, barHeight, ScreenWidth, 44)];
        if ([self.type isEqualToString:@"Recommend"]) {
            [_navgationView setTitleStr:SLLocalizedString(@"新人推荐")];
        }else {
            [_navgationView setTitleStr:SLLocalizedString(@"少林严选")];
        }
        [_navgationView setDelegate:self];
    }
    return _navgationView;
}

-(UICollectionView *)collectionView{
    
    if (_collectionView == nil) {
        CGFloat y = CGRectGetMaxY(self.navgationView.frame);
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

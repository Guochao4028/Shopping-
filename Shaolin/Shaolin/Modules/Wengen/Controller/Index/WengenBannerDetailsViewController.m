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

@property(nonatomic, assign)NSInteger pageNumber;

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

- (void)initData{

    
    self.pageNumber = 1;
    
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param setValue:[NSString stringWithFormat:@"%ld", self.pageNumber] forKey:@"pageNum"];
    [param setValue:@"10"forKey:@"pageSize"];
    if ([self.type isEqualToString:@"Recommend"] == YES) {
        
//        [param setValue:@"1" forKey:@"isNew"];
        
        [[DataManager shareInstance]getRecommendGoods:param Callback:^(NSArray *result) {
            [hud hideAnimated:YES];
            [self.dataArray addObjectsFromArray:result];
            [self.collectionView reloadData];
            [self.collectionView.mj_footer setHidden:NO];
        }];
    }else{
//        [param setValue:@"1" forKey:@"isDelicate"];
        [[DataManager shareInstance]getStrictSelectionGoods:param Callback:^(NSArray *result) {
            [hud hideAnimated:YES];
            [self.dataArray addObjectsFromArray:result];;
            [self.collectionView reloadData];
            [self.collectionView.mj_footer setHidden:NO];
        }];
    }
}

- (void)initUI{
    [self.view addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.collectionView.mj_footer setHidden:YES];
}

//刷新
- (void)updata{
    self.pageNumber = 1;
    
    [self.dataArray removeAllObjects];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param setValue:[NSString stringWithFormat:@"%ld", self.pageNumber] forKey:@"pageNum"];
    [param setValue:@"10"forKey:@"pageSize"];
    
    [self.collectionView.mj_footer resetNoMoreData];
    
    if ([self.type isEqualToString:@"Recommend"] == YES) {
//        [param setValue:@"1" forKey:@"isNew"];

        [[DataManager shareInstance]getRecommendGoods:param Callback:^(NSArray *result) {
            
            [self.dataArray addObjectsFromArray:result];
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView reloadData];
        }];
        
    }else{
//        [param setValue:@"1" forKey:@"isDelicate"];
        [[DataManager shareInstance]getStrictSelectionGoods:param Callback:^(NSArray *result) {
            [self.dataArray addObjectsFromArray:result];
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView reloadData];
        }];
    }
    
}

//加载更多
- (void)loadMoreData{
    self.pageNumber ++;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param setValue:[NSString stringWithFormat:@"%ld", self.pageNumber] forKey:@"pageNum"];
    [param setValue:@"10"forKey:@"pageSize"];
    
    if ([self.type isEqualToString:@"Recommend"] == YES) {
//        [param setValue:@"1" forKey:@"isNew"];
        [[DataManager shareInstance]getRecommendGoods:param Callback:^(NSArray *result) {
            
            [self.dataArray addObjectsFromArray:result];
            [self.collectionView.mj_footer endRefreshing];
            if ([result count] == 0) {
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
            
           
            [self.collectionView reloadData];
        }];
        
    }else{
//        [param setValue:@"1" forKey:@"isDelicate"];
        [[DataManager shareInstance]getStrictSelectionGoods:param Callback:^(NSArray *result) {
            [self.dataArray addObjectsFromArray:result];
            [self.collectionView.mj_footer endRefreshing];
            if ([result count] == 0) {
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
            
           
            [self.collectionView reloadData];
        }];
    }

}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WengenGoodsCollectionCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"WengenGoodsCollectionCell" forIndexPath:indexPath];
    cell.model = [self.dataArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WengenGoodsModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    GoodsDetailsViewController *goodsDetailsVC = [[GoodsDetailsViewController alloc]init];
    goodsDetailsVC.goodsModel = model;
    goodsDetailsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:goodsDetailsVC animated:YES];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    CGFloat width = (ScreenWidth - 32 - 12.5)/2;
//    return CGSizeMake(width, 273);
    CGSize size = CGSizeMake((ScreenWidth - 24 ) / 2, (264*WIDTHTPROPROTION));
    return size;
}

#pragma mark - setter / getgter
- (UICollectionView *)collectionView{
    
    if (_collectionView == nil) {


         UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(0, 12, 0, 12);
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        
//        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        
         [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WengenGoodsCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:@"WengenGoodsCollectionCell"];
        
        MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(updata)];
        _collectionView.mj_header = header;
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        _collectionView.mj_footer = footer;
    }
    return _collectionView;

}

- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}


@end

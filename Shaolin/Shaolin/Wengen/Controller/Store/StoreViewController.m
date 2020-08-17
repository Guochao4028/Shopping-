//
//  StoreViewController.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/13.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "StoreViewController.h"

#import "StoreNavgationView.h"

#import "StoreHeardView.h"

#import "StoreNavgationView.h"

#import "StoreCollectionReusableView.h"

#import "GCPlainFlowLayout.h"

#import "StoreCollectionViewCell.h"

#import "GoodsStoreInfoModel.h"

#import "StoreNoGridCollectionViewCell.h"

#import "StoreDetailsViewController.h"

#import "UIImage+ImageDarken.h"

#import "ShoppingCartViewController.h"

#import "GoodsDetailsViewController.h"

#import "SearchViewController.h"

#define oriOfftY -217


@interface StoreViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, StoreCollectionReusableViewDelegate, StoreNavgationViewDelege>

@property(nonatomic, strong)UICollectionView *collectionView;

@property(nonatomic, strong)StoreHeardView *heardView;
@property(nonatomic, strong)StoreNavgationView *navgationView;

@property(nonatomic, strong)NSMutableArray *dataArray;

@property(nonatomic, assign)NSInteger pageNumber;

@property(nonatomic, assign)StoreListSortingType sortingType;

@property(nonatomic, strong)GoodsStoreInfoModel *storeInfoModel;

@property(nonatomic, strong)UIButton *carButton;

@property(nonatomic, assign)BOOL isHasDefault;

@property(nonatomic, assign)BOOL isGrid;

@property(nonatomic, strong)UILabel *numberLabel;

@property(nonatomic, assign)BOOL isCollect;





@end

@implementation StoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self initData];
    [self initUI];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self initData];
}

#pragma mark - methods

-(void)initData{
    
   [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshUI) name:WENGENMANAGER_GETORDERANDCARTCOUNT object:nil];
    
    self.isHasDefault = YES;
    
    self.isGrid = YES;
    
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    [[DataManager shareInstance]getStoreInfo:@{@"id":self.storeId} Callback:^(NSObject *object) {
        self.storeInfoModel = (GoodsStoreInfoModel *)object;
        self.pageNumber = 1;
        
        self.isCollect = [self.storeInfoModel.collect boolValue];
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        
        [param setValue:self.storeInfoModel.storeId forKey:@"club_id"];
        
        [param setValue:@"desc" forKey:@"sort"];
        
        self.sortingType = StoreListSortingTuiJianType;
        
        [self.dataArray removeAllObjects];
        [[DataManager shareInstance]getGoodsList:param Callback:^(NSArray *result) {
            [hud hideAnimated:YES];
            self.pageNumber ++;
            [self.dataArray addObjectsFromArray:result];
            [self.collectionView reloadData];
        }];
    }];
}

-(void)initUI{
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:self.collectionView];
    
    [self.view addSubview:self.navgationView];
    
    [self.view addSubview:self.carButton];
}

-(void)refreshUI{
    NSString *carCountStr = [[ModelTool shareInstance]carCount];
       
    NSInteger carNumber = [carCountStr integerValue];
    
    if (carNumber > 0) {
        [self.numberLabel setHidden:NO];
        [self.numberLabel setText:carCountStr];
    }else{
        [self.numberLabel setHidden:YES];

    }
}



#pragma mark - action

//刷新
-(void)updata{
    self.pageNumber = 1;
    [self.dataArray removeAllObjects];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.storeInfoModel.storeId forKey:@"club_id"];
    
    if (self.sortingType == StoreListSortingXiaoLiangType) {
        [param setValue:@"1" forKey:@"num"];
        [param setValue:@"desc" forKey:@"sort"];
    }else if (self.sortingType == StoreListSortingJiaGeAscType) {
        [param setValue:@"1" forKey:@"price"];
        [param setValue:@"asc" forKey:@"sort"];
    }else if (self.sortingType == StoreListSortingJiaGeDescType) {
        [param setValue:@"1" forKey:@"price"];
        [param setValue:@"desc" forKey:@"sort"];
    }else if (self.sortingType == StoreListSortingOnlyHaveType) {
        [param setValue:@"1" forKey:@"stock"];
    }else if (self.sortingType == StoreListSortingTuiJianType) {
        [param setValue:@"desc" forKey:@"sort"];
    }
    
    
    [self.collectionView.mj_footer resetNoMoreData];
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    [[DataManager shareInstance]getGoodsList:param Callback:^(NSArray *result) {
        [hud hideAnimated:YES];
        self.pageNumber ++;
        [self.dataArray addObjectsFromArray:result];
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
    }];
}

//加载更多
-(void)loadMoreData{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.storeInfoModel.storeId forKey:@"club_id"];
    [param setValue:[NSString stringWithFormat:@"%ld", self.pageNumber] forKey:@"page"];
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    [[DataManager shareInstance]getGoodsList:param Callback:^(NSArray *result) {
        [hud hideAnimated:YES];
        if ([result count] > 0) {
            self.pageNumber ++;
            [self.dataArray addObjectsFromArray:result];
            [self.collectionView reloadData];
            [self.collectionView.mj_footer endRefreshing];
        }else{
            [self.collectionView.mj_footer endRefreshing];
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
        
    }];
}

-(void)focusButtonAction:(UIButton *)sender{
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        //关注
        [[DataManager shareInstance]addCollect:@{@"club_id":self.storeId} Callback:^(Message *message) {
            [self initData];

            if (message.isSuccess == YES) {
                [sender setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                [sender setTitle:SLLocalizedString(@"已关注") forState:UIControlStateNormal];
                sender.layer.borderColor = [UIColor colorForHex:@"FFFFFF"].CGColor;
                sender.layer.borderWidth = 1;
                [sender setBackgroundColor:[UIColor clearColor]];
                sender.layer.cornerRadius = SLChange(15);
                self.isCollect = YES;
            }
        }];
        
    }else{
        //取消关注
        [[DataManager shareInstance]cancelCollect:@{@"club_id":self.storeId} Callback:^(Message *message) {
             [self initData];
            if (message.isSuccess == YES) {
                [sender setImage:[UIImage imageNamed:@"baiGuanzhu"] forState:UIControlStateNormal];
                [sender setTitle:SLLocalizedString(@"关注") forState:UIControlStateNormal];
                [sender setBackgroundColor:[UIColor colorForHex:@"BE0B1F"]];
                sender.layer.borderColor = [UIColor colorForHex:@"BE0B1F"].CGColor;
                sender.layer.borderWidth = 1;
                sender.layer.cornerRadius = SLChange(15);
                self.isCollect = NO;
            }
        }];
    }
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)jumpStoreDetailAction{
    StoreDetailsViewController *stortDetailsVC = [[StoreDetailsViewController alloc]init];
    stortDetailsVC.isCollect = self.isCollect;
    stortDetailsVC.storeId = self.storeId;
    [self.navigationController pushViewController:stortDetailsVC animated:YES];
}

-(void)jumpGoodsCartAction{
    ShoppingCartViewController *shoppingCartVC = [[ShoppingCartViewController alloc]init];
    [self.navigationController pushViewController:shoppingCartVC animated:YES];
}



#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout columnCountForSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isGrid == YES) {
        StoreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StoreCollectionViewCell" forIndexPath:indexPath];
           
           [cell setGoodsModel:self.dataArray[indexPath.row]];
        
           return cell;
    }else{
        StoreNoGridCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StoreNoGridCollectionViewCell" forIndexPath:indexPath];
        
        [cell setGoodsModel:self.dataArray[indexPath.row]];
        
        
        return cell;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    StoreCollectionReusableView *heard = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"StoreCollectionReusableView" forIndexPath:indexPath];
    
    heard.isHasDefault = self.isHasDefault;
    
    [heard setDelegagte:self];
    
    return heard;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(ScreenWidth, 40);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isGrid == YES) {
      return CGSizeMake((ScreenWidth )/2, 260);
    }else{
        return CGSizeMake(ScreenWidth, 160);
    }
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.dataArray count] > 0) {
        WengenGoodsModel *goodsModel = self.dataArray[indexPath.row];
           GoodsDetailsViewController *goodsDetailVC = [[GoodsDetailsViewController alloc]init];
           
           goodsDetailVC.goodsModel = goodsModel;
           
           [self.navigationController pushViewController:goodsDetailVC animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat offset = scrollView.contentOffset.y - oriOfftY;
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
    CGFloat imgH = (173 + barHeight) - offset;
    if (imgH < 64) {
        imgH = 64;
    }
    
    CGFloat alpha = offset * 1 / 136.0;   // (200 - 64) / 136.0f
    if (alpha >= 1) {
        alpha = 0.99;
    }
    NSLog(@"alpha : %f", alpha);
    [self.navgationView setBackgroundColor:[UIColor colorWithWhite:1 alpha:alpha]];
    if (alpha > 0.6) {
        [self.navgationView setIsWhite:NO];
    }else{
        [self.navgationView setIsWhite:YES];
    }
    
//  static CGFloat alpha = 0;
//    CGFloat offsetY = scrollView.contentOffset.y;
//    if ((offsetY + 217.0) > 0) {
//        alpha += 0.1;
//        [self.navgationView setBackgroundColor:[UIColor colorWithWhite:1 alpha:alpha]];
//        [self.navgationView setIsWhite:NO];
//
//    }else{
//        if (alpha > 1) {
//            alpha = 1;
//        }
//        alpha -= 0.1;
//        [self.navgationView setBackgroundColor:[UIColor colorWithWhite:1 alpha:alpha]];
//        [self.navgationView setIsWhite:YES];
//    }
}

#pragma mark - StoreCollectionReusableViewDelegate
-(void)collectionReusableView:(StoreCollectionReusableView *)view tapAction:(StoreListSortingType)storeSortingType{
    self.sortingType = storeSortingType;
    self.isHasDefault = NO;
    [self updata];
}

-(void)collectionReusableView:(StoreCollectionReusableView *)view tapGrid:(BOOL)isGrid{
    self.isGrid = !self.isGrid;
    [self.collectionView reloadData];
}

#pragma mark - StoreNavgationViewDelege
/**
 点击搜索
 */
-(void)tapSearch{
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    
    searchVC.storeId= self.storeId;
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark - getter / setter

-(UICollectionView *)collectionView{
    
    if (_collectionView == nil) {
        
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
        
        GCPlainFlowLayout *layout = [[GCPlainFlowLayout alloc] init];
//           layout.sectionInset = UIEdgeInsetsMake(0, 7, 0, 7);
           layout.minimumLineSpacing = 0;
           layout.minimumInteritemSpacing = 0;
           layout.naviHeight = 70;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) collectionViewLayout:layout];
        [_collectionView setBackgroundColor:BackgroundColor_White];
        
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        [_collectionView registerClass:[StoreCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"StoreCollectionReusableView"];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([StoreCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"StoreCollectionViewCell"];
        
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([StoreNoGridCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"StoreNoGridCollectionViewCell"];
        
        MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(updata)];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.lastUpdatedTimeLabel.hidden = YES;
        [header setTitle:SLLocalizedString(@"下拉刷新") forState:MJRefreshStateIdle];
        [header setTitle:SLLocalizedString(@"松手刷新") forState:MJRefreshStatePulling];
        [header setTitle:SLLocalizedString(@"正在刷新...") forState:MJRefreshStateRefreshing];
        _collectionView.mj_header = header;
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        [footer setTitle:SLLocalizedString(@"加载中 ...") forState:MJRefreshStateRefreshing];
        _collectionView.mj_footer = footer;
        
        //设置滚动范围偏移200
        _collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(173+barHeight, 0, 0, 0);
        //设置内容范围偏移200
        _collectionView.contentInset = UIEdgeInsetsMake(173+barHeight, 0, 0, 0);
        _collectionView.alwaysBounceVertical = YES;
        [self.collectionView addSubview:self.heardView];
        
        
        if (@available(iOS 11.0, *)){
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else{
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
    }
    return _collectionView;
    
}

-(StoreHeardView *)heardView{
    
    if (_heardView == nil) {
        
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
        
        _heardView = [[StoreHeardView alloc]initWithFrame:CGRectMake(0, -(173 + barHeight), ScreenWidth, 173+barHeight)];
        [_heardView focusTarget:self action:@selector(focusButtonAction:)];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpStoreDetailAction)];
        
        [_heardView addGestureRecognizer:tap];
    }
    return _heardView;

}

-(void)setStoreInfoModel:(GoodsStoreInfoModel *)storeInfoModel{
    _storeInfoModel = storeInfoModel;
    [self.heardView setStoreInfoModel:storeInfoModel];
}

-(StoreNavgationView *)navgationView{
    
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
        
        _navgationView = [[StoreNavgationView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 70)];
        [_navgationView backTarget:self action:@selector(back)];
        
        [_navgationView setDelegate:self];
    }
    return _navgationView;

}

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


-(UIButton *)carButton{
    
    if (_carButton == nil) {
        _carButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat width = 52, height = width;
        CGFloat x = ScreenWidth - width - 15;
        CGFloat y = ScreenHeight - height - 168;

        [_carButton setFrame:CGRectMake(x, y, width, height)];
        [_carButton setImage:[UIImage imageNamed:@"carButton"] forState:UIControlStateNormal];
        [_carButton addTarget:self action:@selector(jumpGoodsCartAction) forControlEvents:UIControlEventTouchUpInside];
        
        [_carButton addSubview:self.numberLabel];
        NSString *carCountStr = [[ModelTool shareInstance]carCount];
        
        NSInteger carNumber = [carCountStr integerValue];
        
        if (carNumber > 0) {
            [self.numberLabel setText:carCountStr];
            [self.numberLabel setHidden:NO];
        }else{
            [self.numberLabel setHidden:YES];
        }
        
    }
    return _carButton;
}

-(UILabel *)numberLabel{
    if (_numberLabel == nil) {
        CGFloat x = 52 - 21;
        CGFloat y = 0;

        _numberLabel  = [[UILabel alloc]initWithFrame:CGRectMake(x, y, 15, 14)];
        [_numberLabel setFont:kRegular(9)];
        [_numberLabel setTextColor:[UIColor colorForHex:@"BE0B1F"]];
        [_numberLabel setTextAlignment:NSTextAlignmentCenter];
        _numberLabel.layer.cornerRadius = 6;
        _numberLabel.layer.borderColor =[UIColor colorForHex:@"BE0B1F"].CGColor;
        _numberLabel.layer.borderWidth = 1;
        [_numberLabel setBackgroundColor:[UIColor whiteColor]];
        [self.numberLabel.layer setMasksToBounds:YES];
    }
    return _numberLabel;
}




-(void)dealloc{
    //移除监听
     [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end

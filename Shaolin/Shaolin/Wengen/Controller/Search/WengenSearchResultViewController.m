//
//  WengenSearchResultViewController.m
//  Shaolin
//
//  Created by 郭超 on 2020/5/7.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "WengenSearchResultViewController.h"
#import "ShoppingCartViewController.h"
#import "WengenSearchView.h"
#import "SearchNavgationView.h"

#import "SearchMenuView.h"
#import "ClassifyGoodsListView.h"
#import "GoodsDetailsViewController.h"
#import "DataManager.h"

#import "SearchHistoryModel.h"

//WengenSearchViewDelegate
@interface WengenSearchResultViewController ()< SearchMenuViewDelegate, ClassifyGoodsListViewDelegate, SearchNavgationViewDelegate>
//top 搜索栏
//@property(nonatomic, strong)WengenSearchView *searchView;
@property(nonatomic, strong)SearchNavgationView *searchView;

//菜单
@property(nonatomic, strong)SearchMenuView *menuView;

//商品列表
@property(nonatomic, strong)ClassifyGoodsListView *goodsListView;

@property(nonatomic, assign)NSInteger pageNumber;

@property(nonatomic, strong)NSMutableArray *dataArray;

///记录 价格 排序
@property(nonatomic, assign)BOOL isPriceSorting;

///记录 销量
@property(nonatomic, assign)BOOL isSalesVolume;

///记录 评星
@property(nonatomic, assign)BOOL isStar;


@property(nonatomic, assign)ListType listType;

@property (nonatomic, strong) NSMutableArray *historyArray;



@end

@implementation WengenSearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hideNavigationBar = YES;
    // Do any additional setup after loading the view.
    
    [self initUI];
    [self initData];
}

-(void)initData{
    [self.searchView setTitleStr:self.searchStr];
    
    self.pageNumber = 1;
    
    [self.dataArray removeAllObjects];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (self.storeId != nil) {
        [param setValue:self.storeId forKey:@"club_id"];
    }
    
    [param setValue:[NSString stringWithFormat:@"%ld", self.pageNumber] forKey:@"page"];
    [param setValue:self.searchStr forKey:@"name"];
    
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    [[DataManager shareInstance]getGoodsList:param Callback:^(NSArray *result) {
        [hud hideAnimated:YES];
        [self.dataArray addObjectsFromArray:result];
        [self.goodsListView setDataArray:self.dataArray];
    }];
    
}

-(void)initUI{
    [self.view setBackgroundColor:BackgroundColor_White];
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.menuView];
    [self.view addSubview:self.goodsListView];
}

///更新数据
-(void)update{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    switch (self.listType) {
        case ListJiaGeDescType:{
            [param setValue:@"1" forKey:@"price"];
            [param setValue:@"desc" forKey:@"sort"];
        }
            
            break;
        case ListJiaGeAscType:{
            [param setValue:@"1" forKey:@"price"];
            [param setValue:@"asc" forKey:@"sort"];
        }
            
            break;
        case ListXiaoLiangDescType:{
            [param setValue:@"1" forKey:@"num"];
            [param setValue:@"desc" forKey:@"sort"];
        }
            
            break;
        case ListXiaoLiangAscType:{
            [param setValue:@"1" forKey:@"num"];
            [param setValue:@"asc" forKey:@"sort"];
        }
            
            break;
        case ListStarAscType:{
            [param setValue:@"1" forKey:@"star"];
            [param setValue:@"asc" forKey:@"sort"];
        }
            
            break;
            
        case ListStarDescType:{
            [param setValue:@"1" forKey:@"star"];
             [param setValue:@"desc" forKey:@"sort"];
        }
            
            break;
        default:
            break;
    }
    
    
    self.pageNumber = 1;
    [self.dataArray removeAllObjects];
    if (self.storeId != nil) {
        [param setValue:self.storeId forKey:@"club_id"];
    }
    
    [param setValue:[NSString stringWithFormat:@"%ld", self.pageNumber] forKey:@"page"];
    [param setValue:self.searchStr forKey:@"name"];
    
    
    
    
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    
    [[DataManager shareInstance]getGoodsList:param Callback:^(NSArray *result) {
        [hud hideAnimated:YES];
        [self.dataArray addObjectsFromArray:result];
        [self.goodsListView setDataArray:self.dataArray];
    }];
    
}

//#pragma mark - WengenSearchViewDelegate
//
///**
// 点击购物车
// */
//-(void)tapShopping{
//    ShoppingCartViewController *shoppingCartVC = [[ShoppingCartViewController alloc]init];
//    shoppingCartVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:shoppingCartVC animated:YES];
//}
//
///**
// 点击搜索
// */
//-(void)tapSearch{
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
///**
// 点击搜索view上的返回按钮
// */
//-(void)tapBack{
//    [self.navigationController popViewControllerAnimated:YES];
//}


#pragma mark - SearchNavgationViewDelegate
-(void)tapBack{
    [self.searchView resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)searchNavgationView:(SearchNavgationView *)navgationView searchWord:(NSString *)text{
    if (text.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入搜索内容") view:self.view afterDelay:TipSeconds];
        return;
    }
//    if ([self.historyArray containsObject:text]) {
//           [self.historyArray removeObject:text];
//       }
//    [self.historyArray insertObject:text atIndex:0];
//    [NSKeyedArchiver archiveRootObject:self.historyArray toFile:KGoodsHistorySearchPath];
    
    NSString *userId = [SLAppInfoModel sharedInstance].id;
    
    SearchHistoryModel *historyModel = [[SearchHistoryModel alloc]init];
    historyModel.userId = userId;
    historyModel.searchContent = text;
    

    historyModel.type = [NSString stringWithFormat:@"%ld", SearchHistoryGoodsType];;
    
    [historyModel addSearchWordWithDataArray:_historyArray];
    
    self.searchStr = text;
    [self update];
    
}

#pragma mark - SearchMenuViewDelegate

-(void)searchMenuView:(SearchMenuView *)view tapStarView:(BOOL)isTap{
//
//    if (self.isStar == NO ) {
//        self.menuView.type = ListStarAscType;
//        self.listType = ListStarAscType;
//    }else{
//        self.menuView.type = ListStarDescType;
//        self.listType = ListStarDescType;
//    }
//
    if (self.isStar == NO ) {
        self.menuView.type = ListStarDescType;
        self.listType = ListStarDescType;
    }else{
        
        
        self.menuView.type = ListStarAscType;
        self.listType = ListStarAscType;
    }
    
    
    
    self.isSalesVolume = NO;
    self.isPriceSorting = NO;
    self.isStar = !self.isStar;
    [self update];
    
}

-(void)searchMenuView:(SearchMenuView *)view tapPriceView:(BOOL)isTap{
    
//    if (self.isPriceSorting == NO ) {
//        self.menuView.type = ListJiaGeAscType;
//        self.listType = ListJiaGeAscType;
//    }else{
//        self.menuView.type = ListJiaGeDescType;
//        self.listType = ListJiaGeDescType;
//    }
    
    if (self.isPriceSorting == NO ) {
        self.menuView.type = ListJiaGeDescType;
        self.listType = ListJiaGeDescType;
    }else{
        self.menuView.type = ListJiaGeAscType;
        self.listType = ListJiaGeAscType;
    }
    self.isSalesVolume = NO;
    self.isStar = NO;
    self.isPriceSorting = !self.isPriceSorting;
    NSLog(@"self.isPriceSorting : %d", self.isPriceSorting);
    [self update];
}

-(void)searchMenuView:(SearchMenuView *)view tapSalesVolumeView:(BOOL)isTap{
    
    
//    if (self.isSalesVolume == NO ) {
//        self.menuView.type = ListXiaoLiangAscType;
//        self.listType = ListXiaoLiangAscType;
//    }else{
//        self.menuView.type = ListXiaoLiangDescType;
//        self.listType = ListXiaoLiangDescType;
//    }
    
    
    if (self.isSalesVolume == NO ) {
        self.menuView.type = ListXiaoLiangDescType;
        self.listType = ListXiaoLiangDescType;
    }else{
        self.menuView.type = ListXiaoLiangAscType;
        self.listType = ListXiaoLiangAscType;
    }
    self.isPriceSorting = NO;
    self.isStar = NO;
    self.isSalesVolume = !self.isSalesVolume;
    [self update];
    
}

#pragma mark - ClassifyGoodsListViewDelegate

-(void)refresh:(UICollectionView *)collectionView{
    self.pageNumber = 1;
    [self.dataArray removeAllObjects];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (self.storeId != nil) {
        [param setValue:self.storeId forKey:@"club_id"];
    }
    
    [param setValue:[NSString stringWithFormat:@"%ld", self.pageNumber] forKey:@"page"];
    [param setValue:self.searchStr forKey:@"name"];
    
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    [[DataManager shareInstance]getGoodsList:param Callback:^(NSArray *result) {
        [hud hideAnimated:YES];
        [self.dataArray addObjectsFromArray:result];
        [self.goodsListView setDataArray:self.dataArray];
        [collectionView.mj_header endRefreshing];
    }];
    
}

-(void)loadData:(UICollectionView *)collectionView{
    
    self.pageNumber ++;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    switch (self.listType) {
        case ListJiaGeDescType:{
            [param setValue:@"1" forKey:@"price"];
            [param setValue:@"desc" forKey:@"sort"];
        }
            
            break;
        case ListJiaGeAscType:{
            [param setValue:@"1" forKey:@"price"];
            [param setValue:@"asc" forKey:@"sort"];
        }
            
            break;
        case ListXiaoLiangDescType:{
            [param setValue:@"1" forKey:@"num"];
            [param setValue:@"desc" forKey:@"sort"];
        }
            
            break;
        case ListXiaoLiangAscType:{
            [param setValue:@"1" forKey:@"num"];
            [param setValue:@"asc" forKey:@"sort"];
        }
            
            break;
        case ListStarAscType:{
            [param setValue:@"0" forKey:@"star"];
        }
            
            break;
            
        case ListStarDescType:{
            [param setValue:@"1" forKey:@"star"];
        }
            
            break;
        default:
            break;
    }
    
    
    if (self.storeId != nil) {
        [param setValue:self.storeId forKey:@"club_id"];
    }
    
    [param setValue:[NSString stringWithFormat:@"%ld", self.pageNumber] forKey:@"page"];
    [param setValue:self.searchStr forKey:@"name"];
    
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    [[DataManager shareInstance]getGoodsList:param Callback:^(NSArray *result) {
        [hud hideAnimated:YES];
        [self.dataArray addObjectsFromArray:result];
        [self.goodsListView setDataArray:self.dataArray];
        [collectionView.mj_footer endRefreshing];
    }];
}

-(void)tapGoodsItem:(WengenGoodsModel *)goodsModel{
    GoodsDetailsViewController *goodsDetailsVC = [[GoodsDetailsViewController alloc]init];
    goodsDetailsVC.goodsModel = goodsModel;
    goodsDetailsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:goodsDetailsVC animated:YES];
}



#pragma mark - getter / setter

//-(WengenSearchView *)searchView{
//    if (_searchView == nil) {
//
//        //状态栏高度
//        CGFloat barHeight ;
//        /** 判断版本
//         获取状态栏高度
//         */
//        if (@available(iOS 13.0, *)) {
//            barHeight = [[[[[UIApplication sharedApplication] keyWindow] windowScene] statusBarManager] statusBarFrame].size.height;
//        } else {
//            barHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
//        }
//        _searchView = [[WengenSearchView alloc]initWithFrame:CGRectMake(0, barHeight, ScreenWidth, 44)];
//        [_searchView setIsHiddenBack:NO];
//        [_searchView setDelegate:self];
//    }
//    return _searchView;
//}


-(SearchNavgationView *)searchView{
    if (_searchView == nil) {
        
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
        _searchView = [[SearchNavgationView alloc]initWithFrame:CGRectMake(0, barHeight, ScreenWidth, 44)];
        [_searchView setDelegate:self];
    }
    return _searchView;
}


-(SearchMenuView *)menuView{
    
    if (_menuView == nil) {
        CGFloat y = CGRectGetMaxY(self.searchView.frame);
        _menuView = [[SearchMenuView alloc]initWithFrame:CGRectMake(0, y, ScreenWidth, 40)];
        [_menuView setDelegate:self];
    }
    return _menuView;
    
}

-(ClassifyGoodsListView *)goodsListView{
    if (_goodsListView == nil) {
        CGFloat y = CGRectGetMaxY(self.menuView.frame);
        _goodsListView = [[ClassifyGoodsListView alloc]initWithFrame:CGRectMake(0, y, ScreenWidth, ScreenHeight - y)];
        [_goodsListView setDelegate:self];
    }
    
    return _goodsListView;
}

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(NSMutableArray *)historyArray{
    if (!_historyArray) {
//           _historyArray = [NSKeyedUnarchiver unarchiveObjectWithFile:KGoodsHistorySearchPath];
        _historyArray = [[[ModelTool shareInstance] select:[SearchHistoryModel class] tableName:@"searchHistory" where:[NSString stringWithFormat:@"type = '%ld' AND userId = '%@' ORDER BY id DESC", SearchHistoryGoodsType, [SLAppInfoModel sharedInstance].id]] mutableCopy];
           if (!_historyArray) {
               self.historyArray = [NSMutableArray array];
           }
       }
       return _historyArray;
}

@end

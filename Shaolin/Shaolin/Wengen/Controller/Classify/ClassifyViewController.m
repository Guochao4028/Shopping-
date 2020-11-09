//
//  ClassifyViewController.m
//  Shaolin
//
//  Created by 郭超 on 2020/3/23.
//  Copyright © 2020 syqaxldy. All rights reserved.
// 分类页

#import "ClassifyViewController.h"

#import "WengenSearchView.h"

#import "ClassifyMenuView.h"

#import "ClassifyGoodsListView.h"

#import "WengenEnterModel.h"

#import "ClassifyDropDownView.h"

#import "GoodsDetailsViewController.h"

//购物车
#import "ShoppingCartViewController.h"

#import "SearchViewController.h"

#import "DataManager.h"

@interface ClassifyViewController ()<WengenSearchViewDelegate, ClassifyMenuViewDelegate, ClassifyGoodsListViewDelegate>

////top 搜索栏
//@property(nonatomic, strong)WengenSearchView *searchView;

//菜单
@property(nonatomic, strong)ClassifyMenuView *menuView;

//商品列表
@property(nonatomic, strong)ClassifyGoodsListView *goodsListView;


//记录选中的分类model
@property(nonatomic, strong)WengenEnterModel *selectModel;

///记录 价格 排序
@property(nonatomic, assign)BOOL isPriceSorting;

///记录 销量 排序
@property(nonatomic, assign)BOOL isSalesVolumeSorting;

@property(nonatomic, assign)ListType listType;

@property(nonatomic, assign)NSInteger pageNumber;

@property(nonatomic, strong)NSMutableArray *dataArray;



@end

@implementation ClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.hideNavigationBar = YES;
    [self initUI];
    
    [self initData];
}

#pragma mark - methods

-(void)initUI{
    [self.view setBackgroundColor:BackgroundColor_White];
//    [self.view addSubview:self.searchView];
    [self.view addSubview:self.menuView];
    [self.view addSubview:self.goodsListView];
}

///初始化数据
-(void)initData{
    
    self.pageNumber = 1;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (self.enterModel != nil) {
        [param setValue:self.enterModel.enterId forKey:@"cate_pid_id"];
    }
     [param setValue:[NSString stringWithFormat:@"%ld", self.pageNumber] forKey:@"page"];
    
    
    [[DataManager shareInstance]getGoodsList:param Callback:^(NSArray *result) {
        [self.dataArray addObjectsFromArray:result];
        [self.goodsListView setDataArray:self.dataArray];
    }];
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
        default:
            break;
    }
    
    if (self.selectModel != nil) {
        [param setValue:self.selectModel.enterId forKey:@"cate_id"];
    }
    
    if (self.enterModel != nil) {
        [param setValue:self.enterModel.enterId forKey:@"cate_pid_id"];
    }
    
    self.pageNumber = 1;
    [param setValue:[NSString stringWithFormat:@"%ld", self.pageNumber] forKey:@"page"];
    
    [self.dataArray removeAllObjects];
    
    [[DataManager shareInstance]getGoodsList:param Callback:^(NSArray *result) {
        [self.dataArray addObjectsFromArray:result];
        [self.goodsListView setDataArray:self.dataArray];
    }];
    
}

-(void)refreshUI{
    [self.goodsListView.collectionView.mj_header beginRefreshing];
}

#pragma mark - WengenSearchViewDelegate
/**
 点击购物车
 */
-(void)tapShopping{
    ShoppingCartViewController *shoppingCartVC = [[ShoppingCartViewController alloc]init];
    shoppingCartVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shoppingCartVC animated:YES];
}

/**
 点击搜索
 */
-(void)tapSearch{
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
}

/**
 点击搜索view上的返回按钮
 */
-(void)tapBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ClassifyMenuViewDelegate

//点击 分类 view
-(void)view:(ClassifyMenuView *)view tapClassifyView:(BOOL)isTap{
    NSArray *son = self.enterModel.son;
    if (son.count > 0) {
        ClassifyDropDownView *dropDoenView = [[ClassifyDropDownView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        
        CGPoint point = [self.menuView convertPoint:CGPointMake(0,20) toView:WINDOWSVIEW];

        dropDoenView.starPoint = point;
        
        [WINDOWSVIEW addSubview:dropDoenView];
        
        __weak typeof(self)weakSelf =self;
        
        dropDoenView.selectedBlock = ^(WengenEnterModel * _Nonnull model) {
            NSLog(@"selectedBlock");
            weakSelf.selectModel = model;
            [weakSelf.menuView setSelectdModel:model];
            [weakSelf.menuView changeClassifyDirection:0];
            
            [weakSelf update];
        };
        dropDoenView.dataArray = son;
        
        [view changeClassifyDirection:1];
    }
   
}

//点击 价格 view
-(void)view:(ClassifyMenuView *)view tapPriceView:(BOOL)isTap{
    if (self.isPriceSorting == NO ) {
        self.menuView.type = ListJiaGeAscType;
        self.listType = ListJiaGeAscType;
    }else{
        self.menuView.type = ListJiaGeDescType;
        self.listType = ListJiaGeDescType;
    }
    self.isPriceSorting = !self.isPriceSorting;
    
    self.isSalesVolumeSorting = NO;
    [self update];
}

//点击 销量 view
-(void)view:(ClassifyMenuView *)view tapSalesVolumeView:(BOOL)isTap{
    if (self.isSalesVolumeSorting == NO ) {
        self.menuView.type = ListXiaoLiangDescType;
        self.listType = ListXiaoLiangDescType;
    }else{
         self.menuView.type = ListXiaoLiangAscType;
         self.listType = ListXiaoLiangAscType;
    }
    
    self.isSalesVolumeSorting = !self.isSalesVolumeSorting;
    
    self.isPriceSorting = NO;
     [self update];
}

#pragma mark - ClassifyGoodsListViewDelegate
-(void)tapGoodsItem:(WengenGoodsModel *)goodsModel{
    GoodsDetailsViewController *goodsDetailsVC = [[GoodsDetailsViewController alloc]init];
    goodsDetailsVC.goodsModel = goodsModel;
    goodsDetailsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:goodsDetailsVC animated:YES];
}

-(void)refresh:(UICollectionView *)collectionView{
    self.pageNumber = 1;
    [self.dataArray removeAllObjects];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
   

    [param setValue:[NSString stringWithFormat:@"%ld", self.pageNumber] forKey:@"page"];
    
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
        default:
            break;
    }
    
    if (self.selectModel != nil) {
        [param setValue:self.selectModel.enterId forKey:@"cate_id"];
    }
    
    if (self.enterModel != nil) {
        [param setValue:self.enterModel.enterId forKey:@"cate_pid_id"];
    }
    [collectionView.mj_footer resetNoMoreData];

    [[DataManager shareInstance]getGoodsList:param Callback:^(NSArray *result) {
        [self.dataArray addObjectsFromArray:result];
        [self.goodsListView setDataArray:self.dataArray];
        [collectionView.mj_header endRefreshing];
    }];
    
}

-(void)loadData:(UICollectionView *)collectionView{
    
    self.pageNumber ++;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
  
    [param setValue:[NSString stringWithFormat:@"%ld", self.pageNumber] forKey:@"page"];
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
           default:
               break;
       }
       
       if (self.selectModel != nil) {
           [param setValue:self.selectModel.enterId forKey:@"cate_id"];
       }
       
       if (self.enterModel != nil) {
           [param setValue:self.enterModel.enterId forKey:@"cate_pid_id"];
       }
    
    [[DataManager shareInstance]getGoodsList:param Callback:^(NSArray *result) {
        if ([result count] > 0) {
            [self.dataArray addObjectsFromArray:result];
            [self.goodsListView setDataArray:self.dataArray];
            [collectionView.mj_footer endRefreshing];
        }else{
            [collectionView.mj_footer endRefreshing];
            [collectionView.mj_footer endRefreshingWithNoMoreData];
        }
        
        
    }];
     
}


#pragma mark - getter / setter
//
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

-(ClassifyMenuView *)menuView{
    if (_menuView == nil) {
        CGFloat y = 0;//CGRectGetMaxY(self.searchView.frame) + 1;
        _menuView = [[ClassifyMenuView alloc]initWithFrame:CGRectMake(0, y, ScreenWidth, 40)];
        [_menuView setDelegate:self];
    }
    return _menuView;
}

-(ClassifyGoodsListView *)goodsListView{
    if (_goodsListView == nil) {
        CGFloat y = CGRectGetMaxY(self.menuView.frame);
        _goodsListView = [[ClassifyGoodsListView alloc]initWithFrame:CGRectMake(0, y, ScreenWidth, ScreenHeight - y - 40-44 - 20)];
        _goodsListView.isCategorize = YES;
        [_goodsListView setDelegate:self];
    }
    
    return _goodsListView;
}

-(void)setEnterModel:(WengenEnterModel *)enterModel{
    _enterModel = enterModel;
    
    self.listType = ListNormalType;
    
    self.selectModel.isSelected = NO;
    
    self.selectModel = nil;
    
    [self.menuView setModel:enterModel];
}

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


@end

//
//  WengenViewController.m
//  Shaolin
//
//  Created by edz on 2020/3/4.
//  Copyright © 2020 syqaxldy. All rights reserved.
// 文创 商城 首页

#import "WengenViewController.h"
//#import "WengenSearchView.h"
#import "LGFCenterPageVC.h"
#import "LGFCenterPageChildVC.h"
#import "LGFOCTool.h"

#import "WengenBannerTableCell.h"

#import "WengenCategoryTableCell.h"

#import "WengenStrictSelectionTableCell.h"

#import "RecommendTableCell.h"

#import "WengenBannerModel.h"

#import "WengenEnterModel.h"

#import "WengenGoodsModel.h"

//UICollectionView 上的cell
#import "WengenGoodsCollectionCell.h"

//分类列表
#import "ClassifyViewController.h"

#import "ClassifyHomeViewController.h"

#import "GoodsDetailsViewController.h"

//购物车
#import "ShoppingCartViewController.h"

#import "LoginManager.h"

#import "WengenBannerDetailsViewController.h"

#import "SearchViewController.h"

#import "WengenWebViewController.h"
#import "DataManager.h"

#import"UIBarButtonItem+Badge.h"

static NSString *const kWengenBannerTableCellIdentifier = @"WengenBannerTableCell";

static NSString *const kWengenCategoryTableCellIdentifier = @"WengenCategoryTableCell";

static NSString *const kRecommendTableCellIdentifier = @"RecommendTableCell";

static NSString *const kWengenStrictSelectionTableCellIdentifier = @"WengenStrictSelectionTableCell";

//@interface WengenViewController ()<LGFCenterPageVCDelegate, WengenSearchViewDelegate,UITableViewDelegate, UITableViewDataSource,WengenCategoryTableCellDelegate, WengenBannerTableCellDelegate, RecommendTableCellDelegate, WengenStrictSelectionTableCellDelegate>

@interface WengenViewController ()<LGFCenterPageVCDelegate,UITableViewDelegate, UITableViewDataSource,WengenCategoryTableCellDelegate, WengenBannerTableCellDelegate, RecommendTableCellDelegate, WengenStrictSelectionTableCellDelegate>

//top 搜索栏
//@property(nonatomic, strong)WengenSearchView *searchView;
//pageView
@property(nonatomic, strong)UIView *pageView;
//heardView 放tableView
@property(nonatomic, strong)UITableView *tableView;
//首页底部分类展示容器
@property(strong, nonatomic)LGFCenterPageVC *pageVC;
//底部分类标题数组
@property(nonatomic, strong)NSMutableArray *titles;

@property (nonatomic, strong)NSMutableArray *titleArray;
//banner
@property(nonatomic, strong)NSArray  *bannerArray;

//分类数据
@property(nonatomic, strong)NSArray *categoryArray;

//新人推荐商品
@property(nonatomic, strong)NSArray *recommendGoodsArray;

//严选商品数据
@property(nonatomic, strong)NSArray *strictSelectionArray;

//商品全部分类
@property(nonatomic, strong)NSArray *allGoodsCateList;

@property(nonatomic, strong)LGFFreePTStyle *style;

@end

@implementation WengenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    self.hideNavigationBar = YES;
    [self initData];
    [self initUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[DataManager shareInstance] getOrderAndCartCount];
    
    //    [self.searchView layoutSubviews];
    
    UIButton *leftButton = [self leftBtn];
    leftButton.titleLabel.font = kMediumFont(20);
    [leftButton setTitle:SLLocalizedString(@"文创") forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [leftButton setTitleColor:KTextGray_333 forState:UIControlStateNormal];
    
    UIButton *rightButton = [self rightBtn];
    [rightButton setImage:[UIImage imageNamed:@"new_shop_car"] forState:UIControlStateNormal];
    
    [self hideNavigationBarShadow];
    
    NSString *carCountStr = [[ModelTool shareInstance]carCount];
    self.navigationItem.rightBarButtonItem.badgeTextColor = kMainYellow;
    self.navigationItem.rightBarButtonItem.badgeMinSize = 9;
    self.navigationItem.rightBarButtonItem.badgeFont = kRegular(8);
    self.navigationItem.rightBarButtonItem.badgeValue = carCountStr;
    [self.navigationItem.rightBarButtonItem.badge.layer setBorderColor:kMainYellow.CGColor];
    [self.navigationItem.rightBarButtonItem.badge.layer setBorderWidth:1];
    [self.navigationItem.rightBarButtonItem.badge setTextColor:kMainYellow];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

#pragma mark - methods
/// 初始化UI
-(void)initUI{
    
    //    [self.view addSubview:self.searchView];
    
    [self.view addSubview:self.pageView];
    [self configPage];
    [lgf_NCenter addObserver:self selector:@selector(childScroll:) name:@"LGFChildScroll" object:nil];
    if (@available(iOS 11.0, *)) {
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

///配置分页联动
- (void)configPage {
    // 配置 LGFFreePTStyle
    self.pageVC.lgf_PageTitleStyle = self.style;// 设置 LGFFreePTStyle
}

///初始化数据
-(void)initData{
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    dispatch_group_t group = dispatch_group_create();
    
    [self requestBannerWithGroup:group];
    
    [self requestAllClassificationWithGroup:group];
    
    [self requestClassificationWithGroup:group];
    
    [self requestRecommendnWithGroup:group];
    
    [self requestStrictSelectionWithGroup:group];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [hud hideAnimated:YES];
        [self p_calculateHeight];
        [self.pageVC reloadPageTitleWidthArray:self.titles];// 刷新 LGFFreePTView
        [self.tableView reloadData];
    });
    
}

///请求banner
-(void)requestBannerWithGroup:(dispatch_group_t)group{
    dispatch_group_enter(group);
    //banner
    [[DataManager shareInstance]getBanner:@{@"module":@"3", @"fieldId":@"0"} Callback:^(NSArray *result) {
        self.bannerArray = [NSArray arrayWithArray:result];
        dispatch_group_leave(group);
    }];
}

///请求分类
-(void)requestClassificationWithGroup:(dispatch_group_t)group{
    dispatch_group_enter(group);
    
    
    //分类
    [[DataManager shareInstance]getIndexClassification:^(NSArray *result) {
        
        self.categoryArray  = result;
        self.titles = [NSMutableArray array];
        
        [self.titles addObject:SLLocalizedString(@"全部商品")];
        for (WengenEnterModel *model in self.categoryArray) {
            [self.titles addObject:model.name];
        }
        dispatch_group_leave(group);
    }];
}

///请求全部分类
-(void)requestAllClassificationWithGroup:(dispatch_group_t)group{
    dispatch_group_enter(group);
    //获取全部商品分类类型
    [[DataManager shareInstance]getAllGoodsCateList:^(NSArray *result) {
        
        NSMutableArray *tempMutableArray = [NSMutableArray array];
        for (WengenEnterModel *model in result) {
            if ([model.status integerValue] == 1) {
                [tempMutableArray addObject:model];
            }
        }
        self.allGoodsCateList = tempMutableArray;
        dispatch_group_leave(group);
        
        
    }];
}

///请求新人推荐商品
-(void)requestRecommendnWithGroup:(dispatch_group_t)group{
    dispatch_group_enter(group);
    [[DataManager shareInstance]getRecommendGoodsCallback:^(NSArray *result) {
        self.recommendGoodsArray = result;
        dispatch_group_leave(group);
    }];
}

///请求严选商品
-(void)requestStrictSelectionWithGroup:(dispatch_group_t)group{
    dispatch_group_enter(group);
    //严选商品
    [[DataManager shareInstance]getStrictSelectionGoodsCallback:^(NSArray *result) {
        self.strictSelectionArray = result;
        dispatch_group_leave(group);
    }];
    
}

///更新数据数据
-(void)updataAndUI{
    
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    dispatch_group_t group = dispatch_group_create();
    
    [self requestBannerWithGroup:group];
    
    [self requestAllClassificationWithGroup:group];
    
    [self requestClassificationWithGroup:group];
    
    [self requestRecommendnWithGroup:group];
    
    [self requestStrictSelectionWithGroup:group];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [hud hideAnimated:YES];
        [self.tableView reloadData];
    });
    
    //    //获取全部商品分类类型
    //    [[DataManager shareInstance]getAllGoodsCateList:^(NSArray *result) {
    //        NSMutableArray *tempMutableArray = [NSMutableArray array];
    //        for (WengenEnterModel *model in result) {
    //            if ([model.status integerValue] == 1) {
    //                [tempMutableArray addObject:model];
    //            }
    //        }
    //        self.allGoodsCateList = tempMutableArray;
    //    }];
    //
    //    //banner
    //    [[DataManager shareInstance]getBanner:@{@"module":@"3", @"fieldId":@"0"} Callback:^(NSArray *result) {
    //        self.bannerArray = [NSArray arrayWithArray:result];
    //        [self.tableView reloadData];
    //    }];
    //
    //    //分类
    //    [[DataManager shareInstance]getIndexClassification:^(NSArray *result) {
    //
    //        self.categoryArray  = result;
    //
    //        self.titles = [NSMutableArray array];
    //
    //        [self.titles addObject:SLLocalizedString(@"全部商品")];
    //        for (WengenEnterModel *model in self.categoryArray) {
    //            [self.titles addObject:model.name];
    //        }
    //
    //        [self.tableView reloadData];
    //    }];
    //
    //
    //    //新人推荐商品
    //    [[DataManager shareInstance]getRecommendGoodsCallback:^(NSArray *result) {
    //        self.recommendGoodsArray = result;
    //        [self.tableView reloadData];
    //    }];
    //
    //    //严选商品
    //    [[DataManager shareInstance]getStrictSelectionGoodsCallback:^(NSArray *result) {
    //        self.strictSelectionArray = result;
    //        [self.tableView reloadData];
    //    }];
}

#pragma mark - 计算头部高度
-(void)p_calculateHeight{
    
    //banner
    CGFloat bannerHeight = 154;
    //分类
    CGFloat categoryHeight = 200;
    
    NSInteger count = self.categoryArray.count;
    
    if (count > 4) {
        categoryHeight = 200;
    }else if ( count > 0 && count <= 4){
        categoryHeight = 96;
    }else{
        categoryHeight = 0;
    }
    
    // 为你推荐
    CGFloat headerHeight = 25;
    //推荐
    CGFloat recommendedHeight = 96;
    //LGFFreePTView
    CGFloat ptHeaderHeight = 40;
    
    CGFloat lgf_HeaderHeight = bannerHeight + categoryHeight + headerHeight +recommendedHeight + ptHeaderHeight;
    
    self.pageVC.lgf_HeaderHeight = lgf_HeaderHeight; // header 高度 + LGFFreePTView 高度
}

#pragma mark - action

- (void)rightAction{
    [self tapShopping];
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

#pragma mark - WengenBannerTableCellDelegate
/**
 banner 点击方法
 */
-(void)pushToOtherViewControllerwithHomeItem:(WengenBannerModel *)item{
    
    [[SLAppInfoModel sharedInstance] bannerEventResponseWithBannerModel:item];
    
    if ([item.type intValue] == 2) {
        // 内链，如果在商城首页点击banner图，需要跳转到分类列表里时，SLAppInfoModel没有办法通过一个字段处理，所以跳转逻辑单独写在这里
        
        NSData *jsonData = [item.contentUrl dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers error:&err];
        
        BannerSubModel * subM = [BannerSubModel mj_objectWithKeyValues:dic];
        
        //        BannerSubModel * subM = item.bannerDetailsV;
        if ([subM.module intValue] == 3) {
            // 文创
            if ([subM.type intValue] == 1) {
                NSInteger location = 0;
                NSMutableArray *titles = [NSMutableArray array];
                for (int i = 0; i < self.allGoodsCateList.count; i++) {
                    WengenEnterModel *tem = self.allGoodsCateList[i];
                    [titles addObject:tem.name];
                    
                    if ([tem.enterId isEqualToString:subM.fieldId]) {
                        location = i;
                    }
                }
                
                ClassifyHomeViewController *classifyHomeVC = [[ClassifyHomeViewController alloc]init];
                classifyHomeVC.allGoodsCateList = self.allGoodsCateList;
                classifyHomeVC.titles = titles;
                classifyHomeVC.loction = location;
                classifyHomeVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:classifyHomeVC animated:YES];
            }
        }
    }
}

#pragma mark - WengenCategoryTableCellDelegate

-(void)cell:(WengenCategoryTableCell *)cell selectItem:(nonnull WengenEnterModel *)model{
    //    WengenEnterModel *temp;
    //    for (WengenEnterModel *tem in self.allGoodsCateList) {
    //        if ([tem.enterId isEqualToString:model.enterId] == YES) {
    //            temp = tem;
    //        }
    //    }
    //    ClassifyViewController *classifyVC = [[ClassifyViewController alloc]init];
    //
    //    classifyVC.enterModel = temp;
    
    NSMutableArray *titles = [NSMutableArray array];
    for (WengenEnterModel *tem in self.allGoodsCateList) {
        [titles addObject:tem.name];
    }
    
    ClassifyHomeViewController *classifyHomeVC = [[ClassifyHomeViewController alloc]init];
    classifyHomeVC.allGoodsCateList = self.allGoodsCateList;
    classifyHomeVC.titles = titles;
    classifyHomeVC.loction = cell.loction;
    
    classifyHomeVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:classifyHomeVC animated:YES];
    
}

#pragma mark - RecommendTableCellDelegate
/**
 点击新人推荐商品 上的 商品
 */
-(void)tapGoodsItem:(WengenGoodsModel *)model{
    GoodsDetailsViewController *goodsDetailsVC = [[GoodsDetailsViewController alloc]init];
    goodsDetailsVC.goodsModel = model;
    goodsDetailsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:goodsDetailsVC animated:YES];
}

/**
 点击新人推荐商品 上的 标题
 */
-(void)tapTitleItem{
    WengenBannerDetailsViewController *bannerDetailVC = [[WengenBannerDetailsViewController alloc]init];
    bannerDetailVC.type = @"Recommend";
    bannerDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bannerDetailVC animated:YES];
}

#pragma mark - WengenStrictSelectionTableCellDelegate
/**
 严选上的banner
 */
-(void)tapBanner:(WengenBannerModel *)bannerModel{
    WengenBannerDetailsViewController *bannerDetailVC = [[WengenBannerDetailsViewController alloc]init];
    bannerDetailVC.type = @"StrictSelection";
    bannerDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bannerDetailVC animated:YES];
}

/**
 点击 严选上的商品
 */
-(void)tapStrictSelectionGoodsItem:(WengenGoodsModel *)goodsModel{
    
    GoodsDetailsViewController *goodsDetailsVC = [[GoodsDetailsViewController alloc]init];
    goodsDetailsVC.goodsModel = goodsModel;
    goodsDetailsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:goodsDetailsVC animated:YES];
}

-(void)tapStrictSelectionItem:(BOOL)isSelected{
    WengenBannerDetailsViewController *bannerDetailVC = [[WengenBannerDetailsViewController alloc]init];
    bannerDetailVC.type = @"StrictSelection";
    bannerDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bannerDetailVC animated:YES];
}

-(void)tapRecommendedItem:(BOOL)isSelected{
    WengenBannerDetailsViewController *bannerDetailVC = [[WengenBannerDetailsViewController alloc]init];
    bannerDetailVC.type = @"Recommend";
    bannerDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bannerDetailVC animated:YES];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 0) {
        return .001;
    }
    return .001;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 1) {
        //        return 40;
        return 25;
    }
    return 0.01;
}

-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    
    UIImageView * pointImgv = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 10, 10)];
    pointImgv.image = [UIImage imageNamed:@"new_sectionHeaderPoint"];
    [view addSubview:pointImgv];
    
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(25 + 8, 5, 80, 20)];
    label.text = @"为你推荐";
    label.font = kMediumFont(18);
    label.textColor = [UIColor hexColor:@"030303"];
    
    UIImageView * lineImgv = [[UIImageView alloc] initWithFrame:CGRectMake(25 + 8, label.bottom - 5, 70, 8)];
    lineImgv.image = [UIImage imageNamed:@"new_sectionHeaderLine"];
    [view addSubview:lineImgv];
    
    [view addSubview:label];
    
    view.hidden = YES;
    
    if (section == 1) {
        view.hidden = NO;
    }
    
    return view;
}

-(UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = UIColor.whiteColor;
    return view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if (self.categoryArray.count > 0) {
            return 2;
        }else{
            return 1;
        }
    }else{
        return 1;
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat tableViewH = 0;
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:{
                //banner
                tableViewH = kBannerHeight + 9;
            }
                break;
            case 1:
            {
                //分类
                NSInteger count = self.categoryArray.count;
                
                if (count > 4) {
                    tableViewH = 200;
                }else if ( count > 0 && count <= 4){
                    tableViewH = 96;
                }else{
                    tableViewH = 0;
                }
                
            }
                break;
        }
    }else if(indexPath.section == 1){
        
        //新人推荐
        //        tableViewH = 160;
        tableViewH = 96;
        //    }
        //    else if(indexPath.section == 2){
        //        //严选
        //        tableViewH = 324;
    }
    
    
    
    //    else{
    //        tableViewH = 870;
    //    }
    
    return tableViewH;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 0) {
                WengenBannerTableCell *bannerCell = [tableView dequeueReusableCellWithIdentifier:kWengenBannerTableCellIdentifier];
                bannerCell.dataSource = self.bannerArray;
                [bannerCell setDelegate:self];
                cell = bannerCell;
            }else{
                WengenCategoryTableCell *categoryCell = [tableView dequeueReusableCellWithIdentifier:kWengenCategoryTableCellIdentifier];
                [categoryCell setDelegate:self];
                categoryCell.dataArray = self.categoryArray;
                cell = categoryCell;
            }
        }
            break;
            
            //        case 1:{
            //            // 新人推荐
            //            RecommendTableCell *recommendCell = [tableView dequeueReusableCellWithIdentifier:kRecommendTableCellIdentifier];
            //            [recommendCell setDelegate:self];
            //            recommendCell.dataArray = self.recommendGoodsArray;
            //            cell = recommendCell;
            //        }
            //            break;
        case 1:{
            // 严选
            WengenStrictSelectionTableCell *strictSelectionCell = [tableView dequeueReusableCellWithIdentifier:kWengenStrictSelectionTableCellIdentifier];
            [strictSelectionCell setDelegate:self];
            
            //            strictSelectionCell.goodsArray = self.strictSelectionArray;
            
            cell = strictSelectionCell;
        }
            break;
        case 2:{
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        }
            break;
            
        default:{
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        }
            break;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - 内部滚动监听
- (void)childScroll:(NSNotification *)noti {
    // noti.object @[@(contentOffset.y), @(选中的子控制器 index)]
//    CGFloat offsetY = [noti.object[0] floatValue];
//    NSLog(@"offsetY : %f", offsetY);
}


-(void)searchDidSelectHandle {
    [self tapSearch];
}

#pragma mark - LGFCenterPageChildVC Delegate
// 加载数据
- (void)lgf_CenterPageChildVCLoadData:(LGFCenterPageChildVC *)VC selectIndex:(NSInteger)selectIndex loadType:(lgf_LoadType)loadType {
    WengenEnterModel *model;
    NSInteger index = selectIndex - 1;
    if ( index >= 0) {
        model = self.categoryArray[index];
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (model != nil) {
        [param setValue:model.enterId forKey:@"cate_pid_id"];
    }
    
    [param setValue:[NSString stringWithFormat:@"%ld",VC.lgf_Page] forKey:@"page"];
    
    //    [self.view lgf_ShowToastActivity:UIEdgeInsetsZero isClearBack:YES cornerRadius:0 style:UIActivityIndicatorViewStyleGray];
    
    [[DataManager shareInstance]getGoodsList:param Callback:^(NSArray *result) {
        if (VC.lgf_Page == 1) {
            VC.lgf_PageChildDataArray = [NSMutableArray arrayWithArray:result];
        }else{
            [VC.lgf_PageChildDataArray addObjectsFromArray:result];
        }
        
        [VC.lgf_CenterChildPageCV reloadData];
        [VC lgf_SynContentSize];
        if (result.count > 0) VC.lgf_Page++;
        [VC lgf_PageEndRefreshing];
        [self.view lgf_HideToastActivity];
        
    }];
    
    if (loadType == lgf_LoadData) {
        [self updataAndUI];
    }
    
    
}

- (void)lgf_CenterChildPageVCDidLoad:(LGFCenterPageChildVC *)VC {
    /**
     底部的高度 底部tabbar的高度
     */
    VC.lgf_PageCVBottom = Height_TabBar;
}

// cell 数量
-(NSInteger)lgf_NumberOfItems:(LGFCenterPageChildVC *)VC {
    return VC.lgf_PageChildDataArray.count;
}

// cell 高度
-(CGSize)lgf_SizeForItemAtIndexPath:(NSIndexPath *)indexPath VC:(LGFCenterPageChildVC *)VC {
    NSLog(@"ScreenWidth : %f",ScreenWidth);
    CGSize size = CGSizeMake((ScreenWidth - 24 ) / 2, (264 *WIDTHTPROPROTION));
    
    return size;
}

- (UIEdgeInsets)lgf_EdgeInsetsForItemAtinsetForSectionAtIndex:(NSInteger)section VC:(UIViewController *)VC{
    
    return UIEdgeInsetsMake(0, 12, 0, 12);
}

// 传入要注册的自定义 cell class
-(Class)lgf_CenterChildPageCVCellClass:(LGFCenterPageChildVC *)VC {
    return [WengenGoodsCollectionCell class];
}
// 配置 cell 数据
- (void)lgf_CenterChildPageVC:(LGFCenterPageChildVC *)VC cell:(UICollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    
    WengenGoodsCollectionCell *itemCell = (WengenGoodsCollectionCell *)cell;
    itemCell.model = VC.lgf_PageChildDataArray[indexPath.row];
    
}
// cell 点击
- (void)lgf_CenterChildPageVC:(LGFCenterPageChildVC *)VC didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([VC.lgf_PageChildDataArray count] == 0) {
        return;
    }
    WengenGoodsModel * model = VC.lgf_PageChildDataArray[indexPath.row];
    
    GoodsDetailsViewController *goodsDetailsVC = [[GoodsDetailsViewController alloc]init];
    goodsDetailsVC.goodsModel = model;
    goodsDetailsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:goodsDetailsVC animated:YES];
}


#pragma mark - getter / setter
- (UIView *)titleCenterView{
    return self.searchView;
}

- (NSMutableArray *)titleArray{
    if (!_titleArray) {
        _titleArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _titleArray;
}

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
//        _searchView.isHiddeIcon = NO;
//        [_searchView setDelegate:self];
//    }
//    return _searchView;
//}

-(UIView *)pageView{
    if (_pageView == nil) {
        //        CGFloat y = CGRectGetMaxY(self.searchView.frame);
        CGFloat y = 0;
        _pageView = [[UIView alloc]initWithFrame:CGRectMake(0, y, ScreenWidth , ScreenHeight - y - TabbarHeight)];
        [_pageView setBackgroundColor:[UIColor redColor]];
    }
    return _pageView;
}

-(LGFFreePTStyle *)style{
    if (_style == nil) {
        _style = [LGFFreePTStyle lgf];
        _style.lgf_PVTitleViewFrame = CGRectMake(16, 0, ScreenWidth-16, 40);
        _style.lgf_TitleFixedWidth = 60.0 + 34;
        _style.lgf_LineWidthType = lgf_FixedWith;
        _style.lgf_LineWidth = 17.5;
        _style.lgf_LineHeight = 3.5;
        _style.lgf_LineColor = kMainYellow;
        _style.lgf_TitleSelectColor = kMainYellow;
        _style.lgf_UnTitleSelectColor = KTextGray_333;
        _style.lgf_LineAnimation = lgf_PageLineAnimationDefult;
        _style.lgf_PVTitleViewBackgroundColor = UIColor.whiteColor;
    }
    return _style;
}

-(LGFCenterPageVC *)pageVC{
    if (_pageVC == nil) {
        _pageVC = [LGFCenterPageVC lgf];
        _pageVC.view.backgroundColor = UIColor.whiteColor;//RGBA(243, 243, 243, 1);
        _pageVC.delegate = self;
        _pageVC.lgf_NavigationBarHeight = 0;// navigationBar 高度
        
        _pageVC.lgf_HeaderHeight = 0;
        
        _pageVC.lgf_PageTitleViewHeight = 40;// LGFFreePTView 高度
        _pageVC.lgf_HeaderView = self.tableView;// 设置自定义头部视图
        [_pageVC lgf_ShowInVC:self view:self.pageView];// 添加封装好的控制器
    }
    return _pageVC;
}

-(UITableView *)tableView{
    if (_tableView == nil) {
        //        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 985) style:UITableViewStyleGrouped];
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 985) style:UITableViewStyleGrouped];
        
        [_tableView setBackgroundColor:[UIColor redColor]];
        
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        
        [_tableView registerClass:[WengenBannerTableCell class] forCellReuseIdentifier:kWengenBannerTableCellIdentifier];
        
        [_tableView registerClass:[WengenCategoryTableCell class] forCellReuseIdentifier:kWengenCategoryTableCellIdentifier];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RecommendTableCell class])bundle:nil] forCellReuseIdentifier:kRecommendTableCellIdentifier];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WengenStrictSelectionTableCell class])bundle:nil] forCellReuseIdentifier:kWengenStrictSelectionTableCellIdentifier];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView setBackgroundColor:UIColor.whiteColor];
        _tableView.scrollEnabled = NO;
    }
    
    return _tableView;
}


#pragma mark - device
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#pragma mark - dealloc
- (void)dealloc {
    [lgf_NCenter removeObserver:self];
}


@end

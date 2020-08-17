//
//  MeVoucherViewController.m
//  Shaolin
//
//  Created by 王精明 on 2020/6/4.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "MeVoucherViewController.h"
#import "MeVoucherModel.h"
#import "MeVoucherCollectionViewCell.h"
#import "MeManager.h"

//#define MEVOUCHERTEST

static NSString *const MeVoucherCollectionViewCellIdentifier = @"MeVoucherCollectionViewCell";

@interface MeVoucherViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UICollectionView *voucherCollectionView;
@property (nonatomic, strong) NSMutableArray <MeVoucherModel *> *meVoucherList;
@property (nonatomic, strong) LYEmptyView *emptyView;
@property (nonatomic) NSInteger pageNum;
@property (nonatomic) NSInteger pageSize;
@end

@implementation MeVoucherViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self wr_setNavBarShadowImageHidden:YES];
    [self wr_setNavBarBarTintColor:[UIColor colorWithRed:46.0/255 green:46.0/255 blue:48.0/255 alpha:1]];
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    self.titleLabe.text = SLLocalizedString(@"补考凭证");
    self.titleLabe.textColor = [UIColor whiteColor];
    
    [self.leftBtn setImage:[UIImage imageNamed:@"real_left"] forState:(UIControlStateNormal)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNum = 1;
    self.pageSize = 30;
    self.meVoucherList = [@[] mutableCopy];
    [self setUI];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    CGFloat headerViewH = SLChange(192);
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(-NavBar_Height - 5);
        make.width.mas_equalTo(self.view);
        make.height.mas_equalTo(headerViewH);
    }];
    [self.voucherCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.headerView).mas_offset(NavBar_Height + 5 + 8);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)setUI{
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.voucherCollectionView];
}

#pragma mark - test
- (NSArray *)testMevoucherList{
    NSInteger count = arc4random()%15;
    NSMutableArray *mArray = [@[] mutableCopy];
    for (int i = 0; i < count; i++){
        [mArray addObject:[MeVoucherModel new]];
    }
    return mArray;
}
#pragma mark - requestData
- (void)update{
    self.pageNum = 1;
    [self.meVoucherList removeAllObjects];
    WEAKSELF
    [self requestData:^(NSArray *downloadArray) {
        if (downloadArray.count == 0){
            [weakSelf setNoData];
        }
        [weakSelf.voucherCollectionView.mj_header endRefreshing];
        if (downloadArray.count < weakSelf.pageSize){
            [weakSelf.voucherCollectionView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [weakSelf.voucherCollectionView.mj_footer endRefreshing];
        }
    }];
}

- (void)loadMoreData{
    self.pageNum++;
    WEAKSELF
    [self requestData:^(NSArray *downloadArray) {
        if (downloadArray.count == 0){
            [weakSelf.voucherCollectionView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [weakSelf.voucherCollectionView.mj_footer endRefreshing];
        }
    }];
}

- (void)requestData:(void (^)(NSArray *downloadArray))finish{
    NSDictionary *params = @{
        @"pageSize" : [NSString stringWithFormat:@"%ld", self.pageSize],
        @"pageNum" : [NSString stringWithFormat:@"%ld", self.pageNum],
    };
//    MBProgressHUD * hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    WEAKSELF
    [[MeManager sharedInstance] postExamProof:params finish:^(id _Nonnull responseObject, NSString * _Nonnull errorReason) {
//        [hud hideAnimated:YES];
#ifdef MEVOUCHERTEST
        weakSelf.meVoucherList = [weakSelf testMevoucherList];
#else
        if ([ModelTool checkResponseObject:responseObject]){
            NSDictionary *data = responseObject[DATAS];
            NSArray *array = [data objectForKey:DATAS];
            NSArray *dataList = [MeVoucherModel mj_objectArrayWithKeyValuesArray:array];
            [weakSelf.meVoucherList addObjectsFromArray:dataList];
            if (finish) finish(dataList);
        } else {
            [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
            if (finish) finish(nil);
        }
#endif
        [weakSelf reloadCollectionView];
        [weakSelf.voucherCollectionView.mj_header endRefreshing];
    }];
}

- (void)reloadCollectionView{
    [self.voucherCollectionView reloadData];
}

#pragma mark - CollectionView Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.meVoucherList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MeVoucherCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MeVoucherCollectionViewCellIdentifier forIndexPath:indexPath];
    cell.model = self.meVoucherList[indexPath.row];
#ifdef MEVOUCHERTEST
    [cell testUI];
#endif
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}
#pragma mark - getter、setter
- (UIImageView *)headerView{
    if (!_headerView){
        _headerView = [[UIImageView alloc] init];
        _headerView.image = [UIImage imageNamed:@"meVoucherHeader"];
        _headerView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _headerView;
}

- (UICollectionView *)voucherCollectionView{
    if (!_voucherCollectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing = 20;
        layout.itemSize = CGSizeMake(SLChange(340), SLChange(175));
        
        _voucherCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _voucherCollectionView.dataSource = self;
        _voucherCollectionView.delegate = self;
        _voucherCollectionView.backgroundColor = [UIColor clearColor];
        [_voucherCollectionView registerClass:[MeVoucherCollectionViewCell class] forCellWithReuseIdentifier:MeVoucherCollectionViewCellIdentifier];
        
        WEAKSELF
        MJRefreshNormalHeader *headerView = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf update];
        }];
        headerView.stateLabel.textColor = [UIColor whiteColor];
        headerView.lastUpdatedTimeLabel.textColor = [UIColor whiteColor];
        headerView.loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        _voucherCollectionView.mj_header = headerView;
        _voucherCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            // 上拉加载
            [weakSelf loadMoreData];
        }];
        
        [_voucherCollectionView.mj_header beginRefreshing];
    }
    return _voucherCollectionView;
}

- (void)setNoData {
    WEAKSELF
    LYEmptyView *emptyView = [LYEmptyView emptyActionViewWithImageStr:@"categorize_nogoods"
                                                             titleStr:SLLocalizedString(@"暂无凭证")
                                                            detailStr:@""
                                                          btnTitleStr:nil//SLLocalizedString(@"点击加载")
                                                        btnClickBlock:^(){
        [weakSelf update];
    }];
    emptyView.subViewMargin = 12.f;
    
    emptyView.titleLabTextColor = RGBA(125, 125, 125,1);
    
    emptyView.detailLabTextColor =  RGBA(192, 192, 192,1);
    
    emptyView.actionBtnFont = [UIFont systemFontOfSize:15.f];
    emptyView.actionBtnTitleColor =  RGBA(90, 90, 90,1);
    emptyView.actionBtnHeight = 30.f;
    emptyView.actionBtnHorizontalMargin = 22.f;
    emptyView.actionBtnCornerRadius = 2.f;
    emptyView.actionBtnBorderColor =  RGBA(150, 150, 150,1);
    emptyView.actionBtnBorderWidth = 0.5;
    emptyView.actionBtnBackGroundColor = [UIColor colorForHex:@"FFFFFF"];
    self.voucherCollectionView.ly_emptyView = emptyView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

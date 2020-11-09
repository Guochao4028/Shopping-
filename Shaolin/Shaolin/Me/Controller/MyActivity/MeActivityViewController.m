//
//  MeActivityViewController.m
//  Shaolin
//
//  Created by 王精明 on 2020/5/29.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "MeActivityViewController.h"
#import "MeActivityCollectionViewCell.h"
#import "MeManager.h"
#import "MeActivityModel.h"
#import "KungfuWebViewController.h"
#import "DefinedHost.h"
#import "QRCodeViewController.h"

typedef NS_ENUM(NSInteger, MeActivityTitleButtonEnum) {
    MeActivityTitleButtonEnum_SignUp = 101,//已签约活动
    MeActivityTitleButtonEnum_Join,//已加入活动
};

static NSString *const MeActivityCollectionViewCellIdentifier = @"MeActivityCollectionViewCell";

@interface MeActivityViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UICollectionView *activityCollectionView;
@property (nonatomic, assign) MeActivityTitleButtonEnum currentData;
@property (nonatomic, strong) NSMutableArray <MeActivityModel *> *meActivityList;
@property (nonatomic, strong) LYEmptyView *emptyView;
@property (nonatomic) NSInteger pageNum;
@property (nonatomic) NSInteger pageSize;
@end

@implementation MeActivityViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBarRedTintColor];
    [self hideNavigationBarShadow];

    self.titleLabe.text = SLLocalizedString(@"我的活动");
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNum = 1;
    self.pageSize = 30;
    self.meActivityList = [@[] mutableCopy];
    self.currentData = MeActivityTitleButtonEnum_SignUp;
    
    [self setUI];
    [self update];

    // Do any additional setup after loading the view.
}

- (void)setUI{
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.activityCollectionView];
    [self setNoData];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    CGFloat headerViewH = 184;
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(-NavBar_Height - 5);
        make.width.mas_equalTo(self.view);
        make.height.mas_equalTo(headerViewH);
    }];
    
    [self.activityCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.headerView).mas_offset(NavBar_Height + 5 + 40);
        make.bottom.mas_equalTo(-kBottomSafeHeight);
    }];
}

- (void)reloadCollectionView{
    [self.activityCollectionView reloadData];
    [self.activityCollectionView layoutIfNeeded];
}

#pragma mark requestData -
- (void)update{
    self.pageNum = 1;
    WEAKSELF
    [self requestData:^(NSArray *downloadArray) {
        weakSelf.meActivityList = [downloadArray mutableCopy];
        [weakSelf.activityCollectionView.mj_header endRefreshing];
        [weakSelf.activityCollectionView.mj_footer endRefreshing];
        if (downloadArray.count < weakSelf.pageSize){
            [weakSelf.activityCollectionView.mj_footer endRefreshingWithNoMoreData];
        }
        [weakSelf reloadCollectionView];
        if (downloadArray.count == 0){
            [weakSelf setNoData];
        } else {
            [weakSelf.activityCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
//            [weakSelf.activityCollectionView setContentOffset:CGPointZero animated:YES];
        }
    }];
}

- (void)loadMoreData{
    self.pageNum++;
    WEAKSELF
    [self requestData:^(NSArray *downloadArray) {
        [weakSelf.meActivityList addObjectsFromArray:downloadArray];
        if (downloadArray.count == 0){
            [weakSelf.activityCollectionView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [weakSelf.activityCollectionView.mj_footer endRefreshing];
        }
        [weakSelf reloadCollectionView];
    }];
}

- (void)requestData:(void (^)(NSArray *downloadArray))finish{
    NSString *activityType = @"";
    if (self.currentData == MeActivityTitleButtonEnum_SignUp){
        activityType = @"1";
    } else if (self.currentData == MeActivityTitleButtonEnum_Join){
        activityType = @"2";
    }
    NSDictionary *params = @{
        @"typeId":activityType,
        @"pageSize" : [NSString stringWithFormat:@"%ld", self.pageSize],
        @"pageNum" : [NSString stringWithFormat:@"%ld", self.pageNum],
    };
    MBProgressHUD * hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    [[MeManager sharedInstance] postMeActivityList:params finish:^(id  _Nonnull responseObject, NSString * _Nonnull errorReason) {
        if ([ModelTool checkResponseObject:responseObject]){
            NSDictionary *data = responseObject[DATAS];
            NSArray *array = [data objectForKey:@"data"];
            array = [MeActivityModel mj_objectArrayWithKeyValuesArray:array];
            if (finish) finish(array);
        } else {
            [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
            if (finish) finish(nil);
        }
        [hud hideAnimated:YES];
    }];
}

- (NSString *)titleForEnum:(NSInteger)enumIdentifier{
    switch (enumIdentifier) {
        case MeActivityTitleButtonEnum_SignUp:
            return SLLocalizedString(@"已报名");
        case MeActivityTitleButtonEnum_Join:
            return SLLocalizedString(@"已参加");
        default:
            return @"";
    }
}

- (UIView *)headerView{
    if (!_headerView){
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = kMainYellow;
        MeActivityTitleButtonEnum titleButtons[]  = { MeActivityTitleButtonEnum_SignUp, MeActivityTitleButtonEnum_Join };
        NSInteger count = sizeof(titleButtons) / sizeof(titleButtons[0]);
        
        UIView *lastV;
        for (int i = 0; i < count; i++){
            NSInteger enumIdentifier = titleButtons[i];
            NSString *title = [self titleForEnum:enumIdentifier];
            UIButton *btn = [[UIButton alloc] init];
            btn.tag = enumIdentifier;
            btn.titleLabel.font = kRegular(18);
            [btn setBackgroundColor:[UIColor clearColor]];
            [btn setTitle:title forState:UIControlStateNormal];
            [btn setTitle:title forState:UIControlStateSelected];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [btn setTitleColor:[UIColor colorForHex:@"C77A76"] forState:UIControlStateNormal];
            [btn setSelected:btn.tag == (NSInteger)self.currentData];
            [btn addTarget:self action:@selector(headerViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_headerView addSubview:btn];
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                if (lastV){
                    make.left.mas_equalTo(lastV.mas_right);
                } else {
                    make.left.mas_equalTo(0);
                }
                make.top.mas_equalTo(NavBar_Height + 5);
                make.width.mas_equalTo(_headerView.mas_width).multipliedBy(1.0/count);
            }];
            lastV = btn;
        }
    }
    
    return _headerView;
}

- (UICollectionView *)activityCollectionView{
    if (!_activityCollectionView){
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing = 15;
//        layout.itemSize = CGSizeMake(SLChange(345), SLChange(223));
        
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 15, 0);
        layout.estimatedItemSize = CGSizeMake(self.view.width, 290);
        
        _activityCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _activityCollectionView.dataSource = self;
        _activityCollectionView.delegate = self;
        _activityCollectionView.backgroundColor = [UIColor clearColor];
        [_activityCollectionView registerClass:NSClassFromString(MeActivityCollectionViewCellIdentifier) forCellWithReuseIdentifier:MeActivityCollectionViewCellIdentifier];
        
        WEAKSELF
        MJRefreshNormalHeader *headerView = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf update];
        }];
        headerView.stateLabel.textColor = [UIColor whiteColor];
        headerView.lastUpdatedTimeLabel.textColor = [UIColor whiteColor];
        headerView.loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        
        _activityCollectionView.mj_header = headerView;
//        = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            [weakSelf update];
//        }];
        _activityCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            // 上拉加载
            [weakSelf loadMoreData];
        }];
    }
    return _activityCollectionView;
}


- (void)headerViewButtonClick:(UIButton *)button{
    self.currentData = button.tag;
    for (UIButton *btn in self.headerView.subviews){
        [btn setSelected:btn.tag == (NSInteger)self.currentData];
    }
    [self update];
}

- (void)pushQRCodeViewController{
    WEAKSELF
    QRCodeViewController *vc = [[QRCodeViewController alloc] init];
    vc.scanSucceeded = ^(NSArray<NSString *> * _Nonnull QRCodeStringArray, HandleSuccessBlock  _Nonnull handleSuccess) {
        NSString *QRCodeString = URL_H5_MyActivityScanQRCodeError;
        if (QRCodeStringArray.count && [QRCodeStringArray.firstObject containsString:H5Host]){
            QRCodeString = QRCodeStringArray.firstObject;
        }
        if (handleSuccess) handleSuccess();
        [weakSelf pushWebViewViewController:QRCodeString];
    };
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushWebViewViewController:(NSString *)url{
    NSString *token = [SLAppInfoModel sharedInstance].access_token;
    url = [NSString stringWithFormat:@"%@&token=%@",url, token];
    KungfuWebViewController *webVC = [[KungfuWebViewController alloc] initWithUrl:url type:KfWebView_unknown];
    webVC.disableRightGesture = YES;
    webVC.receiveScriptMessageBlock = ^BOOL(NSDictionary * _Nonnull messageDict) {
        NSString *flagStr = messageDict[@"flag"];
        NSString *jsonStr = messageDict[@"json"];
        NSDictionary *jsonDict = [jsonStr mj_JSONObject];
        if ([flagStr isEqualToString:@"CheckInReturn"]){
            [self.navigationController popToViewController:self animated:YES];
            return YES;
        } else if ([flagStr isEqualToString:@"singinState"] && [[jsonDict objectForKey:@"code"] isEqualToString:@"200"]){
            [self update];
        }
        return NO;
    };
    webVC.leftActionBlock = ^BOOL{
        [self.navigationController popToViewController:self animated:YES];
        return YES;
    };
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
}
#pragma mark - delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.meActivityList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MeActivityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MeActivityCollectionViewCellIdentifier forIndexPath:indexPath];
    if (self.currentData == MeActivityTitleButtonEnum_SignUp){
        cell.type = @"signUp";
    } else {
        cell.type = @"";
    }
    MeActivityModel *model = self.meActivityList[indexPath.row];;
    cell.model = model;

    WEAKSELF
    [cell setShowDetailsBlock:^{
        NSString * url = URL_H5_EventRegistration(model.activityCode, [SLAppInfoModel sharedInstance].access_token);
        KungfuWebViewController *webVC = [[KungfuWebViewController alloc] initWithUrl:url type:KfWebView_activityDetail];
        webVC.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:webVC animated:YES];
    }];
    [cell setShowQRCodeBlock:^{
        [weakSelf pushQRCodeViewController];
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - setter && getter
- (void)setNoData {
    WEAKSELF
//    NSString *curTitle = [self titleForEnum:self.currentData];
    NSString *noDataTitle = SLLocalizedString(@"暂无活动");//[NSString stringWithFormat:SLLocalizedString(@"暂无%@活动"), curTitle];
    LYEmptyView *emptyView = [LYEmptyView emptyActionViewWithImageStr:@"categorize_nogoods"
                                                             titleStr:noDataTitle
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
    self.activityCollectionView.ly_emptyView = emptyView;
}

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
//
//}

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//
//}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

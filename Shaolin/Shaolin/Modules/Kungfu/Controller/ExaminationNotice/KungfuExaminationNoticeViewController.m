//
//  KungfuExaminationNoticeViewController.m
//  Shaolin
//
//  Created by 王精明 on 2020/6/2.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuExaminationNoticeViewController.h"
#import "KungfuManager.h"
#import "ExaminationNoticeModel.h"
#import "KungfuExaminationNoticeCollectionViewCell.h"

// TODO: 启动测试数据
//#define KUNGFUEXAMINATIONNOTICE_TEST

static NSString *const KungfuExaminationNoticeViewCellIdentifier = @"KungfuExaminationNoticeViewCell";

@interface KungfuExaminationNoticeViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UICollectionView *noticeCollectionView;
@property (nonatomic, strong) NSMutableArray <ExaminationNoticeModel *> *noticeList;
@property (nonatomic, strong) LYEmptyView *emptyView;
@property (nonatomic) NSInteger total;  //考试通知KungFu_examinationNotice 接口返回了 total、currengPage和pagesize
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) NSInteger pageSize;
@end

@implementation KungfuExaminationNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageSize = 10;
    self.noticeList = [@[] mutableCopy];
    [self setUI];
    // Do any additional setup after loading the view.
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.noticeCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - UI
- (void)setUI{
    self.titleLabe.text = SLLocalizedString(@"考试通知");
    [self.view addSubview:self.noticeCollectionView];
}

- (void)setNoData {
    WEAKSELF
    LYEmptyView *emptyView = [LYEmptyView emptyActionViewWithImageStr:@"categorize_nogoods"
                                                             titleStr:SLLocalizedString(@"暂无考试通知")
                                                            detailStr:@""
                                                          btnTitleStr:nil//SLLocalizedString(@"点击刷新")
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
    emptyView.actionBtnBackGroundColor = UIColor.whiteColor;
    self.noticeCollectionView.ly_emptyView = emptyView;
}

- (void)reloadCollectionView{
    [self.noticeCollectionView reloadData];
}

#pragma mark - requestData
- (void)requestData:(void (^)(NSArray *array))finish{
    NSDictionary *params = @{
        @"pageNum" : [NSString stringWithFormat:@"%ld", self.currentPage],
        @"pageSize" : [NSString stringWithFormat:@"%ld", self.pageSize],
    };
    MBProgressHUD * hud = [ShaolinProgressHUD defaultLoadingWithText:SLLocalizedString(@"加载中")];
    WEAKSELF
    [[KungfuManager sharedInstance] getExaminationNoticeListWithDic:params callback:^(NSDictionary *result) {
        [hud hideAnimated:YES];
        NSArray *dataList = @[];
        if ([ModelTool checkResponseObject:result]) {
            NSDictionary *dict = [result objectForKey:DATAS];
            NSArray *arr = [dict objectForKey:DATAS];
            dataList = [ExaminationNoticeModel mj_objectArrayWithKeyValuesArray:arr];
            weakSelf.total = [[dict objectForKey:@"total"] integerValue];
            [weakSelf.noticeList addObjectsFromArray:dataList];
        } else {
            weakSelf.total = 0;
        }
        if (weakSelf.noticeList.count == 0){
#ifdef KUNGFUEXAMINATIONNOTICE_TEST
            dataList = [[weakSelf testMeActivityList] mutableCopy];
            weakSelf.noticeList = dataList;
#endif
        }
        if (finish) finish(dataList);
    }];
}

- (void)update{
    self.currentPage = 1;
    [self.noticeList removeAllObjects];
    WEAKSELF
    [self requestData:^(NSArray *array) {
        if (weakSelf.noticeList.count == 0){
            [weakSelf setNoData];
        }
        [weakSelf.noticeCollectionView.mj_header endRefreshing];
        if (array.count == 0 || array.count < weakSelf.pageSize){
            [weakSelf.noticeCollectionView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [weakSelf.noticeCollectionView.mj_footer endRefreshing];
        }
        [weakSelf reloadCollectionView];
    }];
}

- (void)loadMoreData{
    self.currentPage++;
    WEAKSELF
    [self requestData:^(NSArray *array) {
        weakSelf.noticeCollectionView.mj_footer.hidden = weakSelf.noticeList.count == 0;
        if (array.count == 0){
            [weakSelf.noticeCollectionView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [weakSelf.noticeCollectionView.mj_footer endRefreshing];
        }
        [weakSelf reloadCollectionView];
    }];
}
#pragma mark - collectionView Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.noticeList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KungfuExaminationNoticeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KungfuExaminationNoticeViewCellIdentifier forIndexPath:indexPath];
    cell.model = self.noticeList[indexPath.row];
#ifdef KUNGFUEXAMINATIONNOTICE_TEST
    [cell testUI];
#endif
//    BOOL hiddenLine = indexPath.row == self.noticeList.count - 1;
//    cell.lineView.hidden = hiddenLine;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - getter UI
- (UICollectionView *)noticeCollectionView{
    if (!_noticeCollectionView){
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing = 0;
        layout.itemSize = CGSizeMake(CGRectGetWidth(self.view.frame) - SLChange(16)*2, SLChange(385));
        
        _noticeCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _noticeCollectionView.dataSource = self;
        _noticeCollectionView.delegate = self;
        _noticeCollectionView.backgroundColor = [UIColor clearColor];
        [_noticeCollectionView registerClass:[KungfuExaminationNoticeCollectionViewCell class] forCellWithReuseIdentifier:KungfuExaminationNoticeViewCellIdentifier];
        WEAKSELF
        _noticeCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf update];
        }];

        _noticeCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            //上拉加载
            [weakSelf loadMoreData];
        }];
        [self.noticeCollectionView.mj_header beginRefreshing];
    }
    return _noticeCollectionView;
}

#pragma mark - testData
- (NSArray *)testMeActivityList{
    NSInteger count = arc4random()%15;
    NSMutableArray *mArray = [@[] mutableCopy];
    for (int i = 0; i < count; i++){
        [mArray addObject:[ExaminationNoticeModel new]];
    }
    return mArray;
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

//
//  MeCourseVc.m
//  Shaolin
//
//  Created by edz on 2020/4/28.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "MeCourseVc.h"
#import "PostManagementBottomView.h"
#import "MeCourseTableViewCell.h"
#import "MeCouresModel.h"
#import "MeManager.h"
#import "LYEmptyView.h"
#import "UIScrollView+EmptyDataSet.h"
#import "KungfuClassDetailViewController.h"
#import "KungfuManager.h"

// TODO: 启用测试数据宏
//#define MECOURSE_TEST

@interface MeCourseVc () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>
@property (nonatomic) NSInteger page;
@property (nonatomic) NSInteger total;
@property (nonatomic) BOOL isInsertEdit;//tableview编辑方式的判断
@property (nonatomic, strong) PostManagementBottomView *bottomView;//底部视图
@property (nonatomic, strong) NSMutableArray *deleteArray;//删除的数据
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *courseArray;
@property (nonatomic, strong) LYEmptyView *emptyView;
@end

@implementation MeCourseVc

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavigationBarRedTintColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.total = 1;
    self.deleteArray = [@[] mutableCopy];
    self.courseArray = [@[] mutableCopy];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tableView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-kBottomSafeHeight);;
        make.height.mas_equalTo(0);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.bottomView.mas_top);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectEditCell) name:@"collectionEditCourseSelect" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(normalEditCell) name:@"collectionEditCourseNormal" object:nil];
    // Do any additional setup after loading the view.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)selectEditCell {
    //点击编辑的时候清空删除数组
    [self.deleteArray removeAllObjects];
    self.isInsertEdit = YES;//这个时候是全选模式
    [self.tableView setEditing:YES animated:YES];
//    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    //如果在全选状态下，点击完成，再次进来的时候需要改变按钮的文字和点击状态
    if (self.bottomView.allBtn.selected) {
        self.bottomView.allBtn.selected = !_bottomView.allBtn.selected;
        [self.bottomView.allBtn setTitle:SLLocalizedString(@"全选") forState:UIControlStateNormal];
    }
    
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(SLChange(40)+BottomMargin_X);
    }];
}

- (void)normalEditCell {
    self.isInsertEdit = NO;
    [self.tableView setEditing:NO animated:YES];
//    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
    }];
}

#pragma mark - 全选事件
- (void)tapAllBtn:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        for (int i = 0; i< self.courseArray.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            //全选实现方法
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        //点击全选的时候需要清除deleteArray里面的数据，防止deleteArray里面的数据和列表数据不一致
        if (self.deleteArray.count >0) {
            [self.deleteArray removeAllObjects];
        }
        [self.deleteArray addObjectsFromArray:self.courseArray];
        [btn setTitle:SLLocalizedString(@" 取消") forState:UIControlStateNormal];
    }else{
        //取消选中
        for (int i = 0; i< self.courseArray.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            [_tableView deselectRowAtIndexPath:indexPath animated:NO];
        }
        [btn setTitle:SLLocalizedString(@" 全选") forState:UIControlStateNormal];
        [self.deleteArray removeAllObjects];
    }
}
/**
 * 删除数据方法
 */
- (void)deleteData{
    if (self.deleteArray.count > 0) {
        WEAKSELF
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:SLLocalizedString(@"提示")
                                                                       message:SLLocalizedString(@"是否进行删除")
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:SLLocalizedString(@"确认删除")
                                                                style:UIAlertActionStyleDestructive
                                                              handler:^(UIAlertAction * action) {
            [ShaolinProgressHUD defaultSingleLoadingWithText:SLLocalizedString(@"删除中...")];
            [weakSelf cancelCollect:weakSelf.deleteArray];
        }];
        
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:SLLocalizedString(@"取消")
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
        
        [alert addAction:defaultAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"没有选择教程") view:self.view afterDelay:TipSeconds];
    }
}

- (void)reloadCollectionView{
    [self.tableView reloadData];
}


- (void)priseCourse:(MeCouresModel *)model {
    
}


#pragma mark - test
- (void)testData{
    self.courseArray = [[NSMutableArray alloc] initWithObjects:[MeCouresModel new], [MeCouresModel new], [MeCouresModel new], nil];
}

#pragma mark - requestData
- (void)requestData:(void (^)(NSArray *meClassListArray))finish{
//    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    NSDictionary *params = @{
        @"page" : [NSString stringWithFormat:@"%ld", self.page],
        @"type" : @"2",
    };
    WEAKSELF
    [[MeManager sharedInstance] postMyCollectCourse:params finish:^(id  _Nonnull responseObject, NSString * _Nonnull errorReason) {
        if ([ModelTool checkResponseObject:responseObject]){
#ifdef MECOURSE_TEST
            [weakSelf testData];
            if (finish) finish(weakSelf.courseArray);
#else
            NSDictionary *data = responseObject[DATAS];
            NSArray *arr = [data objectForKey:LIST];
            NSArray *dataList = [MeCouresModel mj_objectArrayWithKeyValuesArray:arr];
            [weakSelf.courseArray addObjectsFromArray:dataList];
            if (finish) finish(dataList);
#endif
        } else {
            [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
            if (finish) finish(nil);
        }
        [weakSelf reloadCollectionView];
//        [hud hideAnimated:YES];
    }];
}

- (void)update{
    self.page = 1;
    [self.courseArray removeAllObjects];
    WEAKSELF
    [self requestData:^(NSArray *meClassListArray) {
        if (weakSelf.courseArray.count == 0){
            [weakSelf setNoData];
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
//        weakSelf.tableView.mj_footer.hidden = (meClassListArray && meClassListArray.count) == 0;
    }];
}

- (void)loadMoreData{
    self.page++;
    WEAKSELF
    [self requestData:^(NSArray *meClassListArray) {
        if (meClassListArray.count == 0){
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [weakSelf.tableView.mj_footer endRefreshing];
        }
    }];
}

- (void)cancelCollect:(NSArray *)couresArray{
    __block NSMutableArray *deleteSucceedArray = [@[] mutableCopy];
    dispatch_group_t group = dispatch_group_create();
    for (int i = 0; i < couresArray.count; i++ ){
        MeCouresModel *model = couresArray[i];
        dispatch_group_enter(group);//手动在group中加入一个任务
        //取消收藏
        NSDictionary * dic = @{
            @"goods_id" : model.couresId,
            @"type" : @"2"
        };
        [[KungfuManager sharedInstance] getClassCollectWithDic:dic callback:^(Message *message) {
            if (message.isSuccess) {
                [deleteSucceedArray addObject:model];
            }
            dispatch_group_leave(group);//手动在group移除一个任务
        }];
    }
    WEAKSELF
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"删除成功") view:self.view afterDelay:TipSeconds];
        [weakSelf.courseArray removeObjectsInArray:deleteSucceedArray];
        [weakSelf.deleteArray removeObject:deleteSucceedArray];
        [weakSelf normalEditCell];
        weakSelf.isInsertEdit = NO;
        [weakSelf.tableView setEditing:NO animated:YES];
        [weakSelf reloadCollectionView];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NormalCollectionButton" object:nil];
        [weakSelf update];
    });
}
#pragma mark - tableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.courseArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifierStr = [NSString stringWithFormat:@"identifier_%ld_%ld",(long)indexPath.section,(long)indexPath.row];
    MeCourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
    if (cell == nil) {
        cell = [[MeCourseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierStr];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MeCouresModel *model = self.courseArray[indexPath.row];
    cell.model = model;
#ifdef MECOURSE_TEST
    [cell testUI];
#endif
    WEAKSELF
    [cell setPriseButtonAction:^{
        [weakSelf cancelCollect:@[model]];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, SLChange(10))];
//    view.backgroundColor = [UIColor colorForHex:@"FFFFFF"];
//    return view;
//}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SLLocalizedString(@"删除");
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    //根据不同状态返回不同编辑模式
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
}

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {
    //左滑删除数据方法
    if (editingStyle == UITableViewCellEditingStyleDelete) {
         [self.deleteArray addObject:[self.courseArray objectAtIndex:indexPath.row]];
         [self deleteData];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.editing) {
        [self.deleteArray addObject:[self.courseArray objectAtIndex:indexPath.row]];
    }else {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        MeCouresModel *model = self.courseArray[indexPath.row];
        KungfuClassDetailViewController * vc = [KungfuClassDetailViewController new];
        vc.classId = model.couresId;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath  {
    if (tableView.editing) {
        NSLog(@"取消选中");
        [self.deleteArray removeObject:[self.courseArray objectAtIndex:indexPath.row]];
    }else{
        NSLog(@"取消跳转");
    }
}
#pragma mark - DZNEmptyDataSetDelegate && dataSource
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    
    return !self.courseArray.count;
}

-(CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -70;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = SLLocalizedString(@"暂无收藏");
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15.0f],
                                 NSForegroundColorAttributeName: [UIColor hexColor:@"333333"]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

-(NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = SLLocalizedString(@"快去收藏喜欢的教程吧");
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:13.0f],
                                 NSForegroundColorAttributeName: [UIColor hexColor:@"bfbfbf"]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"categorize_nogoods"];
}

#pragma mark - getter、setter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
         [_tableView registerClass:[MeCourseTableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//        _tableView.rowHeight = 227;
        _tableView.separatorColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        WEAKSELF
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf update];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            //上拉加载
            [weakSelf loadMoreData];
        }];
        
        [_tableView.mj_header beginRefreshing];
    }
    return _tableView;
}

- (PostManagementBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[PostManagementBottomView alloc] initWithFrame:CGRectZero];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.clipsToBounds = YES;
        [_bottomView.deleteBtn addTarget:self action:@selector(deleteData) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.allBtn addTarget:self action:@selector(tapAllBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomView;
}

- (LYEmptyView * )emptyView{
    if (!_emptyView){
        WEAKSELF
        NSString *titleStr = [NSString stringWithFormat:SLLocalizedString(@"暂无教程")];
        _emptyView = [LYEmptyView emptyActionViewWithImageStr:@"categorize_nogoods"
                                                                 titleStr:titleStr
                                                                detailStr:@""
                                                              btnTitleStr:nil//SLLocalizedString(@"点击加载")
                                                            btnClickBlock:^(){
            [weakSelf update];
        }];
        _emptyView.subViewMargin = 12.f;
        
        _emptyView.titleLabTextColor = RGBA(125, 125, 125,1);
        
        _emptyView.detailLabTextColor =  RGBA(192, 192, 192,1);
        
        _emptyView.actionBtnFont = [UIFont systemFontOfSize:15.f];
        _emptyView.actionBtnTitleColor =  RGBA(90, 90, 90,1);
        _emptyView.actionBtnHeight = 30.f;
        _emptyView.actionBtnHorizontalMargin = 22.f;
        _emptyView.actionBtnCornerRadius = 2.f;
        _emptyView.actionBtnBorderColor =  RGBA(150, 150, 150,1);
        _emptyView.actionBtnBorderWidth = 0.5;
        _emptyView.actionBtnBackGroundColor = [UIColor colorForHex:@"FFFFFF"];
    }
    return _emptyView;
}

- (void)setNoData {
//    self.tableView.ly_emptyView = self.emptyView;
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

//
//  ReadingVideoVc.m
//  Shaolin
//
//  Created by edz on 2020/4/27.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ReadingVideoVc.h"
#import "ReadingVideoCell.h"
#import "MeManager.h"
#import "FoundModel.h"
#import "FoundVideoListVc.h"
#import "HomeManager.h"
#import "PostManagementBottomView.h"
#import "ReadingNoDataViewController.h"
@interface ReadingVideoVc ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) NSMutableArray *foundArray;
@property (nonatomic) NSInteger total;
@property (nonatomic) NSInteger pager;
@property (nonatomic) NSInteger pageSize;
@property (nonatomic) BOOL isInsertEdit;//tableview编辑方式的判断
@property (nonatomic ,strong) NSMutableArray *deleteArray;//删除的数据
@property (nonatomic ,strong) PostManagementBottomView *bottomView;//底部视图

@end

@implementation ReadingVideoVc
static  NSString* firseCellid = @"firseCell";
- (void)viewWillDisappear:(BOOL)animated {
    //    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _isInsertEdit = NO;
    self.pageSize = 20;
    self.pager = 1;
    self.total = 0;
    self.foundArray = [@[] mutableCopy];
    self.deleteArray = [@[] mutableCopy];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectEditCell) name:@"selectEditVideoSelect" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(normalEditCell) name:@"selectEditVideoNormal" object:nil];
}
- (void)selectEditCell {
    
    //点击编辑的时候清空删除数组
    [self.deleteArray removeAllObjects];
    
    _isInsertEdit = YES;//这个时候是全选模式
    [_tableView setEditing:YES animated:YES];
    
    //如果在全选状态下，点击完成，再次进来的时候需要改变按钮的文字和点击状态
    if (_bottomView.allBtn.selected) {
        _bottomView.allBtn.selected = !_bottomView.allBtn.selected;
        [_bottomView.allBtn setTitle:SLLocalizedString(@"全选") forState:UIControlStateNormal];
    }
    _tableView.frame = CGRectMake(0, 0, kWidth, kHeight-NavBar_Height-48-SLChange(40)-BottomMargin_X);
    //添加底部视图
    
    self.bottomView.hidden = NO;
    [self.view addSubview:self.bottomView];
}
- (void)normalEditCell {
    
    _isInsertEdit = NO;
    [_tableView setEditing:NO animated:YES];
    _tableView.frame = CGRectMake(0, 0, kWidth, kHeight-NavBar_Height-48);
    
    [self.bottomView removeFromSuperview];
    _bottomView.hidden = YES;
}
#pragma mark - 全选事件
- (void)tapAllBtn:(UIButton *)btn{
    
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        
        for (int i = 0; i< self.foundArray.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            //全选实现方法
            [_tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        
        //点击全选的时候需要清除deleteArray里面的数据，防止deleteArray里面的数据和列表数据不一致
        if (self.deleteArray.count >0) {
            [self.deleteArray removeAllObjects];
        }
        [self.deleteArray addObjectsFromArray:self.foundArray];
        
        [btn setTitle:SLLocalizedString(@" 取消") forState:UIControlStateNormal];
    }else{
        
        //取消选中
        for (int i = 0; i< self.foundArray.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            [_tableView deselectRowAtIndexPath:indexPath animated:NO];
            
        }
        
        [btn setTitle:SLLocalizedString(@" 全选") forState:UIControlStateNormal];
        [self.deleteArray removeAllObjects];
    }
}

- (void)requestData:(void (^)(NSArray *array))finish {
//    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    NSDictionary *params = @{
        @"pageNum" : [NSString stringWithFormat:@"%ld", self.pager],
        @"pageSize" : [NSString stringWithFormat:@"%ld", self.pageSize],
        @"kind" : @"2",
    };
    [[MeManager sharedInstance] getHistory:params success:^(id  _Nonnull responseObject) {
        NSDictionary *data = responseObject;
        self.total = [[data objectForKey:@"total"] integerValue];
        NSArray *arr = [solveJsonData changeType:[data objectForKey:@"data"]];
        if (arr.count >0) {
            [self.foundArray addObjectsFromArray:[FoundModel mj_objectArrayWithKeyValuesArray:arr]];
        }
        [self.tableView reloadData];
        if (finish) finish(arr);
    } failure:^(NSString * _Nonnull errorReason) {
        [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
        if (finish) finish(nil);
    } finish:^(id  _Nonnull responseObject, NSString * _Nonnull errorReason) {
//        [hud hideAnimated:YES];
    }];
}

- (void)update {
    self.pager = 1;
    [self.foundArray removeAllObjects];
    WEAKSELF
    [self requestData:^(NSArray *array) {
        [weakSelf.tableView.mj_header endRefreshing];
        if (array.count == 0 || array.count < weakSelf.pageSize){
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [weakSelf.tableView.mj_footer endRefreshing];
        }
    }];
}

- (void)loadNowMoreAction {
    self.pager++;
    WEAKSELF
    [self requestData:^(NSArray *array) {
        [weakSelf.tableView.mj_footer endRefreshing];
        if (array.count == 0 || array.count < weakSelf.pageSize){
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

#pragma mark - DZNEmptyDataSetDelegate && dataSource
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    
    return !self.foundArray.count;
}

-(CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -70;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = SLLocalizedString(@"暂无历史");
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15.0f],
                                 NSForegroundColorAttributeName: [UIColor hexColor:@"999999"]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

//-(NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
//    NSString *text = SLLocalizedString(@"快去观看视频吧");
//
//    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:13.0f],
//                                 NSForegroundColorAttributeName: [UIColor hexColor:@"bfbfbf"]};
//
//    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
//}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"categorize_nogoods"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _foundArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSString *identifierStr = [NSString stringWithFormat:@"identifier_%ld_%ld",(long)indexPath.section,(long)indexPath.row];
    ReadingVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
    if (cell == nil) {
        cell = [[ReadingVideoCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifierStr];
    }
    FoundModel *model = self.foundArray[indexPath.row];;
    cell.model = model;
    //       cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    WEAKSELF
    [cell setPriseBtnClickBlock:^(BOOL isSelected) {
        [weakSelf priseAction:indexPath isSelected:isSelected ];
    }];
    
    return cell;
    
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SLLocalizedString(@"删除");
}


-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //根据不同状态返回不同编辑模式
    
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
    
}

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {
    
    //左滑删除数据方法
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.deleteArray addObject:[self.foundArray objectAtIndex:indexPath.row]];
        [self deleteData];
    }
}
// 收藏
- (void)priseAction:(NSIndexPath *)indexPath isSelected:(BOOL)isSelected {
    if (isSelected) { //收藏成功调用的
        [self foucsAction:indexPath];
    } else { //取消收藏
        [self cancleCollectionAction:indexPath];
    }
}
#pragma mark - 收藏成功
- (void)foucsAction:(NSIndexPath *)indexPath {
    FoundModel *model = [self.foundArray objectAtIndex:indexPath.row];
    if (!model) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"收藏失败") view:self.view afterDelay:TipSeconds];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
    NSString *contentId = [NSString stringWithFormat:@"%@",model.id];
    NSLog(@"%@ --- %@",contentId,model.type);
//    [[HomeManager sharedInstance]postCollectionContentId:contentId Type:model.type Kind:@"2" MemberId:@"" MemberName:@"" Success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        NSLog(@"%@",responseObject);
//        if ([[responseObject objectForKey:@"code"] integerValue] == 200) {
//            NSInteger likeCount = [model.collections integerValue];
//            likeCount += 1;
//            model.collection = @"2";
//            model.collections = [NSString stringWithFormat:@"%ld",likeCount];
//            self.foundArray[indexPath.row] = model;
//            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
//            
//            [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"收藏成功") view:self.view afterDelay:TipSeconds];
//        } else {
//            [ShaolinProgressHUD singleTextHud:[responseObject objectForKey:@"message"] view:self.view afterDelay:TipSeconds];
//        }
//    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//        [ShaolinProgressHUD singleTextHud:kNetErrorPrompt view:self.view afterDelay:TipSeconds];
//    }];
    
    [[HomeManager sharedInstance]postCollectionContentId:contentId Type:model.type Kind:@"2" MemberId:@"" MemberName:@"" Success:^(NSDictionary * _Nullable resultDic) {
        
    } failure:^(NSString * _Nullable errorReason) {
        
    } finish:^(NSDictionary * _Nullable responseObject, NSString * _Nullable errorReason) {
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"code"] integerValue] == 200) {
            NSInteger likeCount = [model.collections integerValue];
            likeCount += 1;
            model.collection = @"2";
            model.collections = [NSString stringWithFormat:@"%ld",likeCount];
            self.foundArray[indexPath.row] = model;
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            
            [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"收藏成功") view:self.view afterDelay:TipSeconds];
        } else {
            [ShaolinProgressHUD singleTextHud:[responseObject objectForKey:@"message"] view:self.view afterDelay:TipSeconds];
        }
    }];
}
#pragma mark - 取消收藏
- (void)cancleCollectionAction:(NSIndexPath *)indexPath {
    FoundModel *model = [self.foundArray objectAtIndex:indexPath.row];
    if (!model) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"取消失败") view:self.view afterDelay:TipSeconds];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
    NSString *strId = [NSString stringWithFormat:@"%@", model.id];
    NSMutableArray *arr = [NSMutableArray array];
    NSDictionary *dic = @{@"contentId":strId,@"type":model.type};
    [arr addObject:dic];
    NSLog(@"%@",arr);
    [[HomeManager sharedInstance]postCollectionCancleArray:arr WithBlock:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"code"] integerValue]== 200) {
            
            NSInteger likeCount = [model.collections integerValue];
            likeCount --;
            model.collection = @"1";
            model.collections = [NSString stringWithFormat:@"%ld",likeCount];
            self.foundArray[indexPath.row] = model;
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"取消收藏") view:self.view afterDelay:TipSeconds];
        } else {
            [ShaolinProgressHUD singleTextHud:[responseObject objectForKey:@"message"] view:self.view afterDelay:TipSeconds];
        }
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return SLChange(172);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SLChange(10);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, SLChange(10))];
    view.backgroundColor = [UIColor colorForHex:@"FFFFFF"];
    return view;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.editing) {
        NSLog(@"选中");
        
        [self.deleteArray addObject:[self.foundArray objectAtIndex:indexPath.row]];
        
    }else {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        FoundModel *model = self.foundArray[indexPath.row];
        NSString *tabbarSt ;
        if ([model.type isEqualToString:@"1"]) {
            tabbarSt = @"Found";
        }else {
            tabbarSt = @"Activity";
        }
        if ([model.type isEqualToString:@"1"]) {
            if ([model.state isEqualToString:@"6"]) {
                FoundVideoListVc *vC = [[FoundVideoListVc alloc]init];
                vC.hidesBottomBarWhenPushed = YES;
                vC.fieldId = model.fieldId;
                vC.videoId = model.id;
                vC.tabbarStr = tabbarSt;
                vC.typeStr = model.type;
                vC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vC animated:YES];
            }else {
                ReadingNoDataViewController *reVC = [[ReadingNoDataViewController alloc]init];
                reVC.hidesBottomBarWhenPushed = YES;
                reVC.typeStr = @"video";
                [self.navigationController pushViewController:reVC animated:YES];
            }
        }else {
            if ([model.state isEqualToString:@"2"]) {
                FoundVideoListVc *vC = [[FoundVideoListVc alloc]init];
                vC.hidesBottomBarWhenPushed = YES;
                vC.fieldId = model.fieldId;
                vC.videoId = model.id;
                vC.tabbarStr = tabbarSt;
                vC.typeStr = model.type;
                vC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vC animated:YES];
            }else {
                ReadingNoDataViewController *reVC = [[ReadingNoDataViewController alloc]init];
                reVC.hidesBottomBarWhenPushed = YES;
                reVC.typeStr = @"video";
                [self.navigationController pushViewController:reVC animated:YES];
            }
        }
        
        
        
        
        
        
        
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    if (tableView.editing) {
        NSLog(@"取消选中");
        
        [self.deleteArray removeObject:[self.foundArray objectAtIndex:indexPath.row]];
    }else{
        NSLog(@"取消跳转");
    }
}
/**
 删除数据方法
 */
- (void)deleteData{
    if (self.deleteArray.count >0) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:SLLocalizedString(@"提示")
                                                                       message:SLLocalizedString(@"是否进行删除")
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:SLLocalizedString(@"确认删除") style:UIAlertActionStyleDestructive
                                                              handler:^(UIAlertAction * action) {
            [ShaolinProgressHUD defaultSingleLoadingWithText:SLLocalizedString(@"删除中...")];
            NSMutableArray *deleteArr = [NSMutableArray array];
            for (FoundModel *model in self.deleteArray) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setValue:model.id forKey:@"contentId"];
                [dic setValue:model.type forKey:@"type"];
                [deleteArr addObject:dic];
            }
            [[MeManager sharedInstance] postDeleteHistory:deleteArr finish:^(id  _Nonnull responseObject, NSString * _Nonnull errorReason) {
                NSLog(@"%@",responseObject);
                if ([ModelTool checkResponseObject:responseObject]){
                    [self hiddenBoomtoView];
                    [self.foundArray removeObjectsInArray:self.deleteArray];
                    [self.tableView reloadData];
                    if (self.foundArray.count == 0) {
//                        self.tableView.ly_emptyView = self.emptyView;
                    }
                    [ShaolinProgressHUD singleTextAutoHideHud:SLLocalizedString(@"删除成功")];
                } else {
                    [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
                }
            }];
            NSLog(@"----%@",deleteArr);
        }];
        
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:SLLocalizedString(@"取消") style:UIAlertActionStyleDefault
                                                             handler:nil];
        
        [alert addAction:defaultAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        
        
        
    }else
    {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"没有选择文章") view:self.view afterDelay:TipSeconds];
    }
    
}
-(void)hiddenBoomtoView
{
    //     [self.rightBtn setSelected:NO];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"NormalButton" object:nil];
    _isInsertEdit = NO;
    [_tableView setEditing:NO animated:YES];
    _tableView.frame = CGRectMake(0, 0, kWidth, kHeight-NavBar_Height-48);
    [self.bottomView removeFromSuperview];
    _bottomView.hidden = YES;
}
#pragma mark - Getters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[ReadingVideoCell class] forCellReuseIdentifier:@"cell"];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        //        _tableView.rowHeight = 227;
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self update];
        }];
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self loadNowMoreAction];
        }];
        
        _tableView.emptyDataSetDelegate = self;
        _tableView.emptyDataSetSource = self;
        
    }
    return _tableView;
}
-(NSMutableArray *)deleteArray
{
    if (!_deleteArray) {
        _deleteArray = [NSMutableArray array];
    }
    return _deleteArray;
}
- (NSMutableArray *)foundArray {
    if (!_foundArray) {
        _foundArray = [NSMutableArray array];
    }
    return _foundArray;
}
-(PostManagementBottomView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[PostManagementBottomView alloc]initWithFrame:CGRectMake(0, kHeight-SLChange(40)-BottomMargin_X-NavBar_Height-48, kWidth, SLChange(40)+BottomMargin_X)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        [_bottomView.deleteBtn addTarget:self action:@selector(deleteData) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.allBtn addTarget:self action:@selector(tapAllBtn:) forControlEvents:UIControlEventTouchUpInside];
        _bottomView.hidden = YES;
    }
    return _bottomView;
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

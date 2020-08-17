//
//  PostManagementVc.m
//  Shaolin
//
//  Created by edz on 2020/3/23.ˆˆˆˆˆˆˆˆ
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "PostManagementVc.h"
#import "FoundDetailsViewController.h"
#import "PostManagementBottomView.h"

#import "PostPureTextCell.h"
#import "PostManagementCell.h"
#import "MePostManagerModel.h"
#import "PostALLCell.h"
#import "MeManager.h"
#import "WMPhotoBrowser.h"
#import "EditTextViewController.h"
#import "DraftEditVideoViewController.h"
#import "LookVideoViewController.h"
@interface PostManagementVc ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *dataArray;//数据源
@property (nonatomic ,strong) NSMutableArray *deleteArray;//删除的数据
@property (nonatomic, copy) NSString *totalStr;
@property (nonatomic, assign) NSInteger pager;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic ,assign) BOOL isInsertEdit;//tableview编辑方式的判断
@property (nonatomic ,strong) PostManagementBottomView *bottomView;//底部视图
//@property(nonatomic,strong)LYEmptyView *emptyView;
@end

@implementation PostManagementVc
-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(NSMutableArray *)deleteArray
{
    if (!_deleteArray) {
        _deleteArray = [NSMutableArray array];
    }
    return _deleteArray;
}
-(PostManagementBottomView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[PostManagementBottomView alloc]initWithFrame:CGRectMake(0, kHeight-NavBar_Height, kWidth, SLChange(40)+BottomMargin_X)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        [_bottomView.deleteBtn addTarget:self action:@selector(deleteData) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.allBtn addTarget:self action:@selector(tapAllBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomView;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //跳转下一页后，FoundDetailsViewController、LookVideoViewController会隐藏navigationBar
    self.navigationController.navigationBar.hidden = NO;
    //    self.navigationController.navigationBar.barTintColor = RGBA(132, 50, 42, 1);
    //    self.navigationController.navigationBar.hidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self wr_setNavBarBarTintColor:[UIColor hexColor:@"8E2B25"]];
    [self wr_setNavBarTintColor:[UIColor whiteColor]];
    [self wr_setNavBarBackgroundAlpha:1];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //     self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _isInsertEdit = NO;
    self.total = 1;
    [self setUI];
    
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getTableviewData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 上拉加载
        [self loadNowMoreAction];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self registerCell];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getRefreshPageData:) name:@"RefreshData" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(lookOneImage:) name:@"SelectLookOneImage" object:nil];
    //     [self setNoData];
}
-(void)getRefreshPageData:(NSNotification *)user {
    [self getTableviewData];
}
-(void)lookOneImage:(NSNotification *)user
{
    NSDictionary *dic = user.userInfo;
    NSArray *arr = [dic objectForKey:@"selectImage"];
    NSMutableArray *imageArr = [NSMutableArray arrayWithArray:arr];
    WMPhotoBrowser *browser = [WMPhotoBrowser new];
    browser.dataSource = imageArr;
    browser.deleteNeeded = NO;
    browser.currentPhotoIndex= 2;
    [self.navigationController pushViewController:browser animated:YES];
}
-(void)setUI{
    self.titleLabe.text = SLLocalizedString(@"发文管理");
    self.titleLabe.textColor = [UIColor whiteColor];
    [self.leftBtn setImage:[UIImage imageNamed:@"real_left"] forState:(UIControlStateNormal)];
    
    [self.rightBtn setTitle:SLLocalizedString(@"编辑") forState:(UIControlStateNormal)];
    [self.rightBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.rightBtn setTitle:SLLocalizedString(@"完成") forState:(UIControlStateSelected)];
    [self.rightBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.rightBtn addTarget:self action:@selector(rightAction:) forControlEvents:(UIControlEventTouchUpInside)];
    self.rightBtn.titleLabel.font =kRegular(15);
}
-(void)registerCell
{
    
    [_tableView registerClass:[PostPureTextCell class] forCellReuseIdentifier:NSStringFromClass([PostPureTextCell class])];
    
    [_tableView registerClass:[PostManagementCell class] forCellReuseIdentifier:NSStringFromClass([PostManagementCell class])];
    
    
}
/**
 删除数据方法
 */
- (void)deleteData{
    NSLog(@"%@",self.deleteArray);
    
    if (self.deleteArray.count >0) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:SLLocalizedString(@"提示")
                                                                       message:SLLocalizedString(@"是否进行删除")
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:SLLocalizedString(@"确认删除") style:UIAlertActionStyleDestructive
                                                              handler:^(UIAlertAction * action) {
            [ShaolinProgressHUD defaultSingleLoadingWithText:SLLocalizedString(@"删除中...")];
            NSMutableArray *deleteArr = [NSMutableArray array];
            for (MePostManagerModel *model in self.deleteArray) {
                [deleteArr addObject:model.id];
            }
            [[MeManager sharedInstance] postDeleteText:deleteArr finish:^(id  _Nonnull responseObject, NSString * _Nonnull errorReason) {
                if ([ModelTool checkResponseObject:responseObject]){
                    [self hiddenBoomtoView];
                    [self.dataArray removeObjectsInArray:self.deleteArray];
                    if (self.dataArray.count == 0){
                        self.tableView.mj_footer.hidden = YES;
                    }
                    [self.tableView reloadData];
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
    
    //    if (self.deleteArray.count >0) {
    //        [self.dataArray removeObjectsInArray:self.deleteArray];
    //        [self.tableView reloadData];
    //    }
}
-(void)hiddenBoomtoView
{
    [self.rightBtn setSelected:NO];
    _isInsertEdit = NO;
    [_tableView setEditing:NO animated:YES];
    _tableView.frame = CGRectMake(0, 0, kWidth, kHeight-NavBar_Height);
    [UIView animateWithDuration:0.5 animations:^{
        CGPoint point = self.bottomView.center;
        point.y      += SLChange(40)+BottomMargin_X;
        self.bottomView.center  = point;
        
    } completion:^(BOOL finished) {
        [self.bottomView removeFromSuperview];
    }];
}
- (void)getTableviewData{
//    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:SLLocalizedString(@"数据加载中...")];
    self.pager = 1;
    [[MeManager sharedInstance] getWebNewsinformationListState:@"1" PageNum:@"1" PageSize:@"30" success:^(id  _Nonnull responseObject) {
        NSDictionary *dict = responseObject;
        if (dict && [dict isKindOfClass:[NSDictionary class]]){
            self.total = [[solveJsonData changeType:[dict objectForKey:@"total"]] integerValue];
            NSArray *arr = [solveJsonData changeType:[dict objectForKey:@"data"]];
            if (arr.count >0) {
                self.dataArray = [MePostManagerModel mj_objectArrayWithKeyValuesArray:arr];
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
                if (self.total <= self.pager){
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [self.tableView.mj_footer endRefreshing];
                }
                self.tableView.mj_footer.hidden = NO;
            }else
            {
                [self.dataArray removeAllObjects];
                [self.tableView.mj_header endRefreshing];
                self.tableView.mj_footer.hidden = YES;
                [self.tableView reloadData];
            }
        }
    } failure:^(NSString * _Nonnull errorReason) {
        self.tableView.mj_footer.hidden = YES;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
        
    } finish:^(id  _Nonnull responseObject, NSString * _Nonnull errorReason) {
//        [hud hideAnimated:YES];
    }];
}
-(void)loadNowMoreAction
{
    self.pager ++;
//    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    [[MeManager sharedInstance] getWebNewsinformationListState:@"1" PageNum:[NSString stringWithFormat:@"%tu",self.pager] PageSize:@"30" success:^(id  _Nonnull responseObject) {
        NSDictionary *data = responseObject;
        NSArray *arr = [solveJsonData changeType:[data objectForKey:@"data"]];
        if (arr.count > 0) {
            NSArray *list = [MePostManagerModel mj_objectArrayWithKeyValuesArray:arr];
            [self.dataArray addObjectsFromArray:list];
            [self.tableView.mj_footer endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.tableView reloadData];
    } failure:^(NSString * _Nonnull errorReason) {
        [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
    } finish:^(id  _Nonnull responseObject, NSString * _Nonnull errorReason) {
//        [hud hideAnimated:YES];
    }];
}

#pragma mark - DZNEmptyDataSetDelegate && dataSource
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {

    return !self.dataArray.count;
}

-(CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -70;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = SLLocalizedString(@"暂无发文");
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15.0f],
                                 NSForegroundColorAttributeName: [UIColor hexColor:@"999999"]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

//-(NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
//    NSString *text = SLLocalizedString(@"快去写文章吧");
//
//    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:13.0f],
//                                 NSForegroundColorAttributeName: [UIColor hexColor:@"bfbfbf"]};
//
//    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
//}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"categorize_nogoods"];
}

#pragma mark - 右侧编辑
-(void)rightAction:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected) {
        //点击编辑的时候清空删除数组
        [self.deleteArray removeAllObjects];
        
        _isInsertEdit = YES;//这个时候是全选模式
        [_tableView setEditing:YES animated:YES];
        
        //如果在全选状态下，点击完成，再次进来的时候需要改变按钮的文字和点击状态
        if (_bottomView.allBtn.selected) {
            _bottomView.allBtn.selected = !_bottomView.allBtn.selected;
            [_bottomView.allBtn setTitle:SLLocalizedString(@"全选") forState:UIControlStateNormal];
        }
        _tableView.frame = CGRectMake(0, 0, kWidth, kHeight-NavBar_Height-SLChange(40)-BottomMargin_X);
        //添加底部视图
        CGRect frame = self.bottomView.frame;
        frame.origin.y -= (SLChange(40)+BottomMargin_X);
        [UIView animateWithDuration:0.5 animations:^{
            self.bottomView.frame = frame;
            [self.view addSubview:self.bottomView];
        }];
    }else
    {
        _isInsertEdit = NO;
        [_tableView setEditing:NO animated:YES];
        _tableView.frame = CGRectMake(0, 0, kWidth, kHeight-NavBar_Height);
        [UIView animateWithDuration:0.5 animations:^{
            CGPoint point = self.bottomView.center;
            point.y      += SLChange(40)+BottomMargin_X;
            self.bottomView.center  = point;
            
        } completion:^(BOOL finished) {
            [self.bottomView removeFromSuperview];
        }];
    }
}
#pragma mark - 全选事件
- (void)tapAllBtn:(UIButton *)btn{
    
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        
        for (int i = 0; i< self.dataArray.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            //全选实现方法
            [_tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
        }
        
        //点击全选的时候需要清除deleteArray里面的数据，防止deleteArray里面的数据和列表数据不一致
        if (self.deleteArray.count >0) {
            [self.deleteArray removeAllObjects];
        }
        [self.deleteArray addObjectsFromArray:self.dataArray];
        
        [btn setTitle:SLLocalizedString(@" 取消") forState:UIControlStateNormal];
    }else{
        
        //取消选中
        for (int i = 0; i< self.dataArray.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            [_tableView deselectRowAtIndexPath:indexPath animated:NO];
            
        }
        
        [btn setTitle:SLLocalizedString(@" 全选") forState:UIControlStateNormal];
        [self.deleteArray removeAllObjects];
    }
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MePostManagerModel *model = _dataArray[indexPath.row];
    PostALLCell *cell;
    NSString *cellIdentifier;
    cellIdentifier = model.cellIdentifier;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    [cell setMePostManagerModel:model indexpath:indexPath];
    WEAKSELF
    cell.lookRefusedTextAction = ^(NSIndexPath *indexPath) {
        [weakSelf lookRefusedAction:weakSelf.dataArray[indexPath.row]];
    };
    
    //处理选中背景色问题
    UIView *backGroundView = [[UIView alloc]init];
    backGroundView.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = backGroundView;
    //       cell.model = self.dataArray[indexPath.section];
    return cell;
}

#pragma mark - 查看被拒原因
- (void)lookRefusedAction:(MePostManagerModel *)model {
    WEAKSELF
    
    
    NSLog(@"%@",model.id);
    [[MeManager sharedInstance] getLookRefusedTextID:model.id success:^(id  _Nonnull responseObject) {
        NSDictionary * dic = responseObject;
        NSString * remark = [NSString stringWithFormat:SLLocalizedString(@"拒绝原因：%@"),NotNilAndNull([dic objectForKey:@"remark"])?[dic objectForKey:@"remark"]:@"未填写"];
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                       message:remark
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:SLLocalizedString(@"编辑") style:UIAlertActionStyleDestructive
                                                              handler:^(UIAlertAction * action) {
            
            if ([model.kind isEqualToString:@"3"] ) {
                DraftEditVideoViewController *drVC = [[DraftEditVideoViewController alloc]init];
                drVC.model = model;
                drVC.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:drVC animated:YES];
            }else
            {
                EditTextViewController *vC = [[EditTextViewController alloc]init];
                vC.pushStr = SLLocalizedString(@"发文管理");
                vC.titleStr = model.title;
                vC.contentStr = model.content;
                vC.model = model;
                vC.introductStr = model.abstracts;
                vC.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vC animated:YES];
            }
        }];
        
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:SLLocalizedString(@"确定") style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {
        }];
        [alert addAction:cancelAction];
        [alert addAction:defaultAction];
        
        [weakSelf presentViewController:alert animated:YES completion:nil];
    } failure:^(NSString * _Nonnull errorReason) {
        
    } finish:nil];
//    [[MeManager sharedInstance]getLookRefusedTextID:model.id Success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        NSLog(@"%@",responseObject);
//        if ([[responseObject objectForKey:@"code"]integerValue]==200) {
//            NSDictionary * dic = [responseObject objectForKey:@"data"];
//            NSString * remark = [NSString stringWithFormat:@"拒绝原因：%@",NotNilAndNull([dic objectForKey:@"remark"])?[dic objectForKey:@"remark"]:@"未填写"];
//
//            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
//                                                                           message:remark
//                                                                    preferredStyle:UIAlertControllerStyleAlert];
//
//            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"编辑" style:UIAlertActionStyleDestructive
//                                                                  handler:^(UIAlertAction * action) {
//
//                if ([model.kind isEqualToString:@"3"] ) {
//                    DraftEditVideoViewController *drVC = [[DraftEditVideoViewController alloc]init];
//                    drVC.model = model;
//                    drVC.hidesBottomBarWhenPushed = YES;
//                    [weakSelf.navigationController pushViewController:drVC animated:YES];
//                }else
//                {
//                    EditTextViewController *vC = [[EditTextViewController alloc]init];
//                    vC.pushStr = @"发文管理";
//                    vC.titleStr = model.title;
//                    vC.contentStr = model.content;
//                    vC.model = model;
//                    vC.introductStr = model.abstracts;
//                    vC.hidesBottomBarWhenPushed = YES;
//                    [weakSelf.navigationController pushViewController:vC animated:YES];
//                }
//            }];
//
//            UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
//                                                                 handler:^(UIAlertAction * action) {
//
//            }];
//            [alert addAction:cancelAction];
//            [alert addAction:defaultAction];
//
//            [weakSelf presentViewController:alert animated:YES completion:nil];
//        }
//    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//
//    }];
}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    MePostManagerModel *model = self.dataArray[indexPath.row];
//    return model.cellHeight;
//}
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0];
        _tableView.estimatedRowHeight = 130;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.emptyDataSetDelegate = self;
        _tableView.emptyDataSetSource = self;
    }
    return _tableView;
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SLLocalizedString(@"删除");
}


-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //根据不同状态返回不同编辑模式
    if (_isInsertEdit) {
        
        return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
        
    }else{
        
        return UITableViewCellEditingStyleDelete;
    }
}

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {
    
    //左滑删除数据方法
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.deleteArray addObject:[self.dataArray objectAtIndex:indexPath.row]];
        
        [self deleteData];
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //正常状态下，点击cell进入跳转下一页
    //在编辑模式下点击cell 是选中数据
    if (self.rightBtn.selected) {
        NSLog(@"选中");
        [self.deleteArray addObject:[self.dataArray objectAtIndex:indexPath.row]];
        
    }else{
        MePostManagerModel *model = self.dataArray[indexPath.row];
        if ([model.type isEqualToString:@"3"]) {
            return;
        }
        
        if ([model.kind isEqualToString:@"3"]) {
            NSString *videoStr ;
            for (NSDictionary *dic in model.coverurlList) {
                videoStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"route"]];
            }
            LookVideoViewController *lookVC = [[LookVideoViewController alloc]init];
            lookVC.model = model;
            lookVC.videoStr = videoStr;
            lookVC.imgUrl = [NSString stringWithFormat:@"%@%@",videoStr,Video_First_Photo];
            lookVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:lookVC animated:YES];
        } else {
            FoundDetailsViewController *vC = [[FoundDetailsViewController alloc]init];
            vC.idStr = model.id;
            vC.tabbarStr = @"Found";
            vC.typeStr = @"1";
            vC.stateStr = model.state;
            if (![model.state isEqualToString:@"6"]){
                vC.isInteractive = NO;
            }
            
            vC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vC animated:YES];
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    if (self.rightBtn.selected) {
        [self.deleteArray removeObject:[self.dataArray objectAtIndex:indexPath.row]];
    }
}

#pragma mark - device
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
@end

//
//  SLSearchResultViewController.m
//  Shaolin
//
//  Created by edz on 2020/3/23.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "SLSearchResultViewController.h"
#import "SLSearchView.h"
#import "AllSearchViewController.h"
#import "SLSearchResultView.h"
#import "HomeManager.h"

#import "SinglePhotoCell.h"
#import "MorePhotoCell.h"
#import "StickCell.h"
#import "AdvertisingOneCell.h"

#import "FoundModel.h"
#import "AllTableViewCell.h"
#import "FoundVideoListVc.h"
#import "FoundDetailsViewController.h"
#import "PureTextTableViewCell.h"
#import "SLSearchTableViewCell.h"
#import "NSString+Tool.h"

@interface SLSearchResultViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property(nonatomic,strong) UITextField *textField;

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *foundArray;
@property (nonatomic, copy) NSString *totalStr;
@property (nonatomic, assign) NSInteger pager;
@property (nonatomic, assign) NSInteger pageSize;
@end

@implementation SLSearchResultViewController
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageSize = 30;
    self.view.backgroundColor = [UIColor whiteColor];
    self.textField.text = self.searchStr;
    [self setupUI];
    [self searchData:self.searchStr];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerCellAction:) name:@"VideoPlayerAction" object:nil];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self searchData:self.searchStr];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 上拉加载
        [self loadNowMoreAction:self.searchStr];
    }];
    
    
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(NavBar_Height);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(kHeight-NavBar_Height);
    }];
    
    
    
    [self registerCell];
    
}
-(void)playerCellAction:(NSNotification *)user
{
    NSDictionary *dic = user.userInfo;
    NSIndexPath *indexpath = [dic objectForKey:@"indexPath"];
    
    FoundModel *model = self.foundArray[indexpath.row];
    if ([model.type isEqualToString:@"3"]) {
        // 是广告
        [[SLAppInfoModel sharedInstance] advertEventResponseWithFoundModel:model];
    } else
    {
        FoundVideoListVc *vC = [[FoundVideoListVc alloc]init];
           vC.hidesBottomBarWhenPushed = YES;
           vC.fieldId = model.fieldId;
           vC.videoId = model.id;
           vC.tabbarStr = @"Found";
           vC.typeStr = @"1";
           [self.navigationController pushViewController:vC animated:YES];
    }
}
-(void)searchData:(NSString *)searchStr
{
    self.pager = 1;
    NSString *pageSizeStr = [NSString stringWithFormat:@"%ld", self.pageSize];
    
    [self.tableView.mj_footer resetNoMoreData];
    
    [[HomeManager sharedInstance] getSearchTabbarStr:self.tabbarStr Serach:searchStr PageNum:@"1" PageSize:pageSizeStr Success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"code"] integerValue]==200) {
            NSArray *arr = [solveJsonData changeType:[[responseObject objectForKey:@"data"] objectForKey:@"data"]];
            NSString *total = [[responseObject objectForKey:@"data"] objectForKey:@"total"];
            if (arr.count >0) {
                if ([total integerValue] > self.pager*self.pageSize) {
                    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                        [self loadNowMoreAction:searchStr];
                    }];
                }
//                else {
//                    self.tableView.mj_footer.hidden = YES;
//                }
                [self.tableView setHidden:NO];
                self.foundArray = [FoundModel mj_objectArrayWithKeyValuesArray:arr];
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
            }else
            {
                [self.foundArray removeAllObjects];
                [self.tableView.mj_header endRefreshing];
                self.tableView.mj_footer.hidden = YES;
                [self.tableView reloadData];
                
//                self.tableView.hidden = YES;
            }
        }else
        {
//            self.tableView.hidden = YES;
            self.tableView.mj_footer.hidden = YES;
            [self.tableView.mj_header endRefreshing];
            [ShaolinProgressHUD singleTextHud:[responseObject objectForKey:@"message"] view:self.view afterDelay:TipSeconds];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        [ShaolinProgressHUD singleTextHud:kNetErrorPrompt view:self.view afterDelay:TipSeconds];
    }];
    
    
}
#pragma mark - 上拉加载
-(void)loadNowMoreAction:(NSString *)searchStr
{
    self.pager ++;
    NSString *pageSizeStr = [NSString stringWithFormat:@"%ld", self.pageSize];
    [[HomeManager sharedInstance] getSearchTabbarStr:self.tabbarStr Serach:searchStr PageNum:[NSString stringWithFormat:@"%tu",self.pager] PageSize:pageSizeStr Success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue]==200) {
            NSArray *arr = [FoundModel mj_objectArrayWithKeyValuesArray:[solveJsonData changeType:[[responseObject objectForKey:@"data"] objectForKey:@"data"]]];
            if (arr.count <1) {
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else
            {
                [self.foundArray addObjectsFromArray:arr];
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
            }
        }else
        {
            [ShaolinProgressHUD singleTextHud:responseObject[@"message"] view:self.view afterDelay:TipSeconds];
        }
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.tableView.mj_footer endRefreshing];
        [ShaolinProgressHUD singleTextHud:kNetErrorPrompt view:self.view afterDelay:TipSeconds];
    }];
    
    
}
-(void)setupUI
{
    self.navigationController.navigationBar.hidden =YES;
    
    UIView *view = [[UIView alloc] init];
    [self.view addSubview:view];
    view.userInteractionEnabled = YES;
    view.layer.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1.0].CGColor;
    view.layer.cornerRadius = SLChange(15);
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SLChange(56));
        make.width.mas_equalTo(SLChange(300));
        make.top.mas_equalTo(StatueBar_Height+SLChange(7));
        make.height.mas_equalTo(SLChange(30));
    }];
    UIButton *leftBtn = [[UIButton alloc]init];
    
    [leftBtn setImage:[UIImage imageNamed:@"left"] forState:(UIControlStateNormal)];
    //    [self.left setTitle:@"" forState:(UIControlStateNormal)];
    //    self.left.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    //           leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 45);
    [leftBtn addTarget:self action:@selector(leftAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SLChange(16));
        make.width.mas_equalTo(SLChange(15));
        make.centerY.mas_equalTo(view);
        make.height.mas_equalTo(SLChange(22));
    }];
    UIButton *searchBtn = [[UIButton alloc]init];
    [view addSubview:searchBtn];
    [searchBtn setImage:[UIImage imageNamed:@"search"] forState:(UIControlStateNormal)];
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(SLChange(12.5));
        make.left.mas_equalTo(SLChange(16));
        make.centerY.mas_equalTo(view);
    }];
    
    [view addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(searchBtn.mas_right).offset(SLChange(14));
        make.centerY.mas_equalTo(view);
        make.width.mas_equalTo(SLChange(200));
        make.height.mas_equalTo(SLChange(16.5));
    }];
    
    UIButton *search = [[UIButton alloc]init];
    [view addSubview:search];
    [search addTarget:self action:@selector(searchAction) forControlEvents:(UIControlEventTouchUpInside)];
    search.titleLabel.font = kRegular(12);
    [search setTitleColor:[UIColor colorForHex:@"333333"] forState:(UIControlStateNormal)];
    [search setTitle:SLLocalizedString(@"搜索") forState:(UIControlStateNormal)];
    [search mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SLChange(24));
        make.right.mas_equalTo(view.mas_right).offset(-SLChange(16));
        make.centerY.mas_equalTo(view);
        make.height.mas_equalTo(SLChange(16.5));
    }];
    
    UIView *v = [[UIView alloc]init];
    v.backgroundColor = [UIColor colorForHex:@"DDDDDD"];
    [view addSubview:v];
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(search.mas_left).offset(-SLChange(13.5));
        make.width.mas_equalTo(0.5);
        make.height.mas_equalTo(SLChange(11.5));
        make.centerY.mas_equalTo(view);
    }];
    UIView *v1 = [[UIView alloc]init];
    v1.backgroundColor = RGBA(237, 237, 237, 1);
    [self.view addSubview:v1];
    [v1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(view.mas_bottom).offset(SLChange(7));
    }];
}
-(void)searchAction
{
    if (self.textField.text.length == 0) {
        [self.foundArray removeAllObjects];
        [self.tableView reloadData];
//        self.tableView.hidden = YES;
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"搜索内容不能为空") view:self.view afterDelay:TipSeconds];
    }else
    {
        self.searchStr = self.textField.text;
        [self searchData:self.searchStr];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    NSLog(@"点击了搜索");
    
    
    if (self.textField.text.length == 0) {
        [self.foundArray removeAllObjects];
        [self.tableView reloadData];
//        self.tableView.hidden = YES;
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"搜索内容不能为空") view:self.view afterDelay:TipSeconds];
    }else
    {
        self.searchStr = self.textField.text;
        [self searchData:self.searchStr];
    }
    [_textField resignFirstResponder];
    return YES;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([NSString isContainsEmoji:string]) {
        return NO;
    }
    return YES;
}

-(void)registerCell
{
    
    [_tableView registerClass:[SinglePhotoCell class]
       forCellReuseIdentifier:NSStringFromClass([SinglePhotoCell class])];
    
    [_tableView registerClass:[MorePhotoCell class]
       forCellReuseIdentifier:NSStringFromClass([MorePhotoCell class])];
    [_tableView registerClass:[PureTextTableViewCell class]
       forCellReuseIdentifier:NSStringFromClass([PureTextTableViewCell class])];
    
    [_tableView registerClass:[StickCell class] forCellReuseIdentifier:NSStringFromClass([StickCell class])];
    [_tableView registerClass:[AdvertisingOneCell class] forCellReuseIdentifier:NSStringFromClass([AdvertisingOneCell class])];
    [_tableView registerClass:[SLSearchTableViewCell class] forCellReuseIdentifier:NSStringFromClass([SLSearchTableViewCell class])];
}

#pragma mark - DZNEmptyDataSetDelegate && dataSource
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    
    return !self.foundArray.count;
}

-(CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -30;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = SLLocalizedString(@"暂无数据");
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15.0f],
                                 NSForegroundColorAttributeName: [UIColor hexColor:@"999999"]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"categorize_nogoods"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _foundArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    FoundModel *model = _foundArray[indexPath.row];
    NSString *cellIdentifier = @"SLSearchTableViewCell";
    SLSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setModel:model];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    FoundModel *model = self.foundArray[indexPath.row];

    if ([model.type isEqualToString:@"3"]) {
        // 是广告
        [[SLAppInfoModel sharedInstance] advertEventResponseWithFoundModel:model];
    }else{
       NSInteger clicksCount = [model.clicks integerValue];
        clicksCount += 1;
        model.clicks = [NSString stringWithFormat:@"%ld",clicksCount];
        [self.foundArray setObject:model atIndexedSubscript:indexPath.row];
        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section], nil] withRowAnimation:UITableViewRowAnimationNone];
        
        if ([model.kind isEqualToString:@"3"]) {
            FoundVideoListVc *vC = [[FoundVideoListVc alloc]init];
            vC.hidesBottomBarWhenPushed = YES;
            vC.fieldId = model.fieldId;
            vC.videoId = model.id;
            vC.tabbarStr = @"Found";
            vC.typeStr = @"1";
            [self.navigationController pushViewController:vC animated:YES];
        } else {
            FoundDetailsViewController *vC = [[FoundDetailsViewController alloc]init];
            vC.idStr = model.id;
            vC.tabbarStr = self.tabbarStr;
            vC.typeStr = @"1";
            vC.stateStr = !model.state ? @"" : model.state;
            vC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vC animated:YES];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FoundModel *model = self.foundArray[indexPath.row];
    return model.cellHeight;
}

-(void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        
        [_textField setTextColor:[UIColor blackColor]];
        _textField.font = kMediumFont(12);
        
        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.placeholder = SLLocalizedString(@"输入要搜索的内容");
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.returnKeyType = UIReturnKeySearch;
        _textField.delegate = self;
        [_textField setValue:[UIColor colorForHex:@"999999"] forKeyPath:@"placeholderLabel.textColor"];
        [_textField setValue:kRegular(12) forKeyPath:@"placeholderLabel.font"];
    }
    return _textField;
}

#pragma mark - Getters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.tableFooterView = [UIView new];
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        
        _tableView.separatorColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
        
    }
    return _tableView;
}


@end

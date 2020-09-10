//
//  SLSearchResultViewController.m
//  Shaolin
//
//  Created by edz on 2020/3/23.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "SLSearchResultViewController.h"
#import "FoundVideoListVc.h"
#import "FoundDetailsViewController.h"
#import "KungfuWebViewController.h"
#import "AllSearchViewController.h"


#import "SLSearchResultView.h"
#import "SLSearchTableViewCell.h"

#import "HomeManager.h"
#import "ActivityManager.h"

#import "FoundModel.h"

#import "NSString+Tool.h"
#import "DefinedHost.h"

@interface SLSearchResultViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property(nonatomic,strong) UITextField *textField;

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *foundArray;
@property (nonatomic, copy) NSString *totalStr;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) NSInteger pageSize;
@end

@implementation SLSearchResultViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.pageNum = 1;
    self.pageSize = 30;
    
    self.textField.text = self.searchStr;
    
    [self setupUI];
}

- (void)setupUI {
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
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(NavBar_Height);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(kHeight-NavBar_Height-kBottomSafeHeight);
    }];
        
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - request
- (void)requestSearchResultList {
    
    [self.foundArray removeAllObjects];
    
    if (self.isRite) {
        [self searchRite];
    } else {
        [self searchActivity];
    }
}

- (void)searchActivity {
    
    NSString * pageNum = [NSString stringWithFormat:@"%ld",self.pageNum];
    NSString * pageSize = [NSString stringWithFormat:@"%ld",self.pageSize];
    
//    [[HomeManager sharedInstance] getSearchTabbarStr:self.tabbarStr Serach:self.searchStr PageNum:pageNum PageSize:pageSize Success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//            NSLog(@"%@",responseObject);
//            if ([[responseObject objectForKey:@"code"] integerValue]==200) {
//                
//                NSArray *arr = [solveJsonData changeType:[[responseObject objectForKey:@"data"] objectForKey:@"data"]];
//                    
//                [self.foundArray addObjectsFromArray:[FoundModel mj_objectArrayWithKeyValuesArray:arr]];
//                
//                [self.tableView.mj_header endRefreshing];
//                [self.tableView.mj_footer endRefreshing];
//                [self.tableView reloadData];
//                    
//            }
//        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//            [self.tableView.mj_header endRefreshing];
//            [self.tableView.mj_footer endRefreshing];
//            [ShaolinProgressHUD singleTextHud:kNetErrorPrompt view:self.view afterDelay:TipSeconds];
//        }];
    
    
    [[HomeManager sharedInstance]getSearchTabbarStr:self.tabbarStr Serach:self.searchStr PageNum:pageNum PageSize:pageSize Success:^(NSDictionary * _Nullable resultDic) {
        
    } failure:^(NSString * _Nullable errorReason) {
        
    } finish:^(NSDictionary * _Nullable responseObject, NSString * _Nullable errorReason) {
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"code"] integerValue]==200) {
            
            NSArray *arr = [solveJsonData changeType:[[responseObject objectForKey:@"data"] objectForKey:@"data"]];
                
            [self.foundArray addObjectsFromArray:[FoundModel mj_objectArrayWithKeyValuesArray:arr]];
            
        }
        [self.tableView.mj_header endRefreshing];
                   [self.tableView.mj_footer endRefreshing];
                   [self.tableView reloadData];
    }];
}

- (void)searchRite {
    
    NSDictionary * parames = @{@"search":self.searchStr};
    [ActivityManager getSearchRiteListWithParams:parames success:^(NSDictionary * _Nullable resultDic) {
        
        NSArray * data = resultDic[@"data"];
        
        if (data.count) {
            for (NSDictionary * dic in data) {
                FoundModel * m = [FoundModel new];
                m.title = NotNilAndNull(dic[@"name"])?dic[@"name"]:@"";
                m.type = NotNilAndNull(dic[@"type"])?dic[@"type"]:@"";
                m.code = NotNilAndNull(dic[@"code"])?dic[@"code"]:@"";
                m.author = @"";
                m.isRite = YES;
                
                [self.foundArray addObject:m];
            }
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSString * _Nullable errorReason) {
        
        [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}


#pragma mark - event
- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchAction {
    
    if (self.textField.text.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入搜索内容") view:self.view afterDelay:TipSeconds];
        return;
    } else {
        self.searchStr = self.textField.text;
    }
    
    [self setHistoryArrWithStr:self.searchStr];
    [self requestSearchResultList];
    [self.view endEditing:YES];
}

- (void)setHistoryArrWithStr:(NSString *)str
{
    if (str.length == 0) {
        return;;
    }
    
    for (int i = 0; i < _historyArray.count; i++) {
        if ([_historyArray[i] isEqualToString:str]) {
            [_historyArray removeObjectAtIndex:i];
            break;
        }
    }
    [_historyArray insertObject:str atIndex:0];
    [NSKeyedArchiver archiveRootObject:_historyArray toFile:KHistorySearchPath];
}

#pragma mark - textFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.textField.text.length == 0) {
        self.searchStr = @"";
    } else {
        self.searchStr = self.textField.text;
    }
    
    [self requestSearchResultList];
    [self.view endEditing:YES];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([NSString isContainsEmoji:string]) {
        return NO;
    }
    return YES;
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

    if (model.isRite) {
        KungfuWebViewController *webVC = [[KungfuWebViewController alloc] initWithUrl:URL_H5_RiteDetail(model.code, [SLAppInfoModel sharedInstance].access_token) type:KfWebView_rite];
        webVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webVC animated:YES];
        webVC.fillToView = YES;
        [webVC hideWebViewScrollIndicator];
    } else {
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
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FoundModel *model = self.foundArray[indexPath.row];
    return model.cellHeight;
}

#pragma mark - Getters
- (UITableView *)tableView {
    WEAKSELF
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
        
        [_tableView registerClass:[SLSearchTableViewCell class] forCellReuseIdentifier:NSStringFromClass([SLSearchTableViewCell class])];

        
        _tableView.separatorColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
        
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.pageNum = 1;
            [weakSelf.foundArray removeAllObjects];
            [weakSelf requestSearchResultList];
        }];

        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            weakSelf.pageNum++;
            [weakSelf requestSearchResultList];
        }];
    }
    return _tableView;
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

-(NSMutableArray *)foundArray {
    if (!_foundArray) {
        _foundArray = [NSMutableArray new];
    }
    return _foundArray;
}

@end

//
//  AllSearchViewController.m
//  Shaolin
//
//  Created by edz on 2020/3/23.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "AllSearchViewController.h"
#import "SLSearchView.h"
#import "SLSearchResultViewController.h"
#import "HomeManager.h"
#import "NSString+Tool.h"
#import "SMAlert.h"

#import "SearchHistoryModel.h"


@interface AllSearchViewController ()<UITextFieldDelegate>
@property(nonatomic,strong) UITextField *textField;
@property (nonatomic, strong) SLSearchView *searchView;
@property (nonatomic, strong) NSMutableArray *hotArray;
@property (nonatomic, strong) NSMutableArray *historyArray;
@end

@implementation AllSearchViewController
- (NSMutableArray *)hotArray
{
    if (!_hotArray) {
        self.hotArray = [NSMutableArray array];
    }
    return _hotArray;
}

- (NSMutableArray *)historyArray
{
    if (!_historyArray) {
//        _historyArray = [NSKeyedUnarchiver unarchiveObjectWithFile:KHistorySearchPath];
//        _historyArray = [[[ModelTool shareInstance]selectALL:[SearchHistoryModel class] tableName:@"searchHistory"] mutableCopy];
        
        SearchHistoryType type;
        if ([self.tabbarStr isEqualToString:@"Activity"]) {
            if (self.isRite) {
                type = SearchHistoryRiteClassroomType;
            }else{
                type = SearchHistoryRiteCharityType;
            }
        }else if([self.tabbarStr isEqualToString:@"Found"]){
            type = SearchHistoryArticleType;
        }else{
            type = 0;
        }
        
        _historyArray = [[[ModelTool shareInstance] select:[SearchHistoryModel class] tableName:@"searchHistory" where:[NSString stringWithFormat:@"type = '%ld' AND userId = '%@' ORDER BY id DESC", type, [SLAppInfoModel sharedInstance].id]] mutableCopy];
        
        if (!_historyArray) {
            self.historyArray = [NSMutableArray array];
        }
    }
    return _historyArray;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!_textField.isFirstResponder) {
        [self.textField becomeFirstResponder];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self.tabbarStr isEqualToString:@"Activity"]) {
        [self setSearchView];
    } else {
        [self hotData];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 回收键盘
    [self.textField resignFirstResponder];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
    self.hideNavigationBarView = YES;
}
#pragma mark - 热词
- (void)hotData
{
    [self.hotArray removeAllObjects];
    
//    [[HomeManager sharedInstance]getTopicTabbarStr:self.tabbarStr Success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        NSLog(@"%@",responseObject);
//        if ([[responseObject objectForKey:@"code"] integerValue]==200) {
//            
//            if ([self.tabbarStr isEqualToString:@"Found"]) {
//                NSArray *arr = [[responseObject objectForKey:@"data"] objectForKey:@"list"];
//                for (NSDictionary *dic in arr) {
//                    [self.hotArray addObject:[dic objectForKey:@"name"]];
//                }
//                [self setSearchView];
//            }else
//            {
//                NSArray *arr = [[responseObject objectForKey:@"data"] objectForKey:@"data"];
//                for (NSDictionary *dic in arr) {
//                    [self.hotArray addObject:[dic objectForKey:@"name"]];
//                }
//                [self setSearchView];
//            }
//        }
//    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//        
//    }];
    
    [[HomeManager sharedInstance]getTopicTabbarStr:self.tabbarStr Success:^(NSDictionary * _Nullable resultDic) {
    } failure:^(NSString * _Nullable errorReason) {
        
    } finish:^(NSDictionary * _Nullable responseObject, NSString * _Nullable errorReason) {
        NSLog(@"%@",responseObject);
               if ([[responseObject objectForKey:@"code"] integerValue]==200) {
                   
                   if ([self.tabbarStr isEqualToString:@"Found"]) {
                       NSArray *arr = [[responseObject objectForKey:@"data"] objectForKey:@"list"];
                       for (NSDictionary *dic in arr) {
                           [self.hotArray addObject:[dic objectForKey:@"name"]];
                       }
                       [self setSearchView];
                   }else
                   {
                       NSArray *arr = [[responseObject objectForKey:@"data"] objectForKey:@"data"];
                       for (NSDictionary *dic in arr) {
                           [self.hotArray addObject:[dic objectForKey:@"name"]];
                       }
                       [self setSearchView];
                   }
               }
    }];
    
}
- (void)setSearchView
{
    if ([self.tabbarStr isEqualToString:@"Wengen"]) {
        [self.hotArray removeAllObjects];
    }else {
        
    }
    self.searchView = [[SLSearchView alloc] initWithFrame:CGRectMake(0, NavBar_Height+10, kWidth, kHeight - NavBar_Height) hotArray:self.hotArray historyArray:self.historyArray];
    _searchView.typeStr = @"Wengen";
    __weak AllSearchViewController *weakSelf = self;
    _searchView.tapAction = ^(NSString *str) {
        [weakSelf pushToSearchResultWithSearchStr:str];
    };
   
    _searchView.ClearHistoryBlock = ^{
        [SMAlert showAlertWithInfoString:SLLocalizedString(@"确定删除全部历史记录？") confirmButtonTitle:SLLocalizedString(@"确定") cancelButtonTitle:SLLocalizedString(@"取消") success:^{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ClearHistory" object:nil userInfo:@{@"tabbarStr":weakSelf.tabbarStr, @"isRite":[NSString stringWithFormat:@"%d", weakSelf.isRite]}];
        } cancel:^{
            
        }];
    };
    [self.view addSubview:self.searchView];
}
- (void)closeAction
{
    __weak typeof(self)weakSelf =self;
    [SLSearchView animateWithDuration:0.5 animations:^{
        weakSelf.searchView.alpha = 0;
    } completion:^(BOOL finished) {
        //           [weakSelf removeFromSuperview];
        [weakSelf.searchView removeFromSuperview];
    }];
}

- (void)setupUI
{
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
    [search setTitleColor:KTextGray_333 forState:(UIControlStateNormal)];
    [search setTitle:SLLocalizedString(@"搜索") forState:(UIControlStateNormal)];
    [search mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SLChange(24));
        make.right.mas_equalTo(view.mas_right).offset(-SLChange(16));
        make.centerY.mas_equalTo(view);
        make.height.mas_equalTo(SLChange(16.5));
    }];
    
    UIView *v = [[UIView alloc]init];
    v.backgroundColor = KTextGray_DDD;
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
- (void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        
        [_textField setTextColor:KTextGray_999];
        _textField.font = kRegular(12);
        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.placeholder = SLLocalizedString(@"请输入要搜索的内容");
//        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.returnKeyType = UIReturnKeySearch;
        _textField.delegate = self;
        [_textField setValue:KTextGray_999 forKeyPath:@"placeholderLabel.textColor"];
        [_textField setValue:kRegular(12) forKeyPath:@"placeholderLabel.font"];
    }
    return _textField;
}
- (void)presentVCFirstBackClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


/** 点击取消 */
- (void)cancelDidClick
{
    [self.textField resignFirstResponder];
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)searchAction
{
    if (self.textField.text.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入搜索内容") view:self.view afterDelay:TipSeconds];
        return;
    }
    
    [self closeAction];
    
    SLSearchResultViewController *searchResultVC = [[SLSearchResultViewController alloc] init];
    searchResultVC.searchStr = self.textField.text;
    searchResultVC.hotArray = _hotArray;
    searchResultVC.historyArray = _historyArray;
    searchResultVC.tabbarStr = self.tabbarStr;
    searchResultVC.isRite = self.isRite;
    [self.navigationController pushViewController:searchResultVC animated:YES];
    [self setHistoryArrWithStr:self.textField.text];
}
- (void)pushToSearchResultWithSearchStr:(NSString *)str
{
    [self closeAction];
    self.textField.text = str;
    SLSearchResultViewController *searchResultVC = [[SLSearchResultViewController alloc] init];
    searchResultVC.searchStr = str;
    searchResultVC.hotArray = _hotArray;
    searchResultVC.historyArray = _historyArray;
    searchResultVC.isRite = self.isRite;
    searchResultVC.tabbarStr = self.tabbarStr;
    [self.navigationController pushViewController:searchResultVC animated:YES];
    [self setHistoryArrWithStr:str];
}

- (void)setHistoryArrWithStr:(NSString *)str
{

    if (str.length == 0) {
        return;
    }
    
    NSString *userId = [SLAppInfoModel sharedInstance].id;
    
    SearchHistoryModel *historyModel = [[SearchHistoryModel alloc]init];
    historyModel.userId = userId;
    historyModel.searchContent = str;
    
    if ([self.tabbarStr isEqualToString:@"Activity"]) {
        if (self.isRite) {
            //法会 - 客堂
            historyModel.type = [NSString stringWithFormat:@"%ld", SearchHistoryRiteClassroomType];
        }else{
            //法会 - 慈善
            historyModel.type = [NSString stringWithFormat:@"%ld", SearchHistoryRiteCharityType];
        }
        
    }else if([self.tabbarStr isEqualToString:@"Found"]){
        // 文章
        historyModel.type = [NSString stringWithFormat:@"%ld", SearchHistoryArticleType];
    }
    
    
    
    [historyModel addSearchWordWithDataArray:_historyArray];
//
//    for (int i = 0; i < self.historyArray.count; i++) {
//        SearchHistoryModel *tempHistoryModel = self.historyArray[i];
//        if ([tempHistoryModel.searchContent isEqualToString:str]) {
//            [self.historyArray removeObjectAtIndex:i];
//            [[ModelTool shareInstance]deleteTableName:@"searchHistory" where:[NSString stringWithFormat:@"userId = '%@' AND searchContent = '%@'", userId, str]];
//            break;
//        }
//    }
//
//    [self.historyArray insertObject:historyModel atIndex:0];
//
//
//    [[ModelTool shareInstance]insert:historyModel tableName:@"searchHistory"];
//
//    NSArray *tempDataArray = [[ModelTool shareInstance] select:[SearchHistoryModel class] tableName:@"searchHistory" where:[NSString stringWithFormat:@"type = '%ld' AND userId = '%@' ORDER BY id DESC", SearchHistoryArticleType, userId]];
//
//    if ([tempDataArray count] > 20) {
//        [[ModelTool shareInstance]deleteTableName:@"searchHistory" where:[NSString stringWithFormat:@"id <(select max(id) - 20 from searchHistory where userId = '%@' AND type = '%ld')", userId, SearchHistoryArticleType]];
//    }
//
    
    
    
//    for (int i = 0; i < _historyArray.count; i++) {
//        if ([_historyArray[i] isEqualToString:str]) {
//            [_historyArray removeObjectAtIndex:i];
//            break;
//        }
//    }
//    [_historyArray insertObject:str atIndex:0];
//    [NSKeyedArchiver archiveRootObject:_historyArray toFile:KHistorySearchPath];
}




#pragma mark - UISearchBarDelegate -

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    NSLog(@"点击了搜索");
    
    if (self.textField.text.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入搜索内容") view:self.view afterDelay:TipSeconds];
    }else
    {
        [self pushToSearchResultWithSearchStr:self.textField.text];
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
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.textField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchBar.text == nil || [searchBar.text length] <= 0) {
        
        [self.view bringSubviewToFront:_searchView];
    } else {
        
        
    }
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

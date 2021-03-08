//
//  LogisticsViewController.m
//  Shaolin
//
//  Created by 王精明 on 2020/6/18.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "LogisticsViewController.h"
#import "NSString+PinYin.h"
#import "NSString+LGFRegex.h"
#import "MeManager.h"

//#define LogisticsViewController_TestData

@interface LogisticsCell : UITableViewCell
- (void)setTitle:(NSString *)title;
@end

@interface LogisticsViewController () <UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate >
@property (nonatomic, strong) UIView *whiteBackView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UITableView *logisticsTableView;
@property (nonatomic, strong) UIView *searchBackView;

@property (nonatomic) BOOL isSearch;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *indexArray;

@end

@implementation LogisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isSearch = NO;
    self.indexArray = [@[] mutableCopy];
    self.dataArray = [@[] mutableCopy];
    
    [self setupUI];
    self.titleLabel.text = SLLocalizedString(@"选择物流");

#ifdef LogisticsViewController_TestData
    [self initDataSource];
#else
    [self requestData];
#endif
}

- (void)setupUI{
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    
    [self.view addSubview:self.whiteBackView];
    
    [self.whiteBackView addSubview:self.closeButton];
    [self.whiteBackView addSubview:self.titleLabel];
    [self.whiteBackView addSubview:self.searchBackView];
    [self.whiteBackView addSubview:self.logisticsTableView];
    
    [self.whiteBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SLChange(20) + StatueBar_Height);
        make.left.right.bottom.mas_equalTo(0);
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SLChange(10));
        make.centerY.mas_equalTo(self.titleLabel);
        make.size.mas_equalTo(CGSizeMake(SLChange(30), SLChange(30)));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(SLChange(16));
        make.size.mas_equalTo(CGSizeMake(SLChange(200), SLChange(24)));
    }];
    
    [self.searchBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SLChange(12));
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(SLChange(15));
        make.right.mas_equalTo(SLChange(-12));
        make.height.mas_equalTo(SLChange(30));
    }];
    [self.logisticsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchBackView.mas_bottom).mas_equalTo(SLChange(15));
        make.left.right.bottom.mas_equalTo(0);
    }];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    UIBezierPath *rounded = [UIBezierPath bezierPathWithRoundedRect:self.whiteBackView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(SLChange(12.5), SLChange(12.5))];
    CAShapeLayer *shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    self.whiteBackView.layer.mask = shape;
}

#pragma mark - requestData
- (void)requestData{
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    WEAKSELF
    [[MeManager sharedInstance] postLogisticsListBlock:^(id  _Nonnull responseObject, NSString * _Nonnull errorReason) {
        NSLog(@"postLogisticsListBlock:%@", responseObject);
        NSLog(@"postLogisticsListBlock:%@", errorReason);
        
        [hud hideAnimated:YES];
        [weakSelf.dataArray removeAllObjects];
        if ([ModelTool checkResponseObject:responseObject]){
            NSDictionary *data = responseObject[DATAS];
            NSMutableArray *array = [@[] mutableCopy];
            NSArray *dataList = [data objectForKey:DATAS];
            for (NSDictionary *dict in dataList){
                NSString *courierName = [dict objectForKey:@"courierName"];
                NSLog(@"courierName : %@", courierName);
                if (courierName){
                    [array addObject:courierName];
                }
            }
            weakSelf.dataArray = [[array arrayWithPinYinFirstLetterFormat] mutableCopy];
            [weakSelf.logisticsTableView reloadData];
        }
    }];
}
#pragma mark - test
- (void)initDataSource {
    NSArray *array = @[@"1", @"2", @"3", @"4", @"5", @"6"];
    NSArray *indexArray = [array arrayWithPinYinFirstLetterFormat];
    self.dataArray =[NSMutableArray arrayWithArray:indexArray];
    [self.logisticsTableView reloadData];
}

#pragma mark - UITableViewDelegate And UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.isSearch){
        return 1;
    }
    return [self.dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isSearch){
        return self.indexArray.count;
    }
//    if(section == 0) {
//        return 1;
//    } else {
        NSDictionary *dict = self.dataArray[section];
        NSMutableArray *array = dict[@"content"];
        return [array count];
//    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LogisticsCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell){
        cell = [[LogisticsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    NSString *title = @"";
    if (self.isSearch){
        title = self.indexArray[indexPath.row];
    } else {
        NSDictionary *dict = self.dataArray[indexPath.section];
        NSMutableArray *array = dict[@"content"];
        title = array[indexPath.row];
    }
    [cell setTitle:title];
    cell.separatorInset = UIEdgeInsetsZero;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.view endEditing:YES];
    if (self.selectedLogisticsName){
        NSString *title = @"";
        if (self.isSearch){
            title = self.indexArray[indexPath.row];
        } else {
            NSDictionary *dict = self.dataArray[indexPath.section];
            NSMutableArray *array = dict[@"content"];
            title = array[indexPath.row];
        }
        self.selectedLogisticsName(title);
    }
    [self closeLogisticsVC];
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.isSearch){
        return [UIView new];
    }
    //自定义Header标题
    UIView* myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), SLChange(35))];
    
    myView.backgroundColor = KTextGray_FA;//[UIColor colorWithRed:0.10 green:0.68 blue:0.94 alpha:0.7];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = KTextGray_333;
    titleLabel.font = kMediumFont(14);

    NSString *title = self.dataArray[section][@"firstLetter"];
    titleLabel.text = title;
    [myView addSubview:titleLabel];

    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SLChange(12));
        make.top.bottom.right.mas_equalTo(0);
    }];
    return myView;
}

//添加TableView头视图标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.isSearch){
        return @"";
    }
    NSDictionary *dict = self.dataArray[section];
    NSString *title = dict[@"firstLetter"];
    return title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.isSearch){
        return 0;
    }
    return SLChange(35);
}

#pragma mark tableView索引相关设置
//添加索引栏标题数组
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (self.isSearch) {
        return @[];
    }
    NSMutableArray *resultArray =[NSMutableArray arrayWithObject:UITableViewIndexSearch];
    for (NSDictionary *dict in self.dataArray) {
        NSString *title = dict[@"firstLetter"];
        [resultArray addObject:title];
    }
    return resultArray;
}

//点击索引栏标题时执行
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    [self.view endEditing:YES];
    //这里是为了指定索引index对应的是哪个section的，默认的话直接返回index就好。其他需要定制的就针对性处理
    if ([title isEqualToString:UITableViewIndexSearch]) {
        [tableView setContentOffset:CGPointZero animated:NO];//tabview移至顶部
        return NSNotFound;
    } else {
        return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index] - 1; // -1 添加了搜索标识
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate
- (void)textDidChanged:(UITextField *)textfield{
    UITextRange *selectedRange = [textfield markedTextRange];
    //获取高亮部分
    UITextPosition *position = [textfield positionFromPosition:selectedRange.start offset:0];
    // 有高亮选择的字，不搜索
    if (position) return;
    
    [self.indexArray removeAllObjects];
    
    NSString *searchText = textfield.text;
    if (searchText.length == 0) {
        self.isSearch = NO;
    } else {
        self.isSearch = YES;
        for (NSDictionary *dict in self.dataArray){
            NSArray *contentArray = [dict objectForKey:@"content"];
//            for (NSString *courierName in contentArray){
//                if ([courierName containsString:searchText]){
//                    [self.indexArray addObject:courierName];
//                }
//            }
            
            //检测输入的是不是拼音
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[A-Za-z]*$"];
            NSMutableArray* resultArry = [NSMutableArray array];
            //是拼音则匹配以输入的拼音开头的且不区分大小写的字符
            if ([predicate evaluateWithObject:searchText]) {
                NSPredicate *predict = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH[cd] %@",searchText];
                NSArray* spallArry = [contentArray filteredArrayUsingPredicate:predict];
                resultArry = [NSMutableArray arrayWithArray:spallArry];
            }else{//输入的是数字或者汉字 则匹配名字中包含输入字符
                NSPredicate *predict = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@",searchText];
                //或者使用 @", nil)name LIKE[cd] '*%@*'"    //*代表通配符
                resultArry = [contentArray filteredArrayUsingPredicate:predict].mutableCopy;
            }
            self.indexArray = [NSMutableArray arrayWithArray:resultArry];
            if (self.indexArray.count){
                break;
            }
        }
    }
    [self.logisticsTableView reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - buttonClick
- (void)closeLogisticsVC{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - setter、getter
- (UIView *)whiteBackView{
    if (!_whiteBackView){
        _whiteBackView = [[UIView alloc] init];
        _whiteBackView.backgroundColor = [UIColor whiteColor];
        _whiteBackView.layer.cornerRadius = SLChange(12.5);
        _whiteBackView.clipsToBounds = YES;
    }
    return _whiteBackView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kRegular(17);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = KTextGray_333;
        
    }
    return _titleLabel;
}

- (UIButton *)closeButton{
    if (!_closeButton){
        _closeButton = [[UIButton alloc] init];
        [_closeButton setImage:[UIImage imageNamed:@"downArrow_black"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeLogisticsVC) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIView *)searchBackView {
    if (!_searchBackView){
        _searchBackView = [[UIView alloc] init];
        _searchBackView.backgroundColor = KTextGray_FA;
        _searchBackView.clipsToBounds = YES;
        _searchBackView.layer.cornerRadius = SLChange(15);//设置圆角具体根据实际情况来设置
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"new_search"]];
        UITextField *searchTF = [[UITextField alloc] init];
        searchTF.textColor = KTextGray_333;
        searchTF.font = kRegular(13);
        searchTF.delegate = self;
        searchTF.returnKeyType = UIReturnKeyDone;
        searchTF.placeholder = SLLocalizedString(@"搜索词");
        searchTF.backgroundColor = [UIColor clearColor];
        [searchTF addTarget:self action:@selector(textDidChanged:) forControlEvents:UIControlEventEditingChanged];
        
        [_searchBackView addSubview:imageView];
        [_searchBackView addSubview:searchTF];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(SLChange(12.5));
            make.centerY.mas_equalTo(imageView.superview);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        [searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imageView.mas_right).mas_offset(SLChange(5));
            make.centerY.mas_equalTo(imageView);
            make.right.mas_equalTo(-SLChange(12.5));
            make.height.mas_equalTo(SLChange(18));
        }];
    }
    return _searchBackView;
}

- (UITableView *)logisticsTableView {
    if (!_logisticsTableView){
//        _logisticsTableView = [[UITableView  alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _logisticsTableView = [[UITableView  alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 0) style:UITableViewStylePlain];
        _logisticsTableView.delegate = self;
        _logisticsTableView.dataSource = self;
        
        _logisticsTableView.rowHeight = SLChange(44);
//        _logisticsTableView.sectionHeaderHeight = SLChange(35);
//        _logisticsTableView.contentSize=CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*2);
        
        _logisticsTableView.sectionIndexColor = KTextGray_999;//[UIColor colorWithRed:0.10 green:0.68 blue:0.94 alpha:1.0];
//        _logisticsTableView.sectionIndexTrackingBackgroundColor = kMainYellow;
        
        _logisticsTableView.sectionIndexBackgroundColor = [UIColor clearColor];
        [_logisticsTableView registerClass:[LogisticsCell class] forCellReuseIdentifier:@"cellID"];
        
    }
    return _logisticsTableView;
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

@interface LogisticsCell()
@property (nonatomic, strong) UILabel *titleLabel;
@end
@implementation LogisticsCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    [self.contentView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SLChange(12));
        make.right.top.bottom.mas_equalTo(0);
    }];
}

- (void)setTitle:(NSString *)title{
    self.titleLabel.text = title;
}

- (UILabel *)titleLabel{
    if (!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = KTextGray_333;//[UIColor colorWithRed:0.10 green:0.68 blue:0.94 alpha:1.0];
        _titleLabel.font = kRegular(15);
    }
    return _titleLabel;
}
@end

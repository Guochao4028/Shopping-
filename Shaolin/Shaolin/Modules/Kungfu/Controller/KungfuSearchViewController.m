//
//  KungfuSearchViewController.m
//  Shaolin
//
//  Created by ws on 2020/5/21.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuSearchViewController.h"

#import "KfSearchBarView.h"

#import "WengenSearchResultViewController.h"
#import "KungfuClassListViewController.h"
#import "EnrollmentViewController.h"
#import "KungfuInstitutionViewController.h"

#import "SMAlert.h"

#import "SearchHistoryModel.h"


static NSString *const typeCellId = @"typeTableCell";

@interface KungfuSearchViewController () <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) KfSearchBarView *navgationView;

@property (nonatomic, strong) UIView *searchHistoryView;

@property (nonatomic, strong) NSMutableArray *historyArray;

@property (nonatomic, strong) UITableView * typeTable;
@property (nonatomic, strong) NSArray *typeTableList;
@property (nonatomic, strong) UIImageView *typeTableBackView;



@end

@implementation KungfuSearchViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.hideNavigationBar = YES;
    self.typeTableList = @[SLLocalizedString(@"教程"),SLLocalizedString(@"活动"),SLLocalizedString(@"机构")];
    if (IsNilOrNull(self.typeString)) {
        self.typeString = SLLocalizedString(@"教程");
    }
    [self initUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.historyArray = [[[ModelTool shareInstance] select:[SearchHistoryModel class] tableName:@"searchHistory" where:[NSString stringWithFormat:@"type = '%ld' AND userId = '%@' ORDER BY id DESC", SearchHistoryCourseType, [SLAppInfoModel sharedInstance].id]] mutableCopy];
    [self.searchHistoryView removeFromSuperview];
    if (self.historyArray.count > 0) {
        self.searchHistoryView = [self setViewWithOriginY:CGRectGetMaxY(self.navgationView.frame) title:SLLocalizedString(@"搜索历史") textArr:self.historyArray];
    } else {
        self.searchHistoryView = [self setNoHistoryView];
    }
    [self.view addSubview:self.searchHistoryView];
    [self.navgationView.searchTF becomeFirstResponder];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navgationView becomeFirstResponder];
}

-(void)initUI{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.navgationView];
    [self.view addSubview:self.typeTableBackView];
    [self.typeTableBackView addSubview:self.typeTable];
    [self.view addSubview:self.searchHistoryView];
    
    [self.navgationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kStatusBarHeight);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
}

#pragma mark - tableviewDelegate && dataSource


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.typeTableList.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:typeCellId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = UIColor.clearColor;
    cell.contentView.backgroundColor = UIColor.clearColor;
    
    cell.textLabel.text = self.typeTableList[indexPath.row];
    cell.textLabel.font = kRegular(12);
    cell.textLabel.textColor = KTextGray_333;
    cell.textLabel.backgroundColor = [UIColor clearColor];
//    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    if ([cell.textLabel.text isEqualToString:self.navgationView.typeLabel.text]) {
        cell.textLabel.textColor = kMainYellow;
    }
    if (indexPath.row == self.typeTableList.count - 1){
        cell.separatorInset = UIEdgeInsetsMake(0,0,0,kScreenWidth);
    } else {
        cell.separatorInset = UIEdgeInsetsZero;// UIEdgeInsetsMake(0,15,0,0);
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == 0) {
//        self.classType = KfClassType_free;
//    }
//    if (indexPath.row == 1) {
//        self.classType = KfClassType_vip;
//    }
//    if (indexPath.row == 2) {
//        self.classType = KfClassType_pay;
//    }
    self.typeString = self.typeTableList[indexPath.row];
    [self hideTypeTable];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}


#pragma mark - event

- (void) showTypeTable {
    [self.view endEditing:YES];
    [self.view bringSubviewToFront:self.typeTableBackView];
    self.navgationView.typeIcon.image = [UIImage imageNamed:@"kungfu_up_black"];
    
    [self.typeTable reloadData];
    [UIView animateWithDuration:0.1 animations:^{
        self.typeTableBackView.frame = CGRectMake(self.typeTableBackView.left, self.typeTableBackView.top, self.typeTableBackView.width, 140);
//        self.typeTable.frame = CGRectMake(0, 5, self.typeTable.width, 130);
    }];
}


- (void) hideTypeTable {
    self.navgationView.typeIcon.image = [UIImage imageNamed:@"kungfu_down_black"];
    [UIView animateWithDuration:0.1 animations:^{
        self.typeTableBackView.frame = CGRectMake(self.typeTableBackView.left, self.typeTableBackView.top, self.typeTableBackView.width, 0);
//        self.typeTable.frame = CGRectMake(self.typeTable.left, self.typeTable.top, self.typeTable.width, 0);
    }];
}

- (UIView *)setViewWithOriginY:(CGFloat)riginY title:(NSString *)title textArr:(NSMutableArray *)textArr {
    UIView *view = [[UIView alloc] init];
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(SLChange(16), SLChange(15), SLChange(11), SLChange(16))];
    if (textArr.count == 0) {
         image.image = [UIImage imageNamed:@""];
    }else {
         image.image = [UIImage imageNamed:@"rot_search"];
    }
    
    [view addSubview:image];
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(SLChange(35), SLChange(15), kWidth - SLChange(95), SLChange(16))];
    titleL.text = title;
    titleL.font = kMediumFont(16);
    titleL.textColor = KTextGray_333;
    titleL.textAlignment = NSTextAlignmentLeft;
    [view addSubview:titleL];
    
    if ([title isEqualToString:SLLocalizedString(@"搜索历史")]) {
        image.frame = CGRectMake(11, SLChange(15), 17, 17);
         image.image = [UIImage imageNamed:@"history_search"];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kWidth - 45, 10, 28, 30);
        [btn setImage:[UIImage imageNamed:@"sort_recycle"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clearnSearchHistory:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
    }
    
    CGFloat y = SLChange(15) + SLChange(40);
    CGFloat letfWidth = SLChange(15);
    for (int i = 0; i < textArr.count; i++) {
        NSString *text = [self subModelTextString:textArr[i] len:6];
        CGFloat width = [self getWidthWithStr:text] + SLChange(35);
        if (letfWidth + width + SLChange(15) > kWidth) {
            if (y >= SLChange(130) && [title isEqualToString:SLLocalizedString(@"搜索历史")]) {
                [self removeTestDataWithTextArr:textArr index:i];
                break;
            }
            y += SLChange(40);
            letfWidth = SLChange(15);
        }
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(letfWidth, y, width, SLChange(35))];
        label.userInteractionEnabled = YES;
        label.font = [UIFont systemFontOfSize:15];
        label.text = text;
        label.backgroundColor = RGBA(243, 243, 243, 1);
        label.layer.cornerRadius = SLChange(35)/2;
        label.layer.borderWidth = 1;
        label.layer.borderColor = RGBA(243, 243, 243, 1).CGColor;
        label.layer.masksToBounds = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = KTextGray_333;
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTag:)]];
        [view addSubview:label];
        letfWidth += width + SLChange(10);
    }
    view.frame = CGRectMake(0, riginY, kWidth, y + SLChange(40));
    return view;
}

- (void)tapTag:(UITapGestureRecognizer *)tap{
    UILabel *label = (UILabel *)tap.view;

    // 跳转结果界面
    [self pushResultControllerWithSearchText:label.text];
}

- (void)clearnSearchHistory:(UIButton *)sender{
    
    [self.navgationView resignFirstResponder];
    
    [SMAlert setConfirmBtBackgroundColor:kMainYellow];
    [SMAlert setConfirmBtTitleColor:[UIColor whiteColor]];
    [SMAlert setCancleBtBackgroundColor:[UIColor whiteColor]];
    [SMAlert setCancleBtTitleColor:KTextGray_333];
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 100)];
    UILabel *title = [[UILabel alloc]initWithFrame:customView.bounds];
    [title setFont:kMediumFont(15)];
    [title setTextColor:[UIColor darkGrayColor]];
    title.text = SLLocalizedString(@"确定删除全部历史记录？");
    [title setTextAlignment:NSTextAlignmentCenter];
    [customView addSubview:title];
    [SMAlert showCustomView:customView stroke:YES confirmButton:[SMButton initWithTitle:SLLocalizedString(@"确定") clickAction:^{
        
        [self.searchHistoryView removeFromSuperview];
        self.searchHistoryView = [self setNoHistoryView];
        [self.historyArray removeAllObjects];
//        [NSKeyedArchiver archiveRootObject:self.historyArray toFile:KGoodsHistorySearchPath];
        
        NSString *userId = [SLAppInfoModel sharedInstance].id;
        [[ModelTool shareInstance]deleteTableName:@"searchHistory" where:[NSString stringWithFormat:@"userId = '%@' AND type = '%ld' ", userId, SearchHistoryCourseType]];
        
        
        [self.view addSubview:self.searchHistoryView];
       
    }] cancleButton:[SMButton initWithTitle:SLLocalizedString(@"取消") clickAction:nil]];
   
}

- (CGFloat)getWidthWithStr:(NSString *)text{
    CGFloat width = [text boundingRectWithSize:CGSizeMake(kWidth, SLChange(40)) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]} context:nil].size.width;
    if (width > 73.6) {
        width = 83;
        return width;
    }else {
        return width;
    }
    
}

- (void)removeTestDataWithTextArr:(NSMutableArray *)testArr index:(int)index
{
    NSRange range = {index, testArr.count - index - 1};
    [testArr removeObjectsInRange:range];
    [NSKeyedArchiver archiveRootObject:testArr toFile:KGoodsHistorySearchPath];
}

//-(NSString*)subTextString:(NSString*)str len:(NSInteger)len{
//    if(str.length<=len)return str;
//    int count=0;
//    NSMutableString *sb = [NSMutableString string];
//
//    for (int i=0; i<str.length; i++) {
//        NSRange range = NSMakeRange(i, 1) ;
//        NSString *aStr = [str substringWithRange:range];
//        count += [aStr lengthOfBytesUsingEncoding:NSUTF8StringEncoding]>1?2:1;
//        [sb appendString:aStr];
//        if(count >= len*2) {
//            return (i==str.length-1)?[sb copy]:[NSString stringWithFormat:@"%@...",[sb copy]];
//        }
//    }
//    return str;
//}

-(NSString*)subModelTextString:(SearchHistoryModel*)model len:(NSInteger)len{
    NSString *searchContent = model.searchContent;
    if (searchContent.length<=len) return searchContent;
    int count=0;
    NSMutableString *sb = [NSMutableString string];
    for (int i=0; i<searchContent.length; i++) {
        NSRange range = NSMakeRange(i, 1) ;
        NSString *aStr = [searchContent substringWithRange:range];
        count += [aStr lengthOfBytesUsingEncoding:NSUTF8StringEncoding]>1?2:1;
        [sb appendString:aStr];
        if(count >= len*2) {
            return (i==searchContent.length-1)?[sb copy]:[NSString stringWithFormat:@"%@...",[sb copy]];

        }
    }
    return searchContent;
}

- (UIView *)setNoHistoryView {
    UIView *historyView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navgationView.frame), kWidth, SLChange(80))];
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(11, SLChange(15), 17, 17)];
    image.image = [UIImage imageNamed:@"history_search"];
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(SLChange(35), SLChange(15), kWidth - SLChange(50), SLChange(16))];
    titleL.text = SLLocalizedString(@"搜索历史");
    titleL.font = kMediumFont(16);
    titleL.textColor = KTextGray_333;
    titleL.textAlignment = NSTextAlignmentLeft;
    
    UILabel *notextL = [[UILabel alloc] initWithFrame:CGRectMake(SLChange(35), CGRectGetMaxY(titleL.frame) + SLChange(20), SLChange(100), SLChange(20))];
    notextL.text = SLLocalizedString(@"无搜索历史");
    notextL.font = [UIFont systemFontOfSize:15];
    notextL.textColor = RGBA(113, 113, 113, 1);
    notextL.textAlignment = NSTextAlignmentLeft;
    [historyView addSubview:image];
    [historyView addSubview:titleL];
    [historyView addSubview:notextL];
    return historyView;
}


- (void) requestSearchWithText:(NSString *)text {
    if (text.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入搜索内容") view:self.view afterDelay:TipSeconds];
        return;
    }
//    if ([self.historyArray containsObject:text]) {
//        [self.historyArray removeObject:text];
//    }
//    [self.historyArray insertObject:text atIndex:0];
//    [NSKeyedArchiver archiveRootObject:self.historyArray toFile:KGoodsHistorySearchPath];
    
    NSString *userId = [SLAppInfoModel sharedInstance].id;
    
    SearchHistoryModel *historyModel = [[SearchHistoryModel alloc]init];
    historyModel.userId = userId;
    historyModel.searchContent = text;
    
    
    historyModel.type = [NSString stringWithFormat:@"%ld", SearchHistoryCourseType];;
    
    [historyModel addSearchWordWithDataArray:_historyArray];
         
    
    // 跳转结果界面
    [self pushResultControllerWithSearchText:text];
        
    [self.searchHistoryView removeFromSuperview];
    self.searchHistoryView = [self setViewWithOriginY:CGRectGetMaxY(self.navgationView.frame) title:SLLocalizedString(@"搜索历史") textArr:self.historyArray];
    [self.view addSubview:self.searchHistoryView];

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
    [self hideTypeTable];
}


- (void) pushResultControllerWithSearchText:(NSString *)text {
    if ([self.typeString isEqualToString:SLLocalizedString(@"教程")]) {
        
        KungfuClassListViewController *resultVC = [[KungfuClassListViewController alloc]init];
        resultVC.searchText = text;
        [self.navigationController pushViewController:resultVC animated:YES];
    }
    
    if ([self.typeString isEqualToString:SLLocalizedString(@"活动")]) {
        EnrollmentViewController *resultVC = [[EnrollmentViewController alloc]init];
        resultVC.searchText = text;
        [self.navigationController pushViewController:resultVC animated:YES];
    }
    
    if ([self.typeString isEqualToString:SLLocalizedString(@"机构")]) {
        KungfuInstitutionViewController *resultVC = [[KungfuInstitutionViewController alloc]init];
        resultVC.searchText = text;
        [self.navigationController pushViewController:resultVC animated:YES];
    }
}

#pragma mark - getter / setter
-(void)setTypeString:(NSString *)typeString {
    _typeString = typeString;
    self.navgationView.searchTF.placeholder = [NSString stringWithFormat:@"%@%@", SLLocalizedString(@"搜索"), typeString];
    self.navgationView.typeLabel.text = _typeString;
}

-(KfSearchBarView *)navgationView{
    WEAKSELF
    if (_navgationView == nil) {
        //状态栏高度
        CGFloat barHeight ;
        /** 判断版本
         获取状态栏高度
         */
        if (@available(iOS 13.0, *)) {
            barHeight = [[[[[UIApplication sharedApplication] keyWindow] windowScene] statusBarManager] statusBarFrame].size.height;
        } else {
            barHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
        }
     
        _navgationView = [[[NSBundle mainBundle] loadNibNamed:@"KfSearchBarView" owner:self options:nil] objectAtIndex:0];
        _navgationView.frame = CGRectMake(0, barHeight, ScreenWidth, 44);
        _navgationView.backHandle = ^{
            [weakSelf.view endEditing:YES];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        _navgationView.filterHandle = ^{
            if (weakSelf.typeTableBackView.height == 140) {
                [weakSelf hideTypeTable];
            } else {
                [weakSelf showTypeTable];
            }
        };
        _navgationView.searchHandle = ^(NSString * _Nonnull searchStr) {
            [weakSelf requestSearchWithText:searchStr];
        };
        _navgationView.tfBeginEditing = ^{
            [weakSelf hideTypeTable];
        };
    }
    return _navgationView;

}

- (UIView *)searchHistoryView
{
    if (!_searchHistoryView) {
        if (self.historyArray.count > 0) {
            self.searchHistoryView = [self setViewWithOriginY:CGRectGetMaxY(self.navgationView.frame) title:SLLocalizedString(@"搜索历史") textArr:self.historyArray];
        } else {
            self.searchHistoryView = [self setNoHistoryView];
        }
    }
    return _searchHistoryView;
}

-(NSMutableArray *)historyArray{
    if (!_historyArray) {
//           _historyArray = [NSKeyedUnarchiver unarchiveObjectWithFile:KGoodsHistorySearchPath];
        
        
        _historyArray = [[[ModelTool shareInstance] select:[SearchHistoryModel class] tableName:@"searchHistory" where:[NSString stringWithFormat:@"type = '%ld' AND userId = '%@' ORDER BY id DESC", SearchHistoryCourseType, [SLAppInfoModel sharedInstance].id]] mutableCopy];
        
           if (!_historyArray) {
               self.historyArray = [NSMutableArray array];
           }
       }
       return _historyArray;
}

- (UITableView *)typeTable {
    if (!_typeTable) {
        CGFloat bvW = CGRectGetWidth(self.typeTableBackView.frame);
        CGFloat tabW = 70;
        CGRect frame = CGRectMake((bvW - tabW)/2, 15, tabW, 130);
        _typeTable = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
        _typeTable.dataSource = self;
        _typeTable.delegate = self;
        _typeTable.showsVerticalScrollIndicator = NO;
        _typeTable.showsHorizontalScrollIndicator = NO;
//        _typeTable.backgroundColor = KTextGray_F3;
        _typeTable.backgroundColor = [UIColor clearColor];
        _typeTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _typeTable.separatorColor = KTextGray_E5;
        _typeTable.layer.cornerRadius = 4.0f;
        _typeTable.bounces = NO;
        _typeTable.userInteractionEnabled = YES;
//        UIImage *image = [UIImage imageNamed:@"upArrowRect"];
//        UIImage *newImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20) resizingMode:UIImageResizingModeStretch];
//        _typeTable.layer.contents = newImage;
        
        [_typeTable registerClass:[UITableViewCell class] forCellReuseIdentifier:typeCellId];
    }
    return _typeTable;
}

- (UIImageView *)typeTableBackView{
    if (!_typeTableBackView){
        _typeTableBackView = [[UIImageView alloc] initWithFrame:CGRectMake(73 ,self.navgationView.bottom - 10 , 93 , 0)];
        UIImage *image = [UIImage imageNamed:@"upArrowRect"];
        UIImage *newImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(40, 40, 40, 40) resizingMode:UIImageResizingModeStretch];
        _typeTableBackView.image = newImage;
        _typeTableBackView.clipsToBounds = YES;
        _typeTableBackView.userInteractionEnabled = YES;
        
    }
    return _typeTableBackView;
}
@end

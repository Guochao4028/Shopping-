//
//  KungfuViewController.m
//  Shaolin
//
//  Created by edz on 2020/3/4.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuViewController.h"
#import "XLPageViewController.h"
#import "KungfuHomeViewController.h"
#import "KungfuExaminationViewController.h"
#import "KungfuSubjectListViewController.h"
#import "KungfuSignViewController.h"
#import "KungfuInstitutionViewController.h"
#import "KungfuWebViewController.h"
#import "EnrollmentViewController.h"
#import "KungfuInfoViewController.h"

#import "KfNavigationSearchView.h"
#import "KungfuSearchViewController.h"
#import "ShoppingCartViewController.h"
#import "QRCodeViewController.h"
#import "DefinedHost.h"
#import "FieldModel.h"
#import "XLPagePictureAndTextTitleCell.h"
#import "UIButton+Block.h"

static NSString *const typeCellId = @"typeTableCell";

@interface KungfuViewController ()<XLPageViewControllerDelegate,XLPageViewControllerDataSrouce,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property(nonatomic,strong) XLPageViewController * pageViewController;
@property(nonatomic,strong)  XLPageViewControllerConfig * config;
@property (nonatomic, strong) NSArray <FieldModel *> *enabledTitles;
@property (nonatomic, strong) UIButton *typeButton;

@property (nonatomic, strong) UITableView * typeTable;
@property (nonatomic, strong) NSArray *typeTableList;
@property (nonatomic, strong) UIImageView *typeTableBackView;
@property (nonatomic, strong) UIView *bgAlphaView;

@property (nonatomic, copy) NSString * typeString;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) ShaolinSearchView *searchView;
@end

@implementation KungfuViewController

#pragma mark - life cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hideNavigationBarShadow];
    
    UIButton *leftButton = [self leftBtn];
    leftButton.titleLabel.font = kMediumFont(20);
    [leftButton setTitle:SLLocalizedString(@"功夫") forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor hexColor:@"333333"] forState:UIControlStateNormal];
    
    UIButton *rightButton = [self rightBtn];
    [rightButton setImage:[UIImage imageNamed:@"ScanQRCode"] forState:UIControlStateNormal];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kungFuPageChange:) name:KNotificationKungfuPageChange object:nil];
}

- (void) kungFuPageChange:(NSNotification *)noti {
    NSDictionary *dict = noti.object;
    
    NSInteger index = [dict[@"index"] integerValue];
    
    if (index >= self.enabledTitles.count) {
        return;
    }
    self.pageViewController.selectedIndex = index;
    UIViewController *vc = [self.pageViewController viewControllerForIndex:index];
    if ([vc isKindOfClass:[EnrollmentViewController class]]){
        NSString *typeName = [dict objectForKey:@"params"];
        [(EnrollmentViewController *)vc changeTableViewData:typeName];
    }
}

- (void)buildData {
    NSArray *array = @[
        @{@"name":SLLocalizedString(@"段品制"), @"image":@"kungfu_page_icon0"},
        @{@"name":SLLocalizedString(@"以武会友"), @"image":@"kungfu_page_icon1"},
        @{@"name":SLLocalizedString(@"习武"), @"image":@"kungfu_page_icon2"},
        @{@"name":SLLocalizedString(@"机构列表"), @"image":@"kungfu_page_icon3"},
        @{@"name":SLLocalizedString(@"段品制介绍"), @"image":@"kungfu_page_icon4"},
    ];
    self.enabledTitles = [FieldModel mj_objectArrayWithKeyValuesArray:array];
    self.config = [XLPageViewControllerConfig defaultConfig];
    self.config.titleViewStyle = XLPageTitleViewStylePictureAndText;
    self.pageViewController = [[XLPageViewController alloc] initWithConfig:self.config];
    self.pageViewController.view.frame = CGRectMake(0, 10, kWidth, kHeight - 10 - TabbarHeight);
    [self.pageViewController registerClass:[XLPagePictureAndTextTitleCell class] forTitleViewCellWithReuseIdentifier:@"XLPagePictureAndTextTitleCell"];
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    [self.pageViewController reloadData];
    self.pageViewController.selectedIndex = 0;
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    
    self.typeTableList = @[SLLocalizedString(@"教程"),SLLocalizedString(@"活动"),SLLocalizedString(@"机构")];
    self.typeString = SLLocalizedString(@"教程");
    
    [self.view addSubview:self.bgAlphaView];
    self.bgAlphaView.hidden = YES;
}

#pragma mark - event
- (void)rightAction{
    [self pushQRCodeViewController];
}

- (void)searchDidSelectHandle{
    KungfuSearchViewController * vc = [[KungfuSearchViewController alloc] init];
    vc.typeString = self.typeString;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
    [self hideTypeTable];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [self hideTypeTable];
}

- (void) showTypeTable {
    [self.view endEditing:YES];
    [self.typeTableBackView.superview bringSubviewToFront:self.typeTableBackView];
    self.bgAlphaView.hidden = NO;
    [self.typeTable reloadData];
    [UIView animateWithDuration:0.1 animations:^{
        self.typeTableBackView.frame = CGRectMake(self.typeTableBackView.left, self.typeTableBackView.top, self.typeTableBackView.width, 140);
//        self.typeTable.frame = CGRectMake(0, 5, self.typeTable.width, 130);
    }];
}


- (void) hideTypeTable {
    self.bgAlphaView.hidden = YES;
    [UIView animateWithDuration:0.1 animations:^{
        self.typeTableBackView.frame = CGRectMake(self.typeTableBackView.left, self.typeTableBackView.top, self.typeTableBackView.width, 0);
//        self.typeTable.frame = CGRectMake(self.typeTable.left, self.typeTable.top, self.typeTable.width, 0);
    }];
}

- (void)pushQRCodeViewController{
    WEAKSELF
    QRCodeViewController *vc = [[QRCodeViewController alloc] init];
    vc.hideNavigationBarView = YES;
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
        if ([flagStr isEqualToString:@"CheckInReturn"]){
            [self.navigationController popToViewController:self animated:YES];;
            return YES;
        }
        return NO;
    };
    webVC.leftActionBlock = ^BOOL{
        [self.navigationController popToViewController:self animated:YES];
        return YES;
    };
    [self.navigationController pushViewController:webVC animated:YES];
}
#pragma mark - XLPageViewDelegate

- (void)pageViewController:(XLPageViewController *)pageViewController didSelectedAtIndex:(NSInteger)index {
}

- (void)pageViewController:(XLPageViewController *)pageViewController refreshAtIndex:(NSInteger)index {
}

- (NSString *)pageViewController:(XLPageViewController *)pageViewController titleForIndex:(NSInteger)index {
    FieldModel *model = self.enabledTitles[index];
    return model.name;
}

- (NSInteger)pageViewControllerNumberOfPage {
    return self.enabledTitles.count;
}

- (UIViewController *)pageViewController:(XLPageViewController *)pageViewController viewControllerForIndex:(NSInteger)index {
   
    if (index == 0) {
        KungfuHomeViewController *vc = [KungfuHomeViewController new];
        return vc;
    }
//    else if(index == 1){
//        KungfuExaminationViewController *vc = [[KungfuExaminationViewController alloc] init];
//        return vc;
//    }
    else if(index == 1){
        EnrollmentViewController *vc = [EnrollmentViewController new];
        return vc;
    }
    else if(index == 2){
        KungfuSubjectListViewController *vc = [KungfuSubjectListViewController new];
        return vc;
    }
//    else if(index ==4){
//        KungfuSignViewController *vc = [[KungfuSignViewController alloc]init];
//        return vc;
//    }
    else if(index == 3){
        KungfuInstitutionViewController *vc = [KungfuInstitutionViewController new];
        return vc;
    }
    else {
        KungfuInfoViewController *vc = [KungfuInfoViewController new];
        return vc;
    }
}

- (__kindof XLPageTitleCell *)pageViewController:(XLPageViewController *)pageViewController titleViewCellForItemAtIndex:(NSInteger)index {
    XLPagePictureAndTextTitleCell *cell = [pageViewController dequeueReusableTitleViewCellWithIdentifier:NSStringFromClass([XLPagePictureAndTextTitleCell class]) forIndex:index];
    FieldModel *model = self.enabledTitles[index];
    cell.model = model;
    return cell;
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
    cell.textLabel.textColor = [UIColor hexColor:@"333333"];
    cell.textLabel.backgroundColor = [UIColor clearColor];
//    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    if ([cell.textLabel.text isEqualToString:self.typeString]) {
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

#pragma mark - getter
- (void)setSearchBarPlaceholder:(NSString *)placeholder {
    [super setSearchBarPlaceholder:placeholder];
    
    CGSize size = [placeholder boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kRegular(15)} context:nil].size;
    [self.searchBar setPositionAdjustment:UIOffsetMake((kScreenWidth - 98 - 20)/2 - 15 - size.width/2, 0) forSearchBarIcon:UISearchBarIconSearch];
}

- (UIView *)titleCenterView{
    if (!_searchView){
        _searchView = [super searchView];
        _searchView.placeholderAlignment = PlaceholderAlignmentLeft;
        
        UIView *searchLeftView = [[UIView alloc] init];
        [_searchView.leftView addSubview:searchLeftView];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorForHex:@"DCDCDC"];
        [searchLeftView addSubview:self.typeButton];
        [searchLeftView addSubview:line];
        
        [searchLeftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        [self.typeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(5);
            make.centerY.mas_equalTo(searchLeftView);
            make.size.mas_equalTo(CGSizeMake(60, 44));
        }];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.typeButton.mas_right).mas_offset(10);
            make.centerY.mas_equalTo(searchLeftView);
            make.size.mas_equalTo(CGSizeMake(0.5, 20));
            make.right.mas_equalTo(-10);
        }];
    }
    return _searchView;
}

- (UIButton *)typeButton{
    if (!_typeButton){
        _typeButton = [[UIButton alloc] init];
        [_typeButton setTitle:@"" forState:UIControlStateNormal];
        _typeButton.titleLabel.font = kRegular(13);
        [_typeButton setTitleColor:[UIColor colorForHex:@"333333"] forState:UIControlStateNormal];
        
        [_typeButton setImage:[UIImage imageNamed:@"kungfu_down_black"] forState:UIControlStateNormal];
        
        [_typeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
        [_typeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 45, 0, 0)];

        WEAKSELF
        [_typeButton handleControlEvent:UIControlEventTouchUpInside block:^(UIButton * _Nonnull button) {
            if (weakSelf.typeTableBackView.height == 140) {
                [weakSelf hideTypeTable];
            } else {
                [weakSelf showTypeTable];
            }
        }];
    }
    return _typeButton;
}

- (UIImageView *)typeTableBackView{
    if (!_typeTableBackView){
        CGRect frame = [self.typeButton convertRect:self.typeButton.frame toView:self.view];
        CGFloat x = CGRectGetMinX(frame) + (CGRectGetWidth(frame) - 93)/2;
        _typeTableBackView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0 , 93 , 0)];
        UIImage *image = [UIImage imageNamed:@"upArrowRect"];
        UIImage *newImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(40, 40, 40, 40) resizingMode:UIImageResizingModeStretch];
        _typeTableBackView.image = newImage;
        _typeTableBackView.clipsToBounds = YES;
        _typeTableBackView.userInteractionEnabled = YES;
        [self.view addSubview:self.typeTableBackView];
        [self.typeTableBackView addSubview:self.typeTable];
    }
    return _typeTableBackView;
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
//        _typeTable.backgroundColor = [UIColor colorForHex:@"F3F3F3"];
        _typeTable.backgroundColor = [UIColor clearColor];
        _typeTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _typeTable.separatorColor = [UIColor hexColor:@"e5e5e5"];
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

-(UIView *)bgAlphaView {
    if (!_bgAlphaView) {
        _bgAlphaView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _bgAlphaView.backgroundColor = [UIColor hexColor:@"ffffff" alpha:0];
    }
    return _bgAlphaView;
}

#pragma mark - setter
-(void)setTypeString:(NSString *)typeString {
    _typeString = typeString;
    NSString *placeholder = [NSString stringWithFormat:@"%@%@", SLLocalizedString(@"搜索"), typeString];
    [self.searchView setPlaceholder:placeholder];
    [self.typeButton setTitle:typeString forState:UIControlStateNormal];
}
@end

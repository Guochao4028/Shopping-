//
//  RootViewController.m
//  Shaolin
//
//  Created by edz on 2020/3/9.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RootViewController.h"

NSString *ViewWillAppearFinish = @"ViewWillAppearFinish";

@interface RootViewController () <UISearchBarDelegate, ShaolinSearchViewDelegate>
@property (nonatomic) UIBarStyle barStyle;

@property (nonatomic, strong) NSArray *leftButtons;
@property (nonatomic, strong) NSArray *rightButtons;
@property (nonatomic, strong) UIView *titleCenterView;

@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UILabel *titleLabe;

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) ShaolinSearchView *searchView;
@end

@implementation RootViewController

- (void)dealloc {
    NSLog(@"%@释放了",NSStringFromClass([self class]));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.titleCenterView){
        self.navigationItem.titleView = self.titleCenterView;
    } else if (self.titleLabe){
        self.navigationItem.titleView = self.titleLabe;
    }
    if (self.leftButtons.count){
        NSMutableArray<UIBarButtonItem *> *leftBarButtonItems = [@[] mutableCopy];
        for (int i = 0; i < self.leftButtons.count; i++){
            UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:self.leftButtons[i]];
            [leftBarButtonItems addObject:left];
        }
        self.navigationItem.leftBarButtonItems = leftBarButtonItems;
    } else if (self.leftBtn){
        UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:self.leftBtn];
        self.navigationItem.leftBarButtonItem = left;
    } else {
        [self.navigationItem setHidesBackButton:YES]; 
    }
    if (self.rightButtons.count){
        NSMutableArray<UIBarButtonItem *> *rightBarButtonItems = [@[] mutableCopy];
        for (int i = 0; i < self.rightButtons.count; i++){
            UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:self.rightButtons[i]];
            [rightBarButtonItems addObject:right];
        }
        self.navigationItem.rightBarButtonItems = rightBarButtonItems;
    } else if (self.rightBtn){
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
        self.navigationItem.rightBarButtonItem = right;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.hideNavigationBar || self.hideNavigationBarView){
        if (self.hideNavigationBar){
            [self.navigationController setNavigationBarHidden:YES animated:animated];
        } else {
            self.navigationController.navigationBar.hidden = YES;
        }
//        [self setStatusBarBlackTextColor];
//        [self hideNavigationBarShadow];
    } else {
        if (self.navigationController.navigationBar.hidden){
            self.navigationController.navigationBar.hidden = NO;
        }
        if (self.navigationController.navigationBarHidden){
            [self.navigationController setNavigationBarHidden:NO animated:animated];
        }
        [self setNavigationBarWhiteTintColor];
        [self showNavigationBarShadow];
        self.navigationController.navigationBar.translucent = NO;//导航栏颜色是否半透明
    }
    
    if (self.navigationBarStyle == NavigationBarYellowTintColorStyle){
        //[self setNavigationBarYellowTintColor];
    } else if (self.navigationBarStyle == NavigationBarClearTintColor_blackStyle){
        [self setNavigationBarClearTintColorBlackStyle];
    } else if (self.navigationBarStyle == NavigationBarClearTintColor_whiteStyle) {
        [self setNavigationBarClearTintColorWhiteStyle];
    }
    if (self.disableRightGesture){
        //停用右滑手势
        [self disableRightSlideGesture];
    } else {
        //开启右滑手势
        [self enableRightSlideGesture];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ViewWillAppearFinish object:self];
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightAction {
    
}

- (void)setStatusBarWhiteTextColor {
    self.barStyle = UIBarStyleBlack;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)setStatusBarBlackTextColor {
    self.barStyle = UIBarStyleDefault;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)setNavigationBarClearTintColorWhiteStyle{
    self.titleLabe.textColor = [UIColor whiteColor];
    [self.leftBtn setImage:[UIImage imageNamed:@"real_left"] forState:UIControlStateNormal];
    [self.leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [self hideNavigationBarShadow];
    
    self.navigationController.navigationBar.translucent = YES;
    [self setStatusBarWhiteTextColor];
}

- (void)setNavigationBarClearTintColorBlackStyle{
    self.titleLabe.textColor = KTextGray_333;
    [self.leftBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [self.leftBtn setTitleColor:KTextGray_333 forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:KTextGray_333 forState:UIControlStateNormal];

    [self hideNavigationBarShadow];
    
    self.navigationController.navigationBar.translucent = YES;
    [self setStatusBarBlackTextColor];
}

- (void)setNavigationBarWhiteTintColor {
    self.titleLabe.textColor = KTextGray_333;
    [self.leftBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [self.leftBtn setTitleColor:KTextGray_333 forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:KTextGray_333 forState:UIControlStateNormal];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    [self setStatusBarBlackTextColor];
}

- (void)setNavigationBarYellowTintColor {
    self.titleLabe.textColor = [UIColor whiteColor];
    [self.leftBtn setImage:[UIImage imageNamed:@"real_left"] forState:UIControlStateNormal];
    [self.leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    self.navigationController.navigationBar.barTintColor = kMainYellow;
    
    [self setStatusBarWhiteTextColor];
}


- (void)showNavigationBarShadow {
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;
}

- (void)hideNavigationBarShadow {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

- (void)disableRightSlideGesture{
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
}

- (void)enableRightSlideGesture{
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
}

- (UIWindow *)rootWindow {
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows) {
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelSupported = (window.windowLevel >= UIWindowLevelNormal && window.windowLevel <= UIWindowLevelNormal);
        if(windowOnMainScreen && windowIsVisible && windowLevelSupported) {
            return window;
        }
    }
    return nil;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.barStyle == UIBarStyleBlack){
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

#pragma mark - event
- (void)setSearchBarPlaceholder:(NSString *)placeholder{
    UITextField * searchField = [self.searchBar valueForKey:@"searchField"];
    searchField.clearButtonMode = UITextFieldViewModeNever;
    searchField.text = placeholder;
    searchField.textColor = [UIColor colorForHex:@"D1D3DB"];
    searchField.font = kRegular(15);
    CGSize size = [placeholder boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kRegular(15)} context:nil].size;
    [_searchBar setPositionAdjustment:UIOffsetMake((kScreenWidth - 98 - 20)/2 - 19 - size.width/2 - 10, 0) forSearchBarIcon:UISearchBarIconSearch];
}

- (void)searchDidSelectHandle {
}

#pragma mark - delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {

    [self searchDidSelectHandle];
    
    return NO;
}

- (void)shaolinSearchViewDidSelectHandle{
    [self searchDidSelectHandle];
}
#pragma mark - setter && getter
- (void)setHideNavigationBar:(BOOL)hideNavigationBar{
    _hideNavigationBar = hideNavigationBar;
    if (hideNavigationBar){
        _hideNavigationBarView = NO;
    }
}

- (void)setHideNavigationBarView:(BOOL)hideNavigationBarView{
    _hideNavigationBarView = hideNavigationBarView;
    if (hideNavigationBarView){
        _hideNavigationBar = NO;
    }
}

- (NSArray *)leftButtons {
    return @[];
}

- (NSArray *)rightButtons {
    return @[];
}

- (UIView *)titleCenterView {
    return nil;
}

- (UILabel *)titleLabe{
    if (!_titleLabe){
        _titleLabe = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
        _titleLabe.textAlignment = NSTextAlignmentCenter;
        _titleLabe.font = kMediumFont(17);
        _titleLabe.textColor = KTextGray_333;
    }
    return _titleLabe;
}

- (UIButton *)leftBtn{
    if (!_leftBtn){
        _leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 55, 40)];
        [_leftBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
        [_leftBtn setTitle:@"  " forState:UIControlStateNormal];
        _leftBtn.titleLabel.font = kMediumFont(15);
        
        _leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 45);
        [_leftBtn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

- (UIButton *)rightBtn{
    if (!_rightBtn){
        _rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 20)];
        _rightBtn.titleLabel.font = kRegular(15);
        [_rightBtn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

-(UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectZero];
        _searchBar.barStyle = UIBarStyleDefault;
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        [_searchBar setImage:[UIImage imageNamed:@"new_search"]
                          forSearchBarIcon:UISearchBarIconSearch
                                     state:UIControlStateNormal];
        _searchBar.delegate = self;
        [self setSearchBarPlaceholder:@"搜索"];
    }
    return _searchBar;
}

- (ShaolinSearchView *)searchView{
    if (!_searchView){
        _searchView = [[ShaolinSearchView alloc] init];
        _searchView.delegate = self;
    }
    return _searchView;
}
@end

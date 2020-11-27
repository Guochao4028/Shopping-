//
//  RootViewController.h
//  Shaolin
//
//  Created by edz on 2020/3/9.
//  Copyright © 2020 syqaxldy. All rights reserved.
//
/*
 *  所有ViewController都应该继承自RootViewController；
 *  RootViewController在viewWillAppear方法中会将导航栏重置；
 *  各个子类对导航栏的操作应该放在子类的viewWillAppear方法中，不要忘记调用 [super viewWillAppear:animated]；
 *  注意调用setNavigationBarTintColor相关方法时状态栏颜色的改变；
 *  隐藏导航栏时状态栏文字颜色默认设为黑色
 */
#import <UIKit/UIKit.h>
#import "ShaolinSearchView.h"

typedef NS_ENUM(NSInteger, NavigationBarStyle) {
    /// 背景色为hexColor:@"FFFFFF" (默认状态栏颜色为黑色)
    NavigationBarWhiteTintColorStyle = 0,
    /// 背景色为hexColor:@"8E2B25" (默认状态栏颜色为白色)
    NavigationBarYellowTintColorStyle,
    /// 背景色为透明色 (默认状态栏颜色为黑色)
    NavigationBarClearTintColor_blackStyle,
    /// 背景色为透明色 (默认状态栏颜色为白色)
    NavigationBarClearTintColor_whiteStyle,
};

@interface RootViewController : UIViewController

/*!
 *  将hideNavigationBar设为YES即可隐藏导航栏；
 *  内部设置self.navigationController.navigationBarHidden，注意与hideNavigationBarView的区别。
 */
@property (nonatomic) BOOL hideNavigationBar;
/*!
 * 将hideNavigationBar设为YES即可隐藏导航栏；
 * 内部设置self.navigationController.navigationBar.hidden，注意与hideNavigationBar的区别。
 */
@property (nonatomic) BOOL hideNavigationBarView;

/*!
 * 设置导航栏样式
 * 默认值为NavigationBarWhiteTintColor
 */
@property (nonatomic) NavigationBarStyle navigationBarStyle;

/// 停用右滑手势
@property (nonatomic) BOOL disableRightGesture;

- (NSArray<UIButton *> *)leftButtons;
- (NSArray<UIButton *> *)rightButtons;
- (UIView *)titleCenterView;

- (UIButton *)leftBtn;
- (UIButton *)rightBtn;
- (UILabel *)titleLabe;

- (UISearchBar *)searchBar;
- (ShaolinSearchView *)searchView;

- (void)searchDidSelectHandle;

- (void)setSearchBarPlaceholder:(NSString *)placeholder;

- (void)leftAction;
- (void)rightAction;

/// hexColor:@"8E2B25" (默认状态栏颜色为白色)
- (void)setNavigationBarYellowTintColor;
/// hexColor:@"FFFFFF" (默认状态栏颜色为黑色)
- (void)setNavigationBarWhiteTintColor;
/// 导航栏设置为透明色 (默认状态栏颜色为黑色)
- (void)setNavigationBarClearTintColorBlackStyle;
/// 导航栏设置为透明色 (默认状态栏颜色为白色)
- (void)setNavigationBarClearTintColorWhiteStyle;

/// 设置状态栏文字颜色为白色(默认为黑色)
- (void)setStatusBarWhiteTextColor;
/// 设置状态栏文字颜色为黑色(默认为黑色)
- (void)setStatusBarBlackTextColor;

/// 显示导航栏线(默认显示导航栏线)
- (void)showNavigationBarShadow;
/// 隐藏导航栏线(默认显示导航栏线)
- (void)hideNavigationBarShadow;

- (UIWindow *)rootWindow;

@end



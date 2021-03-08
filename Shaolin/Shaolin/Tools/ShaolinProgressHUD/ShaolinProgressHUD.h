//
//  ShaolinProgressHUD.h
//  Shaolin
//
//  Created by 王精明 on 2020/6/22.
//  Copyright © 2020 syqaxldy. All rights reserved.
//
//  少林全局通用的loding HUD，是对MBProgressHUD的一层封装
//  第一版 是小和尚在出掌
//  第二版 去掉动图，只有一个旋转菊花

/*
    推荐使用 single开头的方法，因为其会保证屏幕上同时只有一个hud（如果有特殊需求请使用非single开头的方法）
    使用方法释例
    释例1:耗时操作结束，后无论成功失败都显示提示框。
    //因其内部机制，这里可以省略[ShaolinProgressHUD hideSingleProgressHUD]调用
    [ShaolinProgressHUD defaultSingleLoadingWithText:SLLocalizedString(@"上传中")];
    [[DownloadManager sharedInstance] postSuccess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        //上传完成后显示提示框，设置定时隐藏afterDelay:TipSeconds
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"上传成功") view:self.view afterDelay:TipSeconds];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        //上传完失败后显示提示框，设置定时隐藏afterDelay:TipSeconds
        [ShaolinProgressHUD singleTextHud:kNetErrorPrompt view:self.view afterDelay:TipSeconds];
    }]];
    释例2:耗时操作结束，没有提示框
    //需要手动调用[ShaolinProgressHUD hideSingleProgressHUD];
    [ShaolinProgressHUD defaultSingleLoadingWithText:SLLocalizedString(@"加载中")];
    [[DownloadManager sharedInstance] postSuccess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [ShaolinProgressHUD hideSingleProgressHUD];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [ShaolinProgressHUD hideSingleProgressHUD];
    }]];
    释例3:一组耗时任务的情况
    //这里使用非single开头的方法来创建hud，可以在任务中继续使用 singleTextHud:view:afterDelay: 创建提示框，从而不会影响到hud
    dispatch_group_t group = dispatch_group_create();
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:@""];
    for (int i = 0; i < 10; i++ ){
        dispatch_group_enter(group);//手动在group中加入一个任务
         [[DownloadManager sharedInstance] postSuccess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            dispatch_group_leave(group);//手动在group移除一个任务
         } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            dispatch_group_leave(group);//手动在group移除一个任务
            //这里依旧可以使用singleTextHud显示提示框 而不会隐藏 hud
            [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"失败") view:self.view afterDelay:TipSeconds];
         }]];
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [hud hideAnimated:YES];
    });
 */
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*! 便于维护的统一样式loading
 *  如果以后需要全局修改loading样式，可以通过修改defaultLoadingWithText:view:afterDelay:和defaultSingleLoadingWithTextview:afterDelay:来实现
 */
@interface ShaolinProgressHUD : UIView
#pragma mark - loading 便利方法1 可创建多个
/*!
 *  默认hud样式。
 *  有动图，有一个铺满window的黑色背景 hud，
 *  通过下列方法创建的HUD由用户负责隐藏。
 *  注：用户通过调用hud的实例方法来将其隐藏（ [hud hideAnimated:] ）
 */
+ (MBProgressHUD *)defaultLoadingWithText:(nullable NSString *)text;
+ (MBProgressHUD *)defaultLoadingWithText:(nullable NSString *)text view:(nullable UIView *)view;
#pragma mark - loading 便利方法2 全局唯一
/*! 默认loading样式。
 *  有动图 有一个铺满window的黑色背景 hud
 *  通过下列方法创建的HUD需要调用 [ShaolinProgressHUD hideSingleProgressHUD] 来隐藏。
 *  ShaolinProgressHUD会始终保证屏幕上只有一个HUD，通过非single开头的方法创建的HUD不受约束
 */
+ (void)defaultSingleLoadingWithText:(nullable NSString *)text;
+ (void)defaultSingleLoadingWithText:(nullable NSString *)text view:(nullable UIView *)view;

#pragma mark - textHud 便利方法 全局唯一
/*! 纯文字 hud。
 *  显示在window上，TipSeconds秒后自动隐藏(TipSeconds 是一个全局宏)
 */
+ (void)singleTextAutoHideHud:(nullable NSString *)text;

#pragma mark - 优先使用上面的方法
/*! 纯文字 hud，需要手动调用 MBProgressHUD的实例方法 hideAnimated: 来隐藏 hud*/
+ (MBProgressHUD *)textHud:(nullable NSString *)text;
/*! 纯文字 hud，需要手动调用 MBProgressHUD的实例方法 hideAnimated: 来隐藏 hud*/
+ (MBProgressHUD *)textHud:(nullable NSString *)text view:(nullable UIView *)view;
/*! 纯文字 hud，delay秒后自动隐藏*/
+ (MBProgressHUD *)textHud:(nullable NSString *)text view:(nullable UIView *)view afterDelay:(NSTimeInterval)delay isFill:(BOOL)isFill;

/*! 纯文字 hud，需要手动调用 hideSingleProgressHUD 来隐藏 hud*/
+ (void)singleTextHud:(nullable NSString *)text;
/*! 纯文字 hud，需要手动调用 hideSingleProgressHUD 来隐藏 hud*/
+ (void)singleTextHud:(nullable NSString *)text view:(nullable UIView *)view;
/*! 纯文字 hud，delay秒后自动隐藏*/
+ (void)singleTextHud:(nullable NSString *)text view:(nullable UIView *)view afterDelay:(NSTimeInterval)delay;
/*! 纯文字 hud，delay秒后自动隐藏，isFillHud是否铺满全屏*/
+ (void)singleTextHud:(nullable NSString *)text view:(nullable UIView *)view afterDelay:(NSTimeInterval)delay isFill:(BOOL)isFill;
/*! 关闭由single开头的方法创建的hud */
+ (void)hideSingleProgressHUD;

/*! 获取最前端的window*/
+ (UIWindow *)frontWindow;
@end

NS_ASSUME_NONNULL_END

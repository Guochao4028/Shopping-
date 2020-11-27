//
//  ShaolinProgressHUD.m
//  Shaolin
//
//  Created by 王精明 on 2020/6/22.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ShaolinProgressHUD.h"
#import "UIImage+GIF.h"
#import <vector>


std::vector<__weak MBProgressHUD *> weakProgressHUDVector;
static NSString * const gifName = @"default_loding";

//#define UseGif

@interface LodingView : UIImageView
@end
@implementation LodingView
- (CGSize)intrinsicContentSize {
    CGFloat contentViewH = 40;
    CGFloat contentViewW = 40;
    return CGSizeMake(contentViewW, contentViewH);
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSData *gifData = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:gifName ofType:@"gif"]];
        UIImage *image = [UIImage sd_imageWithGIFData:gifData];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.image = image;
    }
    return self;
}

@end

@implementation ShaolinProgressHUD
+ (UIWindow *)frontWindow {
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

+ (MBProgressHUD *)createNormalHudWithView:(UIView *)view {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    // 设置背景颜色
    hud.bezelView.color = [UIColor colorWithWhite:0.f alpha:0.6f];
    return hud;
}

+ (MBProgressHUD *)createFillHudWithView:(UIView *)view{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithFrame:view.bounds];
    hud.removeFromSuperViewOnHide = YES;
    [view addSubview:hud];
    [hud showAnimated:YES];
    hud.backgroundView.backgroundColor = [UIColor whiteColor];
    // 设置背景颜色
    hud.bezelView.color = [UIColor clearColor];
    return hud;
}

+ (MBProgressHUD *)createHudWithView:(UIView *)view isFillHud:(BOOL)isFillHud{
    if (!view) view = [ShaolinProgressHUD frontWindow];
    
    MBProgressHUD *hud;
    if (isFillHud){
        hud = [self createFillHudWithView:view];
    } else {
        hud = [self createNormalHudWithView:view];
    }
    [ShaolinProgressHUD checkFrontView:view];
#ifdef UseGif
    //customView默认使用图片的大小，而且无法通过设置frame来修改
    NSData *gifData = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:gifName ofType:@"gif"]];
    UIImage *image = [UIImage sd_imageWithGIFData:gifData];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    
    //如果对gif的大小有要求，可以使用LodingView，在intrinsicContentSize方法中返回需求的大小
//    LodingView *lodingView = [LodingView new];
//    hud.customView = lodingView;
    hud.mode = MBProgressHUDModeCustomView;
#endif
    hud.square = YES;
    // 设置字体颜色
    hud.contentColor = [UIColor colorWithWhite:1.f alpha:1.f];
    // 设置模式
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    
    hud.label.font = kMediumFont(15);
    hud.label.textColor = KTextGray_333;
    hud.label.numberOfLines = 0;
    
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}

+ (void)checkFrontView:(UIView *)view{
    for (UIView *v in view.subviews){
        if ([v isKindOfClass:NSClassFromString(@"ShaolinVersionUpdateView")]){
            [view bringSubviewToFront:v];
        }
    }
}
#pragma mark - 默认样式
/*! 默认hud样式。有动图，有一个铺满window的白色背景，需要手动调用 MBProgressHUD的实例方法 hideAnimated: 来隐藏 hud */
+ (MBProgressHUD *)defaultLoadingWithText:(nullable NSString *)text {
    return [ShaolinProgressHUD defaultLoadingWithText:text view:nil];
}

+ (MBProgressHUD *)defaultLoadingWithText:(nullable NSString *)text view:(nullable UIView *)view {
   return [ShaolinProgressHUD defaultLoadingWithText:text view:view afterDelay:-1];
}

+ (MBProgressHUD *)defaultLoadingWithText:(nullable NSString *)text view:(nullable UIView *)view afterDelay:(NSTimeInterval)delay {
    return [ShaolinProgressHUD fillLoadingWithText:text view:view afterDelay:delay];
}

/*! 默认loading样式 有动图 有一个铺满window的灰色背景 hud，需要手动调用 hideSingleProgressHUD 来隐藏 hud*/
+ (void)defaultSingleLoadingWithText:(nullable NSString *)text {
    [ShaolinProgressHUD defaultSingleLoadingWithText:text view:nil];
}

+ (void)defaultSingleLoadingWithText:(nullable NSString *)text view:(nullable UIView *)view {
    [ShaolinProgressHUD defaultSingleLoadingWithText:text view:view afterDelay:-1];
}

+ (void)defaultSingleLoadingWithText:(nullable NSString *)text view:(nullable UIView *)view afterDelay:(NSTimeInterval)delay {
    [ShaolinProgressHUD singleFillLoadingWithText:text view:view afterDelay:delay];
}

+ (void)singleTextAutoHideHud:(nullable NSString *)text {
    [ShaolinProgressHUD singleTextHud:text view:nil afterDelay:TipSeconds];
}

#pragma mark - 由用户维护所有通过下列方法创建的HUD的生命周期
+ (MBProgressHUD *)loadingWithText:(NSString *)text {
    return [ShaolinProgressHUD loadingWithText:text view:nil];
}

+ (MBProgressHUD *)loadingWithText:(NSString *)text view:(UIView *)view {
    return [ShaolinProgressHUD loadingWithText:text view:view afterDelay:-1];
}

+ (MBProgressHUD *)loadingWithText:(NSString *)text view:(UIView *)view afterDelay:(NSTimeInterval)delay{
    auto restyleHud = [&](){
        MBProgressHUD *hud = [ShaolinProgressHUD createHudWithView:view isFillHud:NO];
        // 设置背景颜色
//        hud.bezelView.color = [UIColor colorWithWhite:0.f alpha:0.6f];
        hud.label.text = text;
        if (delay > 0){
            [hud hideAnimated:YES afterDelay:delay];
        }
        return hud;
    };
    __block MBProgressHUD *hud;
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {
        hud = restyleHud();
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            hud = restyleHud();
        });
    }
    return hud;
}

+ (MBProgressHUD *)fillLoadingWithText:(NSString *)text {
    return [ShaolinProgressHUD fillLoadingWithText:text view:nil];
}

+ (MBProgressHUD *)fillLoadingWithText:(NSString *)text view:(nullable UIView *)view {
    return [ShaolinProgressHUD fillLoadingWithText:text view:view afterDelay:-1];
}

+ (MBProgressHUD *)fillLoadingWithText:(nullable NSString *)text view:(nullable UIView *)view afterDelay:(NSTimeInterval)delay {
    auto restyleHud = [&](){
        MBProgressHUD *hud = [ShaolinProgressHUD createHudWithView:view isFillHud:YES];
        hud.backgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
        hud.label.text = text;
        hud.label.textColor = [UIColor whiteColor];
        if (delay > 0){
            [hud hideAnimated:YES afterDelay:delay];
        }
        return hud;
    };
    __block MBProgressHUD *hud;
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {
        hud = restyleHud();
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            hud = restyleHud();
        });
    }
    return hud;
}

+ (MBProgressHUD *)textHud:(nullable NSString *)text {
    return [ShaolinProgressHUD textHud:text view:nil];
}

+ (MBProgressHUD *)textHud:(NSString *)text view:(UIView *)view {
    return [ShaolinProgressHUD textHud:text view:view afterDelay:-1];
}

+ (MBProgressHUD *)textHud:(NSString *)text view:(UIView *)view afterDelay:(NSTimeInterval)delay {
    auto restyleHud = [&](){
        MBProgressHUD *hud = [ShaolinProgressHUD loadingWithText:text view:view afterDelay:delay];
        hud.mode = MBProgressHUDModeText;
        hud.square = NO;
        hud.bezelView.color = [UIColor colorWithWhite:0.f alpha:0.6f];
        hud.backgroundView.backgroundColor = [UIColor clearColor];
        return hud;
    };
    __block MBProgressHUD *hud;
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {
        hud = restyleHud();
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            hud = restyleHud();
        });
    }
    return hud;
}

#pragma mark - 通过下列方法创建的HUD ShaolinProgressHUD会保证其全局唯一性(始终只有一个HUD显示在界面上)
+ (void)singleLoadingWithText:(NSString *)text {
    [ShaolinProgressHUD singleLoadingWithText:text view:nil];
}

+ (void)singleLoadingWithText:(NSString *)text view:(UIView *)view{
    [ShaolinProgressHUD loadingWithText:text view:view afterDelay:-1];
}

+ (void)singleLoadingWithText:(NSString *)text view:(UIView *)view afterDelay:(NSTimeInterval)delay{
    MBProgressHUD *hud = [ShaolinProgressHUD loadingWithText:text view:view afterDelay:delay];
    [ShaolinProgressHUD setWeakHud:hud];
}

+ (void)singleFillLoadingWithText:(NSString *)text{
    [ShaolinProgressHUD singleFillLoadingWithText:text view:nil];
}

+ (void)singleFillLoadingWithText:(NSString *)text view:(UIView *)view{
    [ShaolinProgressHUD fillLoadingWithText:text view:view afterDelay:-1];
}

+ (void)singleFillLoadingWithText:(NSString *)text view:(UIView *)view afterDelay:(NSTimeInterval)delay{
    MBProgressHUD *hud = [ShaolinProgressHUD fillLoadingWithText:text view:view afterDelay:delay];
    [ShaolinProgressHUD setWeakHud:hud];
}

+ (void)singleTextHud:(NSString *)text {
    [ShaolinProgressHUD singleTextHud:text view:nil];
}

+ (void)singleTextHud:(NSString *)text view:(UIView *)view {
    [ShaolinProgressHUD singleTextHud:text view:view afterDelay:-1];
}

+ (void)singleTextHud:(NSString *)text view:(UIView *)view afterDelay:(NSTimeInterval)delay {
    MBProgressHUD *hud = [ShaolinProgressHUD textHud:text view:view afterDelay:delay];
    [ShaolinProgressHUD setWeakHud:hud];
}

+ (void)setWeakHud:(MBProgressHUD *)hud{
    [ShaolinProgressHUD hideSingleProgressHUD];
    weakProgressHUDVector.push_back(hud);
}

+ (void)hideSingleProgressHUD{
    auto hideHud = [](){
        for (auto hud : weakProgressHUDVector){
            [hud hideAnimated:YES];
        }
    };
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {
        hideHud();
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            hideHud();
        });
    }
    weakProgressHUDVector.clear();
}
@end


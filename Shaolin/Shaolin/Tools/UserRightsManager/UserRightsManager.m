//
//  UserRightsManager.m
//  Shaolin
//
//  Created by 王精明 on 2020/10/12.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "UserRightsManager.h"
#import "SMAlert.h"

@implementation UserRightsManager

+ (void)getUserCameraRights:(BOOL)showAlert success:(void (^)(UserRightsEnum userRightsEnum))success {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted) {// 受系统权限，用户无法取得该权限
        if (showAlert){
            [SMAlert showAlertWithTitle:SLLocalizedString(@"客户端无权访问该媒体类型的硬件") message:SLLocalizedString(@"这可能是由于诸如家长控制之类的活动限制所致") confirmButtonTitle:SLLocalizedString(@"确定") success:^{
                if (success) success(UserRightsManager_failed);
            }];
        } else {
            if (success) success(UserRightsManager_failed);
        }
    } else if (authStatus == AVAuthorizationStatusDenied) {// 用户明确拒绝给予权限
        if (showAlert){
            [SMAlert showAlertWithTitle:SLLocalizedString(@"温馨提示") message:SLLocalizedString(@"请在设置中允许访问相机功能") confirmButtonTitle:SLLocalizedString(@"确定") cancelButtonTitle:SLLocalizedString(@"取消") success:^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
            } cancel:^{
                if (success) success(UserRightsManager_failed);
            }];
        } else {
            if (success) success(UserRightsManager_failed);
        }
    }else if (authStatus == AVAuthorizationStatusAuthorized) {// 用户已授权
        if (success) success(UserRightsManager_success);
    }else if (authStatus == AVAuthorizationStatusNotDetermined) {// 用户还未进行选择
        //弹框让用户进行选择
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_queue_t mainQueue = dispatch_get_main_queue();
            dispatch_async(mainQueue,^{
                if (granted) {
                    if (success) success(UserRightsManager_success);
                } else {
                    if (success) success(UserRightsManager_failed);
                }
            });
        }];
    }
}

+ (void)getUserPhotoRights:(BOOL)showAlert success:(void (^)(UserRightsEnum userRightsEnum))success{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted) {// 受系统权限，用户无法取得该权限
        if (showAlert){
            [SMAlert showAlertWithTitle:SLLocalizedString(@"客户端无权访问该媒体类型的硬件") message:SLLocalizedString(@"这可能是由于诸如家长控制之类的活动限制所致") confirmButtonTitle:SLLocalizedString(@"确定") success:^{
                if (success) success(UserRightsManager_failed);
            }];
        } else {
            if (success) success(UserRightsManager_failed);
        }
    } else if (status == PHAuthorizationStatusDenied) {// 用户明确拒绝给予权限
        if (showAlert){
            [SMAlert showAlertWithTitle:SLLocalizedString(@"温馨提示") message:SLLocalizedString(@"请在设置中允许访问相册功能") confirmButtonTitle:SLLocalizedString(@"确定") cancelButtonTitle:SLLocalizedString(@"取消") success:^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
            } cancel:^{
                if (success) success(UserRightsManager_failed);
            }];
        } else {
            if (success) success(UserRightsManager_failed);
        }
    } else if (status == PHAuthorizationStatusAuthorized) {// 用户已授权
        if (success) success(UserRightsManager_success);
    } else if (status == PHAuthorizationStatusNotDetermined) {// 用户还未进行选择
        // 弹框请求用户授权
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            //该block块可能存在于任意线程，所以回掉方法需要在主线程执行
            dispatch_queue_t mainQueue = dispatch_get_main_queue();
            dispatch_async(mainQueue,^{
                if (status == PHAuthorizationStatusAuthorized) { // 用户点击了好
                    if (success) success(UserRightsManager_success);
                } else {
                    if (success) success(UserRightsManager_failed);
                }
            });
        }];
    }
}
@end

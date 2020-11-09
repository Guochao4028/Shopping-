//
//  UserRightsManager.h
//  Shaolin
//
//  Created by 王精明 on 2020/10/12.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, UserRightsEnum) {
    UserRightsManager_unknown,//用户还没有做出选择
    UserRightsManager_success,//用户确认授权
    UserRightsManager_failed,//用户确认不授权
};

@interface UserRightsManager : NSObject
///申请获取用户相机权限
+ (void)getUserCameraRights:(BOOL)showAlert success:(void (^)(UserRightsEnum userRightsEnum))success;
///申请获取用户相册权限
+ (void)getUserPhotoRights:(BOOL)showAlert success:(void (^)(UserRightsEnum userRightsEnum))success;
@end

NS_ASSUME_NONNULL_END

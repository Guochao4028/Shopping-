//
//  LoginViewController.h
//  Shaolin
//
//  Created by edz on 2020/3/17.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginViewController : UIViewController
@property(nonatomic,strong) NSString *typeStr;
/**
上传隐私协议授权状态
@param isAgree 是否同意（⽤用户授权后的结果）
*/
+ (void)uploadPrivacyPermissionStatus:(BOOL)isAgree
onResult:(void (^_Nullable)(BOOL success))handler;
@end

NS_ASSUME_NONNULL_END

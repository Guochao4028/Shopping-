//
//  ThirdpartyBindingViewController.h
//  Shaolin
//
//  Created by 王精明 on 2020/7/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//  我的-个人信息管理-三方登录

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ThirdpartyBindingViewController : RootViewController
@property (nonatomic, copy) void(^outLoginBlock)(void);
@end

NS_ASSUME_NONNULL_END

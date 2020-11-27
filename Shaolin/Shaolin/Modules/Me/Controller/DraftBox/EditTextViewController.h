//
//  EditTextViewController.h
//  Shaolin
//
//  Created by edz on 2020/4/2.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RootViewController.h"
#import "MePostManagerModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface EditTextViewController : RootViewController
@property(nonatomic,strong) MePostManagerModel *model;
@property(nonatomic,strong) NSString *titleStr;
@property(nonatomic,strong) NSString *introductStr;
@property(nonatomic,strong) NSString *contentStr;
@property(nonatomic,strong) NSString *pushStr;//区别发文管理页面跳转过来还是草稿箱跳转

@end

NS_ASSUME_NONNULL_END

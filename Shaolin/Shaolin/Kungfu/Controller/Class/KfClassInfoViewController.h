//
//  KfClassInfoViewController.h
//  Shaolin
//
//  Created by ws on 2020/5/19.
//  Copyright © 2020 syqaxldy. All rights reserved.
//
//  课程信息 - 从课程详情点击课程介绍进入

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface KfClassInfoViewController : UIViewController

@property(nonatomic, copy)NSString *classContentStr;

@property(nonatomic, copy)NSString *classNameStr;

@property (nonatomic, copy) void(^ shutDownBlock)(void);


@end



NS_ASSUME_NONNULL_END

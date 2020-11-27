//
//  KungfuApplyCheckListViewController.h
//  Shaolin
//
//  Created by ws on 2020/5/25.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface KungfuApplyCheckListViewController : RootViewController
 
@property (nonatomic, copy) NSString * searchText;


/**
 导航是否是红色
 常规时不设置 只有从我的进来时 设置为yes
 */
@property(nonatomic, assign)BOOL isNavBarRed;

@end

NS_ASSUME_NONNULL_END

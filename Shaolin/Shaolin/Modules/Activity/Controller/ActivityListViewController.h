//
//  ActivityListViewController.h
//  Shaolin
//
//  Created by edz on 2020/4/7.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ActivityListViewController : RootViewController
@property(nonatomic,assign) NSInteger  selectPage;
@property(nonatomic,assign) NSInteger identifier;

- (void)refreshAndScrollToTop;
@end

NS_ASSUME_NONNULL_END

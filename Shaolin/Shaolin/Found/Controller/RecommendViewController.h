//
//  RecommendViewController.h
//  Shaolin
//
//  Created by edz on 2020/3/5.
//  Copyright © 2020 syqaxldy. All rights reserved.
//  发现 - title下的展示内容

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecommendViewController : RootViewController
@property(nonatomic,assign) NSInteger  selectPage;
@property(nonatomic,assign) NSInteger identifier;
- (void)refreshAndScrollToTop;
@end

NS_ASSUME_NONNULL_END

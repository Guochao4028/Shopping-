//
//  SLSearchResultViewController.h
//  Shaolin
//
//  Created by edz on 2020/3/23.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SLSearchResultViewController : RootViewController
@property (nonatomic, copy) NSString *searchStr;
@property (nonatomic, strong) NSMutableArray *hotArray;
@property (nonatomic, strong) NSMutableArray *historyArray;
@property(nonatomic,copy) NSString *tabbarStr;
@property(nonatomic,assign) BOOL isRite; //是否是法会
@end

NS_ASSUME_NONNULL_END

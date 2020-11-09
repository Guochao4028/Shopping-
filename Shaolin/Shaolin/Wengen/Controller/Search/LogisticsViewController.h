//
//  LogisticsViewController.h
//  Shaolin
//
//  Created by 王精明 on 2020/6/18.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LogisticsViewController : RootViewController
@property (nonatomic, copy) void (^ selectedLogisticsName)(NSString *name);
@end

NS_ASSUME_NONNULL_END

//
//  StoreDetailsViewController.h
//  Shaolin
//
//  Created by 郭超 on 2020/4/14.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface StoreDetailsViewController : RootViewController

@property(nonatomic, copy)NSString *storeId;

@property(nonatomic, assign)BOOL isCollect;

@end

NS_ASSUME_NONNULL_END

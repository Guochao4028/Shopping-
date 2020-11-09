//
//  StoreInfoViewController.h
//  Shaolin
//
//  Created by edz on 2020/4/7.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class StoreInformationModel;
@interface StoreInfoViewController : RootViewController
@property(nonatomic,strong) NSString *stepStr;
@property(nonatomic,strong) StoreInformationModel *model;
@end

NS_ASSUME_NONNULL_END

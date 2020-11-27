//
//  TaxInformationVc.h
//  Shaolin
//
//  Created by syqaxldy on 2020/4/12.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class StoreInformationModel;
@interface TaxInformationVc : RootViewController
@property(nonatomic,strong) StoreInformationModel *model;
@property (nonatomic,copy) void (^TaxInformationBlock)(NSString *stepStr);
@end

NS_ASSUME_NONNULL_END

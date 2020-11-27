//
//  OrganizationViewController.h
//  Shaolin
//
//  Created by EDZ on 2020/5/14.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class StoreInformationModel;
@interface OrganizationViewController : RootViewController
@property(nonatomic,strong) StoreInformationModel *model;
@property (nonatomic,copy) void (^InstitutionBlock)(NSString *stepStr, NSString *code);

@end

NS_ASSUME_NONNULL_END

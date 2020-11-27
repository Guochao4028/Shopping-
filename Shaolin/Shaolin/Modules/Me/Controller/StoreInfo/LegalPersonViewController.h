//
//  LegalPersonViewController.h
//  Shaolin
//
//  Created by edz on 2020/4/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class StoreInformationModel;
@interface LegalPersonViewController : RootViewController
@property(nonatomic,strong) StoreInformationModel *model;
@property (nonatomic,copy) void (^LegaalPersonBlock)(NSString *stepStr, NSString *idCardNum);
@end

NS_ASSUME_NONNULL_END

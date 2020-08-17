//
//  StoreThreeViewController.h
//  Shaolin
//
//  Created by edz on 2020/4/14.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class StoreInformationModel;
@interface StoreThreeViewController : RootViewController
@property(nonatomic,strong) NSString *stepStr;
@property(nonatomic,strong) NSDictionary *dataDic;
@property(nonatomic,strong) NSString *statusStr;
@property(nonatomic,strong) StoreInformationModel *model;
@end

NS_ASSUME_NONNULL_END

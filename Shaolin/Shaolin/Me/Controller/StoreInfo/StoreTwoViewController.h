//
//  StoreTwoViewController.h
//  Shaolin
//
//  Created by edz on 2020/4/13.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class StoreInformationModel;
@interface StoreTwoViewController : RootViewController
@property(nonatomic,strong) NSString *stepStr;
@property(nonatomic,strong) NSDictionary *dataDic;
@property(nonatomic,strong) StoreInformationModel *model;
@end

NS_ASSUME_NONNULL_END

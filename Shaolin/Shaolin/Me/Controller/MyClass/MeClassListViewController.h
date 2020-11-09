//
//  MeClassListViewController.h
//  Shaolin
//
//  Created by 王精明 on 2020/6/1.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN
@interface MeClassListViewController : RootViewController
//@property (nonatomic, copy) void(^ cellSelectBlock)(NSObject *model);
@property (nonatomic) NSInteger identifier;
@property (nonatomic, copy) NSString *currentTitle;
@end

extern NSString * const MeClassListViewControllerReloadData;
NS_ASSUME_NONNULL_END

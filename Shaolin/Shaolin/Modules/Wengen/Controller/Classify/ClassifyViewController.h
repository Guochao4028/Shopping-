//
//  ClassifyViewController.h
//  Shaolin
//
//  Created by 郭超 on 2020/3/23.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class WengenEnterModel;

@interface ClassifyViewController : RootViewController

@property(nonatomic, copy)NSString *keyWordStr;

@property(nonatomic, strong)WengenEnterModel *enterModel;

-(void)refreshUI;

@end

NS_ASSUME_NONNULL_END
